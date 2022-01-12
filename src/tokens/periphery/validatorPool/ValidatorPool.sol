// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.9;
import "../../interfaces/INFTStake.sol";
import "../../interfaces/IERC20Transferable.sol";
import "../../interfaces/IERC721Transferable.sol";
import "../../utils/EthSafeTransfer.sol";
import "../../utils/ERC20SafeTransfer.sol";

contract ValidatorPoolTrue is EthSafeTransfer, ERC20SafeTransfer {

    event ValidatorAdded(address indexed account, uint256 validatorNFT);
    event ValidatorRemoved(address indexed account);

    // _maxMintLock describes the maximum interval a Position may be locked
    // during a call to mintTo
    uint256 public constant MAX_MINT_LOCK = 1051200;

    struct ValidatorData {
        uint128 index;
        uint128 tokenID;
    }

    // Minimum amount to stake
    uint256 internal _minimumStake;
    // Max number of validators in the pool
    uint256 internal _maxNumValidators;


    INFTStake internal _stakeNFT;
    INFTStake internal _validatorsNFT;
    IERC20Transferable internal _madToken;

    // todo: lock writes to this variable once an ETHDKG has started
    // validators Pool
    address[] internal _validators;
    mapping(address=>ValidatorData) internal _validatorsData;

    address _admin;

    constructor(
        INFTStake stakeNFT_,
        INFTStake validatorNFT_,
        IERC20Transferable madToken_,
        bytes memory hook
    ) {
        //20000*10**18 MadWei = 20k MadTokens
        _minimumStake = 20000*10**18;
        _maxNumValidators = 5;
        _stakeNFT = stakeNFT_;
        _madToken = madToken_;
        _validatorsNFT = validatorNFT_;
        _admin = msg.sender;
    }

    // todo: onlyAdmin or onlyGovernance?
    modifier onlyAdmin() {
        require(msg.sender == _admin, "Validators: requires admin privileges");
        _;
    }

    function setMinimumStake(uint256 minimumStake_) public onlyAdmin {
        _minimumStake = minimumStake_;
    }

    function setMaxNumValidators(uint256 maxNumValidators_) public onlyAdmin {
        _maxNumValidators = maxNumValidators_;
    }

    function getValidatorsCount() public view returns(uint256) {
        return _validators.length;
    }

    function getValidator(uint256 index) public view returns(address) {
        require(index < _validators.length, "Index out boundaries!");
        return _validators[index];
    }

    function isValidator(address participant) public view returns(bool) {
        return _isValidator(participant);
    }

    function _isValidator(address participant) internal view returns(bool) {
        uint256 index = _validatorsData[participant].index;
        return index < _validators.length && _validators[index] == participant;
    }

    function _swapStakeNFTForValidatorNFT(address to_, uint256 stakerTokenID_)
        internal
        returns (
            uint256 validatorTokenID,
            uint256 payoutEth,
            uint256 payoutToken
        )
    {
        require(!_isValidator(to_), "The user is already a ValidatorNFT Position!");
        (uint256 stakeShares,,,,) = _stakeNFT.getPosition(stakerTokenID_);
        require(
            stakeShares >= _minimumStake,
            "ValidatorStakeNFT: Error, the Stake position doesn't have enough founds!"
        );
        IERC721Transferable(address(_stakeNFT)).safeTransferFrom(msg.sender, address(this), stakerTokenID_);
        (payoutEth, payoutToken) = _stakeNFT.burn(stakerTokenID_);

        // Subtracting the shares from StakeNFT profit. The shares will be used to mint the new
        // ValidatorPosition
        payoutToken -= stakeShares;

        // We should approve the StakeNFT to transferFrom the tokens of this contract
        _madToken.approve(address(_validatorsNFT), stakeShares);
        validatorTokenID = _validatorsNFT.mint(stakeShares);

        _validators.push(to_);
        _validatorsData[msg.sender] = ValidatorData(uint128(_validators.length-1), uint128(validatorTokenID));

        // transfer back any profit that was available for the stakeNFT position by the time that we
        // burned it
        _safeTransferERC20(_madToken, to_, payoutToken);
        _safeTransferEth(to_, payoutEth);

        emit ValidatorAdded(to_, validatorTokenID);

        return (validatorTokenID, payoutEth, payoutToken);

    }

    function collectProfits() external returns (uint256 payoutEth, uint256 payoutToken)
    {
        uint256 validatorTokenID = _validatorsData[msg.sender].tokenID;
        require(validatorTokenID > 0, "Error, no position was found for address!");
        payoutEth = _validatorsNFT.collectEthTo(msg.sender, validatorTokenID);
        payoutToken = _validatorsNFT.collectTokenTo(msg.sender, validatorTokenID);
    }

    // _burn performs the burn operation and invokes the inherited _burn method
    function _swapValidatorNFTForStakeNFT(
        address to_,
        uint256 validatorTokenID_
    )
        internal
        returns (
            uint256 stakeTokenID,
            uint256 payoutEth,
            uint256 payoutToken
        )
    {
        require(_validatorsData[msg.sender].tokenID == validatorTokenID_, "The caller is not the ValidatorNFT owner!");
        (uint256 minerShares,,,,) = _validatorsNFT.getPosition(validatorTokenID_);

        //IERC721Transferable(address(_validatorsNFT)).safeTransferFrom(msg.sender, address(this), validatorTokenID_);
        (payoutEth, payoutToken) = _validatorsNFT.burn(validatorTokenID_);
        payoutToken -= minerShares;

        // We should approve the StakeNFT to transferFrom the tokens of this contract
        _madToken.approve(address(_stakeNFT), minerShares);
        // Notice that we are not summing the shared to the payoutToken because we will use this
        // amount to mint a new NFT in the StakeNFT contract.
        stakeTokenID = _stakeNFT.mint(minerShares);

        _safeTransferERC20(_madToken, to_, payoutToken);
        _safeTransferEth(to_, payoutEth);

        emit ValidatorRemoved(to_);

        return (stakeTokenID, payoutEth, payoutToken);
    }

    function _removeValidatorFromPool(uint128 index) internal {
        uint256 lastIndex = _validators.length - 1;
        address lastAddress = _validators[lastIndex];
        // Move last address in 'validators' to the spot this validator is relinquishing
        if (lastIndex != index) {
            _validatorsData[lastAddress].index = index;
            _validators[index] = lastAddress;
        }
        _validators.pop();
    }

    function claimStakeNFTPosition() public returns(uint256 stakeTokenID) {
        //require(time has passed)
        //get stakeNFT in this contract using msg.sender
    }

    // todo: replace modifier
    // todo: should we receive an address to send the reward to?
    // todo: emit an event
    // todo: add balance checks in the ETHDKG accusation unit tests
    function majorSlash(address participant) public onlyAdmin {

    }

    // todo: replace modifier
    // todo: reward caller for taking this awesome action
    // todo: should we receive an address to send the reward to?
    // todo: emit an event
    function minorSlash(address participant) public onlyAdmin {

    }

    function initializeETHDKG() external {
        //todo: require that ETHDKG is not running
        // require(_ethdkg.isAccusationWindowOver(), "cannot init ETHDKG at the moment");
        // _ethdkg._initializeState();
    }

    // baseBlock = msg.block;
    // if !dutchAuction && freeSlotsInValidatorPool{
    //     emit StartDutchAuction();
    // }

    // event StartDutchAuction();
    // uint256 basePrice = 2 ether;
    // uint256 baseBlock;
    // bool dutchAuction;
    // function dutchAuctionPrice() view public returns(uint256){
    //     uint256 price = 100*basePrice/(msg.block - baseBlock);
    //     if snapshotEpoch == 0 {
    //         return 0;
    //     }
    //     return price;
    // }

    // function dutchAuctionBid(uint256 StakeTokenNFT) payable external {
    //     require(msg.value > price);
    //     //become validator
    //     //reset dutch auction
    //     baseBlock = msg.block;
    //     if freeSlotsInValidatorPool {
    //         emit StartDutchAuction();
    //     }
    // }

    // function validatorLeave() payable external {
    //     emit StartDutchAuction();
    // }
}

// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "../interfaces/INFTStake.sol";
import "../interfaces/IERC20Transferable.sol";
import "../interfaces/IERC721Transferable.sol";
import "../utils/EthSafeTransfer.sol";
import "../utils/ERC20SafeTransfer.sol";

contract ValidatorPool is Initializable, UUPSUpgradeable, EthSafeTransfer, ERC20SafeTransfer {
    // _maxMintLock describes the maximum interval a Position may be locked
    // during a call to mintTo
    uint256 constant _maxMintLock = 1051200;

    // Minimum amount to stake
    uint256 internal _minimumStake = 200000;

    enum ValidatorState {
        QUEUED,
        VALIDATOR
    }

    INFTStake internal _stakeNFT;
    INFTStake internal _validatorsNFT;
    IERC20Transferable internal _madToken;
    uint256 internal _testVar;

    function initialize(
        INFTStake stakeNFT_,
        INFTStake validatorNFT_,
        IERC20Transferable madToken_
    ) public initializer {
        _stakeNFT = stakeNFT_;
        _madToken = madToken_;
        _validatorsNFT = validatorNFT_;
        __UUPSUpgradeable_init();
    }

    // todo: onlyAdmin or onlyGovernance?
    function _authorizeUpgrade(address newImplementation) internal onlyAdmin override {

    }

    modifier onlyAdmin() {
        require(msg.sender == _getAdmin(), "Validators: requires admin privileges");
        _;
    }

    //todo: will be the slashing/fine events be handled here? If yes, how and who should be allowed to call that?

    /// @dev tripCB opens the circuit breaker may only be called by _admin
    function setMinimumStake(uint256 minimumStake_) public onlyAdmin {
        _minimumStake = minimumStake_;
    }

    function isValidator() public view {

    }

    /* function _registerValidator(address to_, uint256 stakerTokenID_)
        internal
        returns (
            uint256 validatorTokenID,
            uint256 payoutEth,
            uint256 payoutToken
        )
    {
        uint256 stakeShares = _stakeNFT.getPositionShares(stakerTokenID_);
        require(
            stakeShares >= _minimumStake,
            "ValidatorStakeNFT: Error, the Stake position doesn't have enough founds!"
        );
        IERC721Transferable(address(_stakeNFT)).safeTransferFrom(msg.sender, address(this), stakerTokenID_);
        (payoutEth, payoutToken) = _stakeNFT.burn(stakerTokenID_);

        //Subtracting the shares from StakeNFT profit. The shares will be used to mint the new ValidatorPosition
        payoutToken -= stakeShares;

        // We should approve the StakeNFT to transferFrom the tokens of this contract
        _madToken.approve(address(_validatorsNFT), stakeShares);
        validatorTokenID = _validatorsNFT.mint(stakeShares);

        // transfer back any profit that was available for the stakeNFT position by the
        // time that we burned it
        _safeTransferERC20(_madToken, to_, payoutToken);
        _safeTransferEth(to_, payoutEth);
        return (validatorTokenID, payoutEth, payoutToken);
    }

    // _burn performs the burn operation and invokes the inherited _burn method
    function _unregisterValidator(
        address from_,
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
        uint256 minerShares = _validatorsNFT.getPositionShares(validatorTokenID_);

        IERC721Transferable(address(_validatorsNFT)).safeTransferFrom(msg.sender, address(this), validatorTokenID_);
        (payoutEth, payoutToken) = _validatorsNFT.burn(validatorTokenID_);
        payoutToken -= minerShares;

        // We should approve the StakeNFT to transferFrom the tokens of this contract
        _madToken.approve(address(_stakeNFT), minerShares);
        // Notice that we are not summing the shared to the payoutToken because
        // we will use this amount to mint a new NFT in the StakeNFt contract.
        stakeTokenID = _stakeNFT.mintTo(to_, minerShares, _maxMintLock);
        // transfer out all eth and tokens owed
        _safeTransferERC20(_madToken, to_, payoutToken);
        _safeTransferEth(to_, payoutEth);
        return (stakeTokenID, payoutEth, payoutToken);
    } */

}

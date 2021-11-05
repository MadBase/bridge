// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "lib/ds-test/test.sol";

import "src/governance/GovernanceManager.sol";
import "src/governance/GovernanceMaxLock.sol";
import "src/governance/GovernanceProposal.sol";
import "src/governance/GovernanceStorage.sol";
import "src/governance/Governance.sol";
import "src/tokens/StakeNFT.sol";
import "src/tokens/interfaces/INFTStake.sol";
import "lib/openzeppelin/token/ERC20/ERC20.sol";
import "./GovernanceProposeModifySnapshot.t.sol";
import "src/diamonds/facets/EthDKGLibrary.sol";

contract GovernanceProposeRestartETHDKGCopy is GovernanceProposal {

    // PROPOSALS MUST NOT HAVE ANY STATE VARIABLE TO AVOID POTENTIAL STORAGE
    // COLLISION!

    /// @dev function that is called when a proposal is executed. It's only
    /// meant to be called by the Governance Manager contract. See the
    /// GovernanceProposal.sol file fore more details.
    function execute(address self) public override returns(bool) {
        // Replace the following line with the address of the ETHDKG Diamond.
        address target = 0xEFc56627233b02eA95bAE7e19F648d7DcD5Bb132;
        (bool success, ) = target.call(abi.encodeWithSignature("modifyDiamondStorage(address)", self));
        require(success, "GovernanceProposeModifySnapshot: CALL FAILED!");
        return success;
    }

    /// @dev function that is called back by another contract with DELEGATE CALL
    /// rights! See the GovernanceProposal.sol file fore more details. PLACE THE
    /// LOGIC TO RESTART THE ETHDKG IN HERE!
    function callback() public override returns(bool) {
        EthDKGLibrary.initializeState();
        return true;
    }
}

contract GovernanceProposeRestartETHDKGTest is DSTest, Setup {

    uint representativeNumber;

    function getFixtureData()
        internal
        returns (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        )
    {

        admin = new AdminAccount();
        AdminAccount adminMiner = new AdminAccount();
        madToken = new MadTokenMock(address(this));
        stakeNFT = new StakeNFT(
            IERC20Transfer(address(madToken)),
            address(admin),
            address(address(0x0))
        );
        minerStake = MinerStake(address (new StakeNFT(
            IERC20Transfer(address(madToken)),
            address(adminMiner),
            address(address(0x0))
        )));
        governanceManager = new GovernanceManager(address(stakeNFT), address(minerStake));
        admin.setTokens(madToken, stakeNFT, governanceManager);
        adminMiner.setTokens(madToken, StakeNFT(address(minerStake)), governanceManager);
    }

    function newUserAccount(MadTokenMock madToken, StakeNFT stakeNFT, GovernanceManager governanceManager)
        private
        returns (UserAccount acct)
    {
        acct = new UserAccount();
        acct.setTokens(madToken, stakeNFT, governanceManager);
    }

    function setBlockNumber(uint256 bn) internal returns (bool) {
        // https://github.com/dapphub/dapptools/tree/master/src/hevm#cheat-codes
        address externalContract = address(
            0x7109709ECfa91a80626fF3989D68f67F5b1DD12D
        );
        (bool success, /*bytes memory returnedData*/) = externalContract.call(
            abi.encodeWithSignature("roll(uint256)", bn)
        );

        return success;
    }

    function assertProposal(GovernanceStorage.Proposal memory actual, GovernanceStorage.Proposal memory expected) public {
        assertTrue(actual.executed == expected.executed);
        assertEq(actual.logic, expected.logic);
        assertEq(actual.voteCount, expected.voteCount);
        assertEq(actual.blockEndVote, expected.blockEndVote);
    }

    function testExecuteRestartETHDKG() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();
        sudoETHDKG.setGovernance(address(governanceManager));
        GovernanceProposeRestartETHDKGCopy logic = new GovernanceProposeRestartETHDKGCopy();
        emit log_named_address("Contract address", address(logic));
        emit log_named_address("Snapshot address", address(ethdkg));

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));
        // We can only vote after 1 block has passed from the proposal creation
        setBlockNumber(block.number +1);
        for (uint256 i =0; i < 10; i++){
            UserAccount user = newUserAccount(madToken, stakeNFT, governanceManager);
            madToken.approve(address(stakeNFT), 11_220_000 * 10**18);
            uint256 tokenID = stakeNFT.mintTo(address(user), 11_220_000 * 10**18, 1);
            user.voteAsStaker(proposalID, tokenID);
        }

        governanceManager.execute(proposalID);
        assertTrue(governanceManager.isProposalExecuted(proposalID));
    }

    function testFail_ExecuteProposalRestartETHDKGWithoutPermission() public {
        sudoETHDKG.modifyDiamondStorage(address(this));
    }
}

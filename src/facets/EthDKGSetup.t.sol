// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "./EthDKGCompletionFacet.sol";
import "./EthDKGGroupAccusationFacet.sol";
import "./EthDKGInitializeFacet.sol";
import "./EthDKGMiscFacet.sol";
import "./EthDKGSubmitDisputeFacet.sol";
import "./EthDKGSubmitMPKFacet.sol";

import "../EthDKGConstants.sol";
import "../EthDKGDiamond.sol";

import "../interfaces/ETHDKG.sol";

contract EthDKGSetup is Constants, EthDKGConstants {

    uint constant INITIAL_AMOUNT = 1_000_000_000_000_000_000_000_000;
    uint constant MINIMUM_STAKE = 999_999_999;

    Registry registry;

    ETHDKG ethdkg;
    DiamondUpdateFacet update;

    Validators validators;

    address diamond;

    function setUp() public {

        diamond = address(new EthDKGDiamond());
        update = DiamondUpdateFacet(diamond);
        registry = new Registry();

        address accusationFacet = address(new EthDKGGroupAccusationFacet());
        address completionFacet = address(new EthDKGCompletionFacet());
        address initFacet = address(new EthDKGInitializeFacet());
        address mpkFacet = address(new EthDKGSubmitMPKFacet());
        address disputeFacet = address(new EthDKGSubmitDisputeFacet());
        address miscFacet = address(new EthDKGMiscFacet());

        // EthDKGSub
        update.addFacet(ETHDKG.Group_Accusation_GPKj.selector, accusationFacet);
        update.addFacet(ETHDKG.Successful_Completion.selector, completionFacet);
        update.addFacet(ETHDKG.initializeEthDKG.selector, initFacet);
        update.addFacet(ETHDKG.submit_dispute.selector, disputeFacet);
        update.addFacet(ETHDKG.submit_master_public_key.selector, mpkFacet);

        update.addFacet(ETHDKG.register.selector, miscFacet);
        update.addFacet(ETHDKG.distribute_shares.selector, miscFacet);
        update.addFacet(ETHDKG.submit_key_share.selector, miscFacet);
        update.addFacet(ETHDKG.Submit_GPKj.selector, miscFacet);


        // registry.register(CRYPTO_CONTRACT, address(new Crypto()));

        // registry.register(STAKING_CONTRACT, diamond);
        // registry.register(VALIDATORS_CONTRACT, diamond);

        // Wiring
    }

}

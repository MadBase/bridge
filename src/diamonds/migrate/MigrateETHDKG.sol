// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma abicoder v2;

import "../facets/AccessControlLibrary.sol";
import "../facets/EthDKGLibrary.sol";

contract MigrateETHDKG is AccessControlled {

    function migrate(
        uint256 _epoch,
        uint32 _ethHeight,
        uint32 _madHeight,
        uint256[4] memory _master_public_key,
        address[] memory _addresses,
        uint256[4][] memory _gpkj
    ) external onlyOperator {

        EthDKGLibrary.EthDKGStorage storage es = EthDKGLibrary.ethDKGStorage();

        es.addresses = _addresses;
        es.master_public_key = _master_public_key;

        emit EthDKGLibrary.ValidatorSet(
            uint8(_addresses.length),
            _epoch,
            _ethHeight,
            _madHeight,
            _master_public_key[0],
            _master_public_key[1],
            _master_public_key[2],
            _master_public_key[3]
        );

        for (uint256 idx; idx<_addresses.length; idx++) {

            address addr = _addresses[idx];

            es.gpkj_submissions[addr] = _gpkj[idx];

            emit EthDKGLibrary.ValidatorMember(
                addr,
                _epoch,
                idx+1,
                _gpkj[idx][0],
                _gpkj[idx][1],
                _gpkj[idx][2],
                _gpkj[idx][3]
            );
        }
    }

}
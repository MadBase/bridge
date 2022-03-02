import {
  Fixture,
  getValidatorEthAccount,
  getFixture,
  factoryCallAny,
} from "../../setup";
import { completeETHDKGRound } from "../../ethdkg/setup";
import { expect } from "../../chai-setup";
import { validatorsSnapshots } from "../../snapshots/assets/4-validators-snapshots-1";
import { validatorsSnapshots as validatorsSnapshots2 } from "../../snapshots/assets/4-validators-snapshots-2";
import { BigNumber, Signer } from "ethers";
import { SnapshotsMock } from "../../../typechain-types";
import {
  claimPosition,
  commitSnapshots,
  createValidators,
  getCurrentState,
  showState,
  stakeValidators,
} from "../setup";

describe("ValidatorPool: Consensus dependent logic ", async () => {
  let fixture: Fixture;
  let adminSigner: Signer;
  let validators: string[];
  let stakingTokenIds: BigNumber[];

  beforeEach(async function () {
    fixture = await getFixture(false, true, true);
    const [admin, , ,] = fixture.namedSigners;
    adminSigner = await getValidatorEthAccount(admin.address);
    validators = await createValidators(fixture, validatorsSnapshots);
    stakingTokenIds = await stakeValidators(fixture, validators);
  });

  it("Initialize ETHDKG", async function () {
    await factoryCallAny(fixture, "validatorPool", "registerValidators", [
      validators,
      stakingTokenIds,
    ]);
    await factoryCallAny(fixture, "validatorPool", "initializeETHDKG");
  });

  xit("Should not allow pausing “consensus” before 1.5 without snapshots.", async function () {
    await fixture.validatorPool
      .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
      .pauseConsensus();

    // await expect(factoryCallAny(fixture, "snapshots",
    //   "pauseConsensus"))
    //   .to.be.revertedWith("ValidatorPool: Condition not met to stop consensus!");
  });

  it("Complete ETHDKG and check if the necessary state was set properly", async function () {
    await factoryCallAny(fixture, "validatorPool", "registerValidators", [
      validators,
      stakingTokenIds,
    ]);
    // Complete ETHDKG Round
    await factoryCallAny(fixture, "validatorPool", "initializeETHDKG");
    await completeETHDKGRound(validatorsSnapshots, {
      ethdkg: fixture.ethdkg,
      validatorPool: fixture.validatorPool,
    });
    expect(await fixture.validatorPool.isMaintenanceScheduled()).to.be.false;
    //Consensus Running should be true
    await expect(
      factoryCallAny(fixture, "validatorPool", "registerValidators", [
        validators,
        stakingTokenIds,
      ])
    ).to.be.revertedWith(
      "ValidatorPool: Error Madnet Consensus should be halted!"
    );
  });

  it("Should not allow start ETHDKG if consensus is true or and ETHDKG round is running.", async function () {
    await factoryCallAny(fixture, "validatorPool", "registerValidators", [
      validators,
      stakingTokenIds,
    ]);
    // Complete ETHDKG Round
    await factoryCallAny(fixture, "validatorPool", "initializeETHDKG");
    await completeETHDKGRound(validatorsSnapshots, {
      ethdkg: fixture.ethdkg,
      validatorPool: fixture.validatorPool,
    });
    await expect(
      factoryCallAny(fixture, "validatorPool", "initializeETHDKG")
    ).to.be.revertedWith(
      "ValidatorPool: Error Madnet Consensus should be halted!"
    );
  });

  xit("Admin should be able to send Madtokens and eth sent to the contract accidentally.", async function () {
    const user = await getValidatorEthAccount(validatorsSnapshots[0]);
    await fixture.madToken
      .connect(user)
      .transferFrom(await user.getAddress(), fixture.madToken.address, 1);
    showState(
      "after accidentally sending MAD",
      await getCurrentState(fixture, validators)
    );
    await fixture.madToken
      .connect(adminSigner)
      .transfer(await user.getAddress(), 1);
    showState(
      "after recovering it",
      await getCurrentState(fixture, validators)
    );
  });

  xit("Test running ETHDKG with the arbitrary height sent as input, see if the value (the arbitrary height) is correctly added to the ethdkg completion event.", async function () {
    await factoryCallAny(fixture, "validatorPool", "registerValidators", [
      validators,
      stakingTokenIds,
    ]);
    // Complete ETHDKG Round
    await factoryCallAny(fixture, "validatorPool", "initializeETHDKG");
    await completeETHDKGRound(validatorsSnapshots, {
      ethdkg: fixture.ethdkg,
      validatorPool: fixture.validatorPool,
    });
    // await factoryCallAny(fixture, "snapshots",
    // "setCommittedHeightFromLatestSnapshot",[221])
    let snp = fixture.snapshots as SnapshotsMock;

    await factoryCallAny(
      fixture,
      "validatorPool",
      "pauseConsensusOnArbitraryHeight",
      [4]
    );
    await commitSnapshots(fixture, 4);
    await expect(
      // fixture.ethdkg.
      //   connect(await getValidatorEthAccount(validatorsSnapshots[0])).
      //   setCustomMadnetHeight(4)
      factoryCallAny(fixture, "validatorPool", "setCustomMadnetHeight", [4])
    )
      .to.emit(fixture.ethdkg, "ValidatorSetCompleted")
      .withArgs(
        0,
        0,
        fixture.snapshots.getEpoch(),
        fixture.snapshots.getCommittedHeightFromLatestSnapshot(),
        fixture.snapshots.getMadnetHeightFromSnapshot(
          await fixture.snapshots.getEpoch()
        ),
        0x0,
        0x0,
        0x0,
        0x0
      );
  });
  it("Check if consensus is halted after maintenance is scheduled and snapshot is done.", async function () {
    await factoryCallAny(fixture, "validatorPool", "registerValidators", [
      validators,
      stakingTokenIds,
    ]);
    await showState(
      "after registering",
      await getCurrentState(fixture, validators)
    );
    let expectedState = await getCurrentState(fixture, validators);
    // Complete ETHDKG Round
    await factoryCallAny(fixture, "ethdkg", "initializeETHDKG");
    await showState(
      "after initializing",
      await getCurrentState(fixture, validators)
    );
    await completeETHDKGRound(validatorsSnapshots, {
      ethdkg: fixture.ethdkg,
      validatorPool: fixture.validatorPool,
    });
    await factoryCallAny(fixture, "validatorPool", "scheduleMaintenance");
    await commitSnapshots(fixture, 1);
    expect(await fixture.validatorPool.isConsensusRunning()).to.be.false;
  });

  it("Register validators, run ethdkg, schedule maintenance, do a snapshot, replace some validators, and rerun ethdkg", async function () {
    await factoryCallAny(fixture, "validatorPool", "registerValidators", [
      validators,
      stakingTokenIds,
    ]);
    await showState(
      "after registering",
      await getCurrentState(fixture, validators)
    );
    let expectedState = await getCurrentState(fixture, validators);
    // // Complete ETHDKG Round
    await factoryCallAny(fixture, "ethdkg", "initializeETHDKG");
    await showState(
      "After initializing",
      await getCurrentState(fixture, validators)
    );
    await completeETHDKGRound(validatorsSnapshots, {
      ethdkg: fixture.ethdkg,
      validatorPool: fixture.validatorPool,
    });
    await factoryCallAny(fixture, "validatorPool", "scheduleMaintenance");
    await commitSnapshots(fixture, 1);
    expect(await fixture.validatorPool.isConsensusRunning()).to.be.false;
    await showState(
      "After maintenance",
      await getCurrentState(fixture, validators)
    );
    await factoryCallAny(fixture, "validatorPool", "unregisterValidators", [
      validators,
    ]);
    await showState(
      "After unregistering",
      await getCurrentState(fixture, validators)
    );
    await commitSnapshots(fixture, 4);
    for (const validator of validatorsSnapshots) {
      await claimPosition(fixture, validator);
    }
    // Re mint positions
    let newValidators = await createValidators(fixture, validatorsSnapshots2);
    let newStakeNFTIDs = await stakeValidators(fixture, newValidators);
    await factoryCallAny(fixture, "validatorPool", "registerValidators", [
      newValidators,
      newStakeNFTIDs,
    ]);
    await showState(
      "After registering",
      await getCurrentState(fixture, validators)
    );
    let currentState = await getCurrentState(fixture, validators);
    await factoryCallAny(fixture, "ethdkg", "initializeETHDKG");
    await showState(
      "After initializing",
      await getCurrentState(fixture, validators)
    );
    await completeETHDKGRound(validatorsSnapshots2, {
      ethdkg: fixture.ethdkg,
      validatorPool: fixture.validatorPool,
    },
    5);
  });
});

import { getFixture } from "./setup";
import { assertAdminMinting, assertFailsNotAdminMinting } from "./setup";
import { assertAdminMintingTo, assertFailsNotAdminMintingTo } from "./setup";
import { assertAdminBurning, assertFailsNotAdminBurning } from "./setup";
import { assertAdminBurningTo, assertFailsNotAdminBurningTo } from "./setup";

describe("Tests ValidatorNFT methods", () => {

  it("Should mint a token and send staking funds from sender address if sender is admin", async function () {
    const fixture = await getFixture();
    await assertAdminMinting(fixture.validatorNFT, fixture.madToken, fixture.namedSigners);
  });

  it("Should fail to mint a token and send staking funds from sender address if sender is not admin", async function () {
    const fixture = await getFixture();
    await assertFailsNotAdminMinting(fixture.validatorNFT, fixture.madToken, fixture.namedSigners);
  });

  it("Should burn a token and send staking funds to sender address if sender is admin", async function () {
    const fixture = await getFixture();
    await assertAdminBurning(fixture.validatorNFT, fixture.madToken, fixture.namedSigners);
  });

  it("Should fail to burn a token and send staking funds to sender address if sender is not admin", async function () {
    const fixture = await getFixture();
    await assertFailsNotAdminBurning(fixture.validatorNFT, fixture.madToken, fixture.namedSigners);
  });

  it("Should mint a token and send staking funds from an address if sender is admin", async function () {
    const fixture = await getFixture();
    await assertAdminMintingTo(fixture.validatorNFT, fixture.madToken, fixture.namedSigners);
  });

  it("Should fail to mint a token and send staking funds from an address if sender is not admin", async function () {
    const fixture = await getFixture();
    await assertFailsNotAdminMintingTo(fixture.validatorNFT, fixture.madToken, fixture.namedSigners);
  });

  it("Should burn a token and send staking funds to an address if sender is admin", async function () {
    const fixture = await getFixture();
    await assertAdminBurningTo(fixture.validatorNFT, fixture.madToken, fixture.namedSigners);
  });

  it("Should fail to burn a token and send staking funds to an address if sender is not admin", async function () {
    const fixture = await getFixture();
    await assertFailsNotAdminBurningTo(fixture.validatorNFT, fixture.madToken, fixture.namedSigners);
  });

});

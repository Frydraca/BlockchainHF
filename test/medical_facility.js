const MedicalFacility = artifacts.require("MedicalFacility");
const truffleAssert = require("truffle-assertions");

contract("MedicalFacility", async (accounts) => {
  let mf;
  beforeEach("setup the medical facility", async () => {
    mf = await MedicalFacility.deployed();
  });

  it("should make the first account a doctor", async () => {
    await mf.setUpDoctors([accounts[0]]);
    const firstDoc = await mf.getDoc.call(0);
    assert.equal(firstDoc, accounts[0], "the first account wasn't a doctor");
  });

  it("not owner shouldn't make the first account a doctor", async () => {
    await truffleAssert.reverts(
      mf.setUpDoctors([accounts[0]], { from: accounts[7] })
    );
  });
});

const MedicalFacility = artifacts.require("MedicalFacility");

contract("MedicalFacility", async (accounts) => {
  it("should make the first account a doctor", async () => {
    const mf = await MedicalFacility.deployed();
    await mf.setUpDoctors([accounts[0]]);
    const firstDoc = await mf.getDoc.call(0);
    assert.equal(firstDoc, accounts[0], "the first account wasn't a doctor");
  });
});

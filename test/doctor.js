const Doctor = artifacts.require("Doctor");

contract("Doctor", async (accounts) => {
  it("should assign a new vaccine to the second account", async () => {
    const date = new Date();
    date.setHours(date.getHours() + 1);
    const doc = await Doctor.deployed();

    // The tests are run from accounts[0], important because we need a doctor
    await doc.setUpDoctors([accounts[0]]);

    await doc.issueVaccinationSlot(0, date.getTime(), accounts[1]);
    let slot = await doc.vaccinationSlots.call(0);
    let vaccineOfPatient = await doc.ownerToVaccine.call(accounts[1]);
    let numberOfVaccinationSlots = await doc.getNumberOfVaccinationSlots.call();

    assert.equal(slot.vaccineType, 0, "wrong vaccination type");
    assert.equal(slot.date, date.getTime(), "wrong date");
    assert.equal(
      vaccineOfPatient,
      numberOfVaccinationSlots - 1,
      "owner has wrong vaccine"
    );
  });
});

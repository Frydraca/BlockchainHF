const Doctor = artifacts.require("Doctor");

contract("Doctor", async (accounts) => {
  it("should assign a new vaccine to the second account", async () => {
    const date = new Date();
    date.setHours(date.getHours() + 1);
    const doc = await Doctor.deployed();

    await doc.setUpDoctors([accounts[3]]);

    await doc.issueVaccinationSlot(1, date.getTime(), accounts[1], {
      from: accounts[3],
    });
    let slot = await doc.vaccinationSlots.call(1);
    let vaccineOfPatient = await doc.ownerToVaccine.call(accounts[1]);
    let numberOfVaccinationSlots = await doc.getNumberOfVaccinationSlots.call();

    assert.equal(slot.vaccineType, 1, "wrong vaccination type");
    assert.equal(slot.date, date.getTime(), "wrong date");
    assert.equal(
      vaccineOfPatient,
      numberOfVaccinationSlots - 1,
      "owner has wrong vaccine"
    );
  });
});

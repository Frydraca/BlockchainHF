const Doctor = artifacts.require("Doctor");

contract("Doctor", async (accounts) => {
  let doc;
  let docAccountNumber;
  let date;
  beforeEach("setup the doctor and vaccines for account 1-2", async () => {
    doc = await Doctor.deployed();
    docAccountNumber = 5;
    await doc.setUpDoctors([accounts[docAccountNumber]]);
    date = new Date();
    date.setHours(date.getHours() + 1);

    await doc.issueVaccinationSlot(2, date.getTime(), accounts[1], {
      from: accounts[docAccountNumber],
    });
    await doc.issueVaccinationSlot(1, date.getTime(), accounts[2], {
      from: accounts[docAccountNumber],
    });
  });

  it("should assign a new vaccine to the first account", async () => {
    let slot = await doc.vaccinationSlots.call(1);
    let vaccineOfPatient = await doc.ownerToVaccine.call(accounts[1]);

    assert.equal(slot.vaccineType, 2, "wrong vaccination type");
    assert.equal(Number(slot.date), date.getTime(), "wrong date");
    assert.equal(vaccineOfPatient, 1, "owner has wrong vaccine");
  });

  it("should do a first time injection", async () => {
    const secondDate = new Date(date);
    secondDate.setMonth(secondDate.getMonth() + 1);

    let oldVaccineId = await doc.ownerToVaccine.call(accounts[1]);

    await doc.injectVaccine(accounts[1], { from: accounts[docAccountNumber] });

    let vaccineId = await doc.ownerToVaccine.call(accounts[1]);

    let vaccineOfPatient = await doc.vaccinationSlots.call(vaccineId);
    let oldVaccine = await doc.vaccinationSlots.call(oldVaccineId);

    assert.equal(
      vaccineOfPatient.remaining,
      1,
      "wrong vaccination remaining value"
    );
    assert.equal(vaccineOfPatient.vaccineType, 2, "wrong vaccine type");
    assert.equal(
      Number(vaccineOfPatient.date),
      secondDate.getTime(),
      "wrong vaccine date"
    );
    assert.equal(oldVaccine.validity, false, "old vaccine is still valid");
  });

  it("should do a one time injection", async () => {
    let oldVaccineId = await doc.ownerToVaccine.call(accounts[2]);

    await doc.injectVaccine(accounts[2], { from: accounts[docAccountNumber] });

    let vaccineId = await doc.ownerToVaccine.call(accounts[2]);

    let oldVaccine = await doc.vaccinationSlots.call(oldVaccineId);

    assert.equal(vaccineId, 0, "a new vaccine was assigned falsely");
    assert.equal(oldVaccine.validity, false, "old vaccine is still valid");
  });
});

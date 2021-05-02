const VaccinationSlots = artifacts.require("VaccinationSlots");

contract("VaccinationSlots", async (accounts) => {
  let date1;
  let date2;
  let vS;
  beforeEach("setting up two vaccines", async () => {
    date1 = new Date();
    date1.setHours(date1.getHours() + 1);
    date2 = new Date();
    date2.setHours(date2.getHours() + 7);

    vS = await VaccinationSlots.deployed();
    await vS.setUpDoctors([accounts[0]]);

    await vS.issueVaccinationSlot(1, date1.getTime(), accounts[1], {
      from: accounts[0],
    });
    await vS.issueVaccinationSlot(2, date2.getTime(), accounts[2], {
      from: accounts[0],
    });
  });

  it("should trade the vaccines assigned to account 1 and 2", async () => {
    await vS.requestTrade(accounts[2], {
      from: accounts[1],
    });
    await vS.trade(accounts[1], {
      from: accounts[2],
    });

    let vaccineOfAccount1 = await vS.ownerToVaccine.call(accounts[1]);
    let vaccineOfAccount2 = await vS.ownerToVaccine.call(accounts[2]);
    let slotOfAcc1 = await vS.vaccinationSlots.call(vaccineOfAccount1);
    let slotOfAcc2 = await vS.vaccinationSlots.call(vaccineOfAccount2);

    assert.equal(
      slotOfAcc1.vaccineType,
      2,
      "wrong vaccination type for account 1"
    );
    assert.equal(
      slotOfAcc2.vaccineType,
      1,
      "wrong vaccination type for account 2"
    );
    assert.equal(
      Number(slotOfAcc1.date),
      date2.getTime(),
      "wrong date for account 1"
    );
    assert.equal(
      Number(slotOfAcc2.date),
      date1.getTime(),
      "wrong date for account 2"
    );
  });
});

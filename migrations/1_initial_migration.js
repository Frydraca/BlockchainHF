const Migrations = artifacts.require("Migrations");
const MedicalFacility = artifacts.require("MedicalFacility");
const Doctor = artifacts.require("Doctor");
const VaccinationSlots = artifacts.require("VaccinationSlots");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(MedicalFacility);
  deployer.deploy(Doctor);
  deployer.deploy(VaccinationSlots);
};

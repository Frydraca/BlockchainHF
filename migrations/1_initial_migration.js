const Migrations = artifacts.require("Migrations");
const MedicalFacility = artifacts.require("MedicalFacility");
const Doctor = artifacts.require("Doctor");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(MedicalFacility);
  deployer.deploy(Doctor);
};

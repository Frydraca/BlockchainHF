pragma solidity >=0.5.0 <0.9.0;

import "./MyOwnable.sol";

contract MedicalFacility is MyOwnable {
    enum VTypes {Zero, Alma, Barack, Citrom}

    struct VaccinationSlot {
        VTypes vaccineType;
        uint256 date;
        uint16 remaining;
        bool tradeable;
        bool validity;
    }

    VaccinationSlot[] public vaccinationSlots;
    address[] internal doctors;
    mapping(address => uint256) public ownerToVaccine;
    mapping(address => address) public requests;

    constructor() public MyOwnable() {
        vaccinationSlots.push(VaccinationSlot(VTypes.Zero, 0, 0, false, false));
    }

    function isValidPatient(address _patient) public view returns (bool) {
        if (
            ownerToVaccine[_patient] != 0 &&
            vaccinationSlots[ownerToVaccine[_patient]].validity
        ) {
            return true;
        }

        return false;
    }

    modifier hasValidVaccine(address _patient) {
        require(isValidPatient(_patient));
        _;
    }

    function _createVaccinationSlot(
        VTypes _vaccineType,
        uint256 _date,
        uint16 _remaining,
        bool _tradeable
    ) internal returns (uint256) {
        vaccinationSlots.push(
            VaccinationSlot(_vaccineType, _date, _remaining, _tradeable, true)
        );
        return vaccinationSlots.length - 1;
    }

    function setUpDoctors(address[] calldata _doctors) external onlyOwner {
        for (uint256 i = 0; i < _doctors.length; i++) {
            doctors.push(_doctors[i]);
        }
    }

    function getDoc(uint256 index) external view returns (address) {
        return doctors[index];
    }

    function getNumberOfVaccinationSlots() external view returns (uint256) {
        return vaccinationSlots.length;
    }
}

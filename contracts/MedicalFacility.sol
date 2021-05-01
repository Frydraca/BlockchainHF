pragma solidity >=0.5.0 <0.9.0;

import "./MyOwnable.sol";

contract MedicalFacility is MyOwnable{
    enum VTypes {
        Alma,
        Barack,
        Citrom
    }

    struct VaccinationSlot {
        VTypes vaccineType;
        uint date;
        uint16 remaining;
        bool tradeable;
        bool validity;
    }

    VaccinationSlot[] public vaccinationSlots;
    address[] internal doctors;
    mapping (address => uint) public ownerToVaccine;
    mapping (address => address) public requests;


    function _createVaccinationSlot(VTypes _vaccineType, uint _date, uint16 _remaining, bool _tradeable) internal returns(uint) {
        vaccinationSlots.push(VaccinationSlot(_vaccineType, _date, _remaining,_tradeable, true));
        return vaccinationSlots.length - 1;
    }

    function setUpDoctors(address[] calldata _doctors) external onlyOwner {
        for (uint i=0; i<_doctors.length; i++){
            doctors.push(_doctors[i]);
        }
    }

    function getDoc(uint index) external view returns(address){
        return doctors[index];
    }
}
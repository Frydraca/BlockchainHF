pragma solidity >=0.5.0 <0.9.0;
import "./MedicalFacility.sol";

contract Doctor is MedicalFacility{
    
    function isDoctor() public view returns(bool) {
        for (uint i=0; i<doctors.length; i++){
            if (doctors[i] == msg.sender){
                return true;
            }
        }
        return false;
    }

    modifier onlyDoctor() {
        require(isDoctor());
        _;
    }

    function issueVaccinationSlot(VTypes _vaccineType, uint _date) public onlyDoctor {
        uint16 remainingBasedOnType;
        if(_vaccineType == VTypes.Alma){
            remainingBasedOnType = 1;
        }else if (_vaccineType == VTypes.Citrom) {
            remainingBasedOnType = 3;
        }else{
            remainingBasedOnType = 2;
        }
        _createVaccinationSlot(_vaccineType, _date, remainingBasedOnType, true);
    }

}
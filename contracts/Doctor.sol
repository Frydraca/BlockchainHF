pragma solidity >=0.5.0 <0.9.0;
import "./MedicalFacility.sol";

contract Doctor is MedicalFacility {
    function isDoctor() public view returns (bool) {
        for (uint256 i = 0; i < doctors.length; i++) {
            if (doctors[i] == msg.sender) {
                return true;
            }
        }
        return false;
    }

    modifier onlyDoctor() {
        require(isDoctor());
        _;
    }

    function issueVaccinationSlot(
        VTypes _vaccineType,
        uint256 _date,
        address patient
    ) public onlyDoctor {
        uint16 remainingBasedOnType;
        if (_vaccineType == VTypes.Alma) {
            remainingBasedOnType = 1;
        } else if (_vaccineType == VTypes.Citrom) {
            remainingBasedOnType = 3;
        } else {
            remainingBasedOnType = 2;
        }
        uint256 vaccineId =
            _createVaccinationSlot(
                _vaccineType,
                _date,
                remainingBasedOnType,
                true
            );
        ownerToVaccine[patient] = vaccineId;
    }

    function injectVaccine() external hasValidVaccine {
        VaccinationSlot memory vaccine =
            vaccinationSlots[ownerToVaccine[msg.sender]];

        if (vaccine.remaining <= 1) {
            delete ownerToVaccine[msg.sender];
        } else {
            uint256 vaccineId =
                _createVaccinationSlot(
                    vaccine.vaccineType,
                    vaccine.date,
                    vaccine.remaining - 1,
                    false
                );
            ownerToVaccine[msg.sender] = vaccineId;
        }
        vaccine.validity = false;
    }
}

pragma solidity >=0.5.0 <0.9.0;
import "./MedicalFacility.sol";

contract Doctor is MedicalFacility {
    function isDoctor() private view returns (bool) {
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
        address _patient
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
        ownerToVaccine[_patient] = vaccineId;
    }

    function injectVaccine(address _patient)
        external
        hasValidVaccine(_patient)
        onlyDoctor
    {
        VaccinationSlot storage vaccine =
            vaccinationSlots[ownerToVaccine[_patient]];

        if (vaccine.remaining <= 1) {
            delete ownerToVaccine[_patient];
        } else {
            uint256 vaccineId =
                _createVaccinationSlot(
                    vaccine.vaccineType,
                    vaccine.date + 2678400000,
                    vaccine.remaining - 1,
                    false
                );
            ownerToVaccine[_patient] = vaccineId;
        }
        vaccine.validity = false;
    }
}

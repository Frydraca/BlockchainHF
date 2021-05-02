pragma solidity >=0.5.0 <0.9.0;
import "./Doctor.sol";

contract VaccinationSlots is Doctor {

    modifier hasRequest(address _from) {
        require(requests[_from] == msg.sender);
        _;
    }

    modifier vaccineTradeable(){
        VaccinationSlot memory vaccine = vaccinationSlots[ownerToVaccine[msg.sender]];
        require(vaccine.tradeable);
        _;
    }

    function requestTrade(address _reqFrom) external hasValidVaccine(msg.sender) vaccineTradeable {
        requests[msg.sender] = _reqFrom;
    }

    function trade(address _sendTo) external hasValidVaccine(msg.sender) hasRequest(_sendTo) vaccineTradeable{
        uint temp = ownerToVaccine[msg.sender];
        ownerToVaccine[msg.sender] = ownerToVaccine[_sendTo];
        ownerToVaccine[_sendTo] = temp;
    }
}
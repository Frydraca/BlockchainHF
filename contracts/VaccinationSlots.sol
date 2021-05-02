pragma solidity >=0.5.0 <0.9.0;
import "./Doctor.sol";

contract VaccinationSlots is Doctor {

    modifier hasRequest(address from) {
        require(requests[from] == msg.sender);
        _;
    }

    function requestTrade(address reqFrom) external hasValidVaccine {
        requests[msg.sender] = reqFrom;
    }

    function trade(address sendTo) external hasValidVaccine hasRequest(sendTo){
        uint temp = ownerToVaccine[msg.sender];
        ownerToVaccine[msg.sender] = ownerToVaccine[sendTo];
        ownerToVaccine[sendTo] = temp;
    }
}
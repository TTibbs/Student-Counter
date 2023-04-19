// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract HeadCount is Ownable {

    struct TimeRecord {
        uint256 time;
        bool inBuilding;
    }

    mapping(address => TimeRecord) public studentTimeRecords;
    mapping(address => TimeRecord) public teacherTimeRecords;

    constructor(address _teacher) {
        transferOwnership(_teacher);
    }

    function enterBuilding() public {
        if (msg.sender == owner()) {
            require(!teacherTimeRecords[msg.sender].inBuilding, "Teacher already clocked in");
            teacherTimeRecords[msg.sender] = TimeRecord(block.timestamp, true);
        } else {
            require(!studentTimeRecords[msg.sender].inBuilding, "Student already in the building");
            studentTimeRecords[msg.sender] = TimeRecord(block.timestamp, true);
        }
    }

    function leaveBuilding() public {
        if (msg.sender == owner()) {
            require(teacherTimeRecords[msg.sender].inBuilding, "Teacher not clocked in");
            teacherTimeRecords[msg.sender] = TimeRecord(block.timestamp, false);
        } else {
            require(studentTimeRecords[msg.sender].inBuilding, "Student not in the building");
            studentTimeRecords[msg.sender] = TimeRecord(block.timestamp, false);
        }
    }

    function getStudentEnterTime(address studentAddress) public view returns (uint256) {
        require(studentTimeRecords[studentAddress].inBuilding, "Student not in the building");
        return studentTimeRecords[studentAddress].time;
    }

    function getStudentLeaveTime(address studentAddress) public view returns (uint256) {
        require(!studentTimeRecords[studentAddress].inBuilding, "Student still in the building");
        return studentTimeRecords[studentAddress].time;
    }
}
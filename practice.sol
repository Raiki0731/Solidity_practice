// SPDX-License-Identifier: GPL-2.0
pragma solidity  ^0.8.10;

contract practice {

    struct param {
        string y2;
        string g2;
    }
    
    struct dataStruct {
        string domain;
        mapping(uint => param) params;              //KEY:time, VALUE:param
        mapping(uint => uint) time;                 //KEY:data number, VALUE:time
        mapping(uint => bool) isTimeRegistered;     //KEY:time, VALUE:isTimeRegistered(bool)
        uint dataNum;                               
    }

    mapping(string => dataStruct) data;             //KEY:domain, VALUE:dataStruct
    mapping(string => bool) isDomainRegistered;     //KEY:domain, VALUE:isDomainRegistered(bool)
    address private owner;
    mapping(address => bool) isPermitted;           //KEY:address, VALUE:isPermitted(bool)

    constructor() {
        owner = msg.sender;
    }

    function setData(string memory _domain, string memory _y2, string memory _g2) public {
        require(isPermitted[msg.sender] == true || owner == msg.sender , "Permission Denied!");
        uint _time = block.timestamp;

        if(isDomainRegistered[_domain] == false) {
            data[_domain].domain = _domain;
            data[_domain].dataNum = 1;
            data[_domain].time[data[_domain].dataNum - 1] = _time;
            data[_domain].isTimeRegistered[_time] = true;
            data[_domain].params[_time].y2 = _y2;
            data[_domain].params[_time].g2 = _g2;
            isDomainRegistered[_domain] = true;
            
        } else {
            data[_domain].dataNum++;
            data[_domain].time[data[_domain].dataNum - 1] = _time;
            data[_domain].params[_time].y2 = _y2;
            data[_domain].params[_time].g2 = _g2;
            data[_domain].isTimeRegistered[_time] = true;
        }
    }

    function getData(string memory _domain) public view returns(uint[] memory, string[] memory, string[] memory){
        uint num = data[_domain].dataNum;
        uint[] memory timeArray = new uint[](num);
        string[] memory y2Array = new string[](num);
        string[] memory g2Array = new string[](num);

        for (uint i = 0; i < num; i++) {
            timeArray[i] = data[_domain].time[i];
            y2Array[i] = data[_domain].params[timeArray[i]].y2;
            g2Array[i] = data[_domain].params[timeArray[i]].g2;
        }

        return(timeArray, y2Array, g2Array);
    }

    function addPermit(address addr) public {
        require(owner == msg.sender, "Permission Denied!");
        isPermitted[addr] = true;
    }

    function removePermit(address addr) public {
        require(owner == msg.sender, "Permission Denied!");
        isPermitted[addr] = false;
    }
}
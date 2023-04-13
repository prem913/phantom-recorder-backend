// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract IPFS {
    struct Data {
        address key;
        string value;
    }
    mapping(address => uint) private logins;
    mapping(address => string) private userHashes;
    mapping(address => string) private doctortopublickey;
    address[] private doctortopublickeykeys;
    mapping(address => Data[]) private doctorAccess;
    

    // function convertStringToAddress(address memory _string) public returns (address) {
    //     bytes memory hexString = bytes(_string);
    //     return address(uint160(hex(hexString)));
    // }
    function getRoles(address user) public view returns (string[] memory){
        string[] memory roles = new string[](2);
        if(bytes(userHashes[user]).length > 0){
            roles[0] = "user";
        }
        if(bytes(doctortopublickey[user]).length >0){
            roles[1] = "doctor";
        }
        
        return roles;

    }
    function registerDoctor(string memory pk) public {
        doctortopublickey[msg.sender] = pk;
        doctortopublickeykeys.push(msg.sender);
    }

    function getDoctors() public view returns (Data[] memory) {
        Data[] memory result = new Data[](doctortopublickeykeys.length);
        uint256 i = 0;
        for (; i < doctortopublickeykeys.length; i++) {
            result[i].key = doctortopublickeykeys[i];
            result[i].value = doctortopublickey[doctortopublickeykeys[i]];
        }
        return result;
    }

    function giveAccesstoDoc(address docaddr, string memory hash) public {
        Data memory result;
        result.key = msg.sender;
        result.value = hash;
        doctorAccess[docaddr].push(result);
    }

    function getDocUsers() public view returns (Data[] memory) {
        return doctorAccess[msg.sender];
    }

    function storeHash(string memory hash) public {
        userHashes[msg.sender] = hash;
    }

    function retrieveHash() public view returns (string memory) {
        return userHashes[msg.sender];
    }
}

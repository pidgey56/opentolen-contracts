pragma solidity >0.4.1 <=0.7.0;


contract HelloWorld {
    string private dumbValue;

    string private hello = "Hello Pierre";

    constructor() public {
        dumbValue = "Default";
    }

    function getDumbValue() public view returns (string memory) {
        return dumbValue;
    }

    function getHello() public view returns (string memory) {
      return hello;
    }

    function setDumbValue(string memory newValue) public {
        dumbValue = newValue;
    }
}

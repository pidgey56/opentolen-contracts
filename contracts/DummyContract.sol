pragma solidity >0.4.1 <=0.7.0;
pragma experimental ABIEncoderV2;
import "@openzeppelin/contracts/access/Roles.sol";

contract DummyContract {
  using Roles for Roles.Role;

  Roles.Role private _adminsOpen;


  modifier onlyAdminOpen() {
    require(isAdminOpen(), "msg.sender not admin Open");
    _;
  }

  struct User{
    address adresse;
    string company;
    string role;
  }

  mapping(address => User) public addressToUser;
  mapping(string => User[]) public companyUsers;
  mapping(uint => uint) public testmap;
  uint public numberOfUsers;


  function setNumberOfUsers(string memory _company) public {
    numberOfUsers = companyUsers[_company].length;
  }
  uint256 public countdown = 3;
  modifier inInterval() {
    require(countdown != 0, "countdown = 0");
    _;
  }
  string[] public emptyList = ["le if failed"];
  string[] private companyList;

function getCompanyList() public view returns(string[] memory){
  require(_adminsOpen.has(msg.sender),"not an admin open");
  return companyList;
}

  function addCompany(string memory _company)
    public
    onlyAdminOpen()
    inInterval()
  {
    companyList.push(_company);
    countdown = countdown - 1;
  }

  function isAdminOpen() public view returns (bool) {
    return _adminsOpen.has(msg.sender);
  }

  function addAdminOpen(address account) public {
    _adminsOpen.add(account);
    User memory newUser = User(account,"Open", "adminOpen");
    companyUsers["Open"].push(newUser);
    addressToUser[account] = newUser;
  }

  function addUser(address account, string memory company) public {
    User memory newUser = User(account,company,"user");
    companyUsers[company].push(newUser);
    addressToUser[account] = newUser;
  }
  constructor() public {
    addAdminOpen(msg.sender);
    addCompany("Open");
  }
}

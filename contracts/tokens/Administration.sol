pragma solidity >=0.4.21 <0.7.0;
pragma experimental ABIEncoderV2;
import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/access/Roles.sol";


contract Administration {
  using Roles for Roles.Role;
  Roles.Role internal _users;
  Roles.Role internal _admins;
  Roles.Role internal _adminsOpen;

  struct User {
    address adrs;
    string company;
    string role;
  }
  string[] private companyList;
  mapping(address => User) public addressToUser;
  mapping(string => User[]) public companyUsers;
  mapping(string => uint) public numberOfUsers;
  mapping(string => bool) private existingCompanyBool;

  event UserAdded(address user);
  event AdminAdded(address admin);
  event AdminOpenAdded(address adminOpen);
  event UserRemoved(address user);
  event AdminRemoved(address admin);
  event AdminOpenRemoved(address adminOpen);

  //===========================================MODIFIERS=========================================
  function isUser() public view returns (bool) {
    return _users.has(msg.sender);
  }

  function isAdmin() public view returns (bool) {
    return _admins.has(msg.sender);
  }

  function isAdminOpen() public view returns (bool) {
    return _adminsOpen.has(msg.sender);
  }

  modifier atLeastUser() {
    require(
      isUser() || isAdmin() || isAdminOpen(),
      "msg sender don't have at least user role"
    );
    _;
  }

  modifier atLeastAdmin() {
    require(
      isAdmin() || isAdminOpen(),
      "msg sender don't have at least admin role"
    );
    _;
  }

  modifier onlyUser() {
    require(_users.has(msg.sender), "msg sender don't have user Role");
    _;
  }

  modifier onlyAdmin() {
    require(_admins.has(msg.sender), "msg sender don't have admin Role");
    _;
  }

  modifier onlyAdminOpen() {
    require(
      _adminsOpen.has(msg.sender),
      "msg sender don't have admin Open Role"
    );
    _;
  }

  modifier onlyInCompany(string memory _company) {
    require(
      _adminsOpen.has(msg.sender) ||
        keccak256(abi.encodePacked(addressToUser[msg.sender].company)) ==
        keccak256(abi.encodePacked(_company)),
      "msg sender not an omega admin or in the company"
    );
    _;
  }

  modifier existingCompany(string memory _company) {
    require(existingCompanyBool[_company], "company doesn't exist");
    _;
  }

  //================================END OF MODIFIERS=============================================

  function getCompanyList() public view onlyAdminOpen() returns(string[] memory){
    return companyList;
  }
  //================================ADDING FUNCTIONS=================================================

  /* === adding user === */

  function addUser(address _userAddress, string memory _company)
    public
    atLeastAdmin()
    onlyInCompany(_company)
  {
    _users.add(_userAddress);
    numberOfUsers[_company] = numberOfUsers[_company] + 1;
    User memory newUser = User(_userAddress, _company, "user");
    addressToUser[_userAddress] = newUser;
    companyUsers[_company].push(newUser);
    emit UserAdded(_userAddress);
  }

  /* === adding admin === */

  function addAdmin(address _admin, string memory _company)
    public
    onlyInCompany(_company)
    atLeastAdmin()
  {
    _admins.add(_admin);
    numberOfUsers[_company] = numberOfUsers[_company] + 1;
    User memory newAdmin = User(_admin, _company, "admin");
    addressToUser[_admin] = newAdmin;
    companyUsers[_company].push(newAdmin);
    emit AdminAdded(_admin);
  }

  /* === adding admin Open === */
  function addAdminOpen(address _adminOpen) public onlyAdminOpen() {
    _adminsOpen.add(_adminOpen);
    numberOfUsers["Open"] = numberOfUsers["Open"] + 1;
    User memory newAdminOpen = User(_adminOpen, "Open", "adminOpen");
    addressToUser[_adminOpen] = newAdminOpen;
    companyUsers["Open"].push(newAdminOpen);
    emit AdminOpenAdded(_adminOpen);
  }

  function _addAdminOpen(address _adminOpen) private {
    _adminsOpen.add(_adminOpen);
    numberOfUsers["Open"] = numberOfUsers["Open"] + 1;
    User memory newAdminOpen = User(_adminOpen, "Open", "adminOpen");
    addressToUser[_adminOpen] = newAdminOpen;
    companyUsers["Open"].push(newAdminOpen);
    emit AdminOpenAdded(_adminOpen);
  }

  /* === adding a new company === */
  function addCompany(string memory _company) public onlyAdminOpen() {
    require(existingCompanyBool[_company] != true, "company already exist");
    existingCompanyBool[_company] = true;
    companyList.push(_company);
  }

  //====================================END OF ADDIND FUNCTION===================================

  //====================================REMOVING FUNCTION========================================
  /*
  /* === removing user === */
  function removeUser(address _user)
    public
    atLeastAdmin()
    onlyInCompany(addressToUser[_user].company)
  {
    _users.remove(_user);
    numberOfUsers[addressToUser[_user].company] = numberOfUsers[addressToUser[_user].company] - 1;
    _removeFromList(_user, addressToUser[_user].company);
    delete addressToUser[_user];
    
    emit UserRemoved(_user);
  }

  /* === removing admin === */
  function removeAdmin(address _admin)
    public
    atLeastAdmin()
    onlyInCompany(addressToUser[_admin].company)
  {
    _admins.remove(_admin);
        numberOfUsers[addressToUser[_admin].company] = numberOfUsers[addressToUser[_admin].company] - 1;

    _removeFromList(_admin, addressToUser[_admin].company);
    delete addressToUser[_admin];
    
    emit AdminRemoved(_admin);
  }

  /* === removing admin Open === */
  function removeAdminOpen(address _adminOpen) public onlyAdminOpen() {
    _adminsOpen.remove(_adminOpen);
        numberOfUsers["Open"] = numberOfUsers["Open"] - 1;
    delete addressToUser[_adminOpen];
    _removeFromList(_adminOpen, "Open");
    emit AdminOpenRemoved(_adminOpen);
  }

  function _removeFromList(address _account, string memory _company) internal {
    uint256 index = _findIndexInList(_account, _company);
    _removeByIndexFromList(index, _company);
  }

  function _findIndexInList(address _account, string memory _company)
    internal
    view
    returns (uint256)
  {
    uint256 i = 0;
    while (companyUsers[_company][i].adrs != _account) {
      i++;
    }
    return i;
  }

  function _removeByIndexFromList(uint256 _index, string memory _company)
    internal
    returns (User[] memory)
  {
    for (uint256 i = _index; i < companyUsers[_company].length - 1; i++) {
      companyUsers[_company][i] = companyUsers[_company][i + 1];
    }
    delete companyUsers[_company][companyUsers[_company].length - 1];
    companyUsers[_company].length--;
    return companyUsers[_company];
  }

  //===================================END OF REMOVING FUNCTION====================================

  //===================================CONSTRUCTOR=================================================
  constructor() public {
    existingCompanyBool["Open"] = true;
    companyList.push("Open");
    _addAdminOpen(msg.sender);
  }
}

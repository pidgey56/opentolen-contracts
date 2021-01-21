/*const BurnableTokenContract = artifacts.require("./BurnableToken");

contract("BurnableToken", (accounts) => {
  before(() => {
    BurnableTokenContract.deployed().then((inst) => {
      instance = inst;
    });
  });

  it("... Should have add an admin Open", () => {
    return instance
      .getUserOfCompany("Open")
      .then((users) =>
        assert.equal(users.length, 1, "wrong number of employees")
      );
  });

  it("... Should add an company pjo", () => {
    return instance
      .addCompany("pjo")
      .then(() => instance.getCompanyList())
      .then((companies) =>
        assert.equal(companies.length, 2, "wrong number of companies")
      );
  });
  it("... Should add an company gcz", () => {
    return instance
      .addCompany("gcz")
      .then(() => instance.getCompanyList())
      .then((companies) =>
        assert.equal(companies.length, 3, "wrong number of companies")
      );
  });

  it("... Should add an admin pjo with admin Open", () => {
    return instance
      .addAdmin(accounts[1], "pjo")
      .then(() => instance.getUserOfCompany("pjo"))
      .then((users) =>
        assert.equal(users.length, 1, "wrong number of employees")
      );
  });

  it("... Should add an admin pjo with admin pjo", () => {
    return instance
      .addAdmin(accounts[2], {from: accounts[1]})
      .then(() => instance.getUserOfCompany("pjo", {from: accounts[1]}))
      .then((users) =>
        assert.equal(users.length, 2, "wrong number of employees")
      );
  });
  it("... Should add an user pjo with admin Open", () => {
    return instance
      .addUser(accounts[3], "pjo")
      .then(() => instance.getUserOfCompany("pjo"))
      .then((users) =>
        assert.equal(users.length, 3, "wrong number of employees")
      );
  });

  it("... Should add an user pjo with admin pjo", () => {
    return instance
      .addUser(accounts[4], {from: accounts[1]})
      .then(() => instance.getUserOfCompany("pjo"))
      .then((users) =>
        assert.equal(users.length, 4, "wrong number of employees")
      );
  });

  it("... Should remove an user pjo with admin pjo", () => {
    return instance
      .removeUser(accounts[4], {from: accounts[1]})
      .then(() => instance.getUserOfCompany("pjo"))
      .then((users) =>
        assert.equal(users.length, 3, "wrong number of employees")
      );
  });
  it("... Should remove an user pjo with admin Open", () => {
    return instance
      .removeUser(accounts[3])
      .then(() => instance.getUserOfCompany("pjo"))
      .then((users) =>
        assert.equal(users.length, 2, "wrong number of employees")
      );
  });
  it("... Should remove an admin pjo with admin pjo", () => {
    return instance
      .removeAdmin(accounts[2], {from: accounts[1]})
      .then(() => instance.getUserOfCompany("pjo"))
      .then((users) =>
        assert.equal(users.length, 1, "wrong number of employees")
      );
  });
  it("... Should remove an admin pjo with admin Open", () => {
    return instance
      .removeAdmin(accounts[1])
      .then(() => instance.getUserOfCompany("pjo"))
      .then((users) =>
        assert.equal(users.length, 0, "wrong number of employees")
      );
  });

  it("... Should add an admin Open", () => {
    return instance
      .addAdminOpen(accounts[1])
      .then(() => instance.getUserOfCompany("Open"))
      .then((users) =>
        assert.equal(users.length, 2, "wrong number of admins Open")
      );
  });

  it("... Should remove an admin Open", () => {
    return instance
      .removeAdminOpen(accounts[1])
      .then(() => instance.getUserOfCompany("Open"))
      .then((users) =>
        assert.equal(users.length, 1, "wrong number of admins Open")
      );
  });

  it("... Should fail to add an admin without existing company", () => {
    return instance
      .addAdmin(accounts[1], "PJO")
      .then(() => assert.isOk(false, "Admin shouldn't have been created"))
      .catch(() => assert.isOk(true, "addAdmin has failed"))
      .then(() => instance.getUserOfCompany("PJO"))
      .then((users) =>
        assert.equal(users.length, 0, "wrong number of employees")
      );
  });

  it("... Should fail to add an user without existing company", () => {
    return instance
      .addUser(accounts[1], "PJO")
      .then(() => assert.isOk(false, "User shouldn't have been created"))
      .catch(() => assert.isOk(true, "addUser has failed"))
      .then(() => instance.getUserOfCompany("PJO"))
      .then((users) =>
        assert.equal(users.length, 0, "wrong number of employees")
      );
  });

  it("... Should add an admin pjo", () => {
    return instance
      .addAdmin(accounts[1], "pjo")
      .then(() => instance.getUserOfCompany("pjo"))
      .then((users) =>
        assert.equal(users.length, 1, "wrong number of employees")
      );
  });

  it("... Should, as pjo admin fail to add an admin in gcz company", () => {
    return instance
      .addAdmin(accounts[2], "gcz", {from: accounts[1]})
      .then(() => assert.isOk(false, "should have failed"))
      .catch(() => assert.isOk(true, "this has failed"))
      .then(() => instance.getUserOfCompany("gcz"))
      .then((users) => {
        assert.equal(users.length, 0, "wrong number of employees");
      });
  });

  it("... Should, as pjo admin fail to add an user in gcz company", () => {
    return instance
      .addUser(accounts[2], "gcz", {from: accounts[1]})
      .then(() => assert.isOk(false, "should have failed"))
      .catch(() => assert.isOk(true, "this has failed"))
      .then(() => instance.getUserOfCompany("gcz"))
      .then((users) => {
        assert.equal(users.length, 0, "wrong number of employees");
      });
  });
  it("... Should as pjo admin fail to remove user and admin from gcz company", () => {
    return Promise.all([
      instance.addAdmin(accounts[2], "gcz"),
      instance.addUser(accounts[3], "gcz"),
    ])
      .then(() => instance.getUserOfCompany("gcz"))
      .then((users) =>
        assert.equal(users.length, 2, "wrong number of employees")
      )
      .then(() => instance.removeAdmin(accounts[2], {from: accounts[1]}))
      .then(() => assert.isOk(false, "should have failed"))
      .catch(() => assert.isOk(true, "this has failed"))
      .then(() => instance.getUserOfCompany("gcz"))
      .then((users) =>
        assert.equal(users.length, 2, "wrong number of employees at step 2")
      )
      .then(() => instance.removeUser(accounts[3], {from: accounts[1]}))
      .then(() => assert.isOk(false, "should have failed"))
      .catch(() => assert.isOk(true, "this has failed"))
      .then(() => instance.getUserOfCompany("gcz"))
      .then((users) =>
        assert.equal(users.length, 2, "wrong number of employees at step 2")
      );
  });
});
*/
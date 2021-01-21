/*const BurnableTokenContract = artifacts.require("./BurnableToken");

contract("BurnableToken", (accounts) => {
  let instance;
  let expectedToken = {
    idToken: "1",
    owner: accounts[0],
    details: "no details",
    inUse: true,
  };

  before(() => {
    BurnableTokenContract.deployed().then((inst) => {
      instance = inst;
    });
  });

  it("... Should have created a token", () => {
    instance.mintToken(accounts[0]);
    return instance.getTokenById(1).then((token) => {
      assert.equal(token.idToken, expectedToken.idToken, "Wrong id");
      assert.equal(token.owner, expectedToken.owner, "Wrong owner");
      assert.equal(token.details, expectedToken.details, "Wrong details");
      assert.equal(token.inUse, expectedToken.inUse, "Wrong inUse value");
    });
  });

  it("... Should modifity a token description", () => {
    expectedToken.details = "update description";
    instance.setTokenDetailsById(1, "update description");
    return instance.getTokenById(1).then((token) => {
      assert.equal(token.details, expectedToken.details, "Wrong details");
    });
  });

  it("... Should pass a token to another owner ", () => {
    return instance
      .setApprovalTransfer(1, {from: accounts[1]})
      .then(() => instance.transfer(1, accounts[0], accounts[1]), {
        from: accounts[0],
      })
      .then(() => instance.getTokenById(1, {from: accounts[1]}))
      .then((token) => {
        assert.equal(token.owner, accounts[1], "Wrong owner");
      });
  });

  it("... Should do in the order : multiple creation -> delete -> recreation", () => {
    return Promise.all([
      instance.mintToken(accounts[0]),
      instance.mintToken(accounts[0]),
      instance.mintToken(accounts[0]),
      instance.mintToken(accounts[0]),
    ])
      .then(() => instance.burnToken(3))
      .then(() => instance.getTokenById(3))
      .then((token) => {
        assert.equal(
          token.inUse,
          false,
          "The token 3 has not been successfully deleted"
        );
      })
      .then(() => instance.mintToken(accounts[0]))
      .then(() => instance.getTokenById(3))
      .then((token) => {
        assert.equal(
          token.inUse,
          true,
          "The token 3 has not been correctly replaced"
        );
      });
  });
});
*/
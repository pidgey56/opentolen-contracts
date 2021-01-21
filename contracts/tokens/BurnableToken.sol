pragma solidity >0.4.1 <=0.7.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "./MintableToken.sol";


contract BurnableToken is MintableToken {
    function burnToken(uint256 _idToken)
        public
        onlyOwnerOfToken(_idToken)
        atLeastAdmin()
    {
        _burn(_idToken);
        tokenList[_idToken] = BasicToken(_idToken, address(0), "", false);
    }
}

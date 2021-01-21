pragma solidity >0.4.1 <=0.7.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "./passableToken.sol";


contract MintableToken is PassableToken {
    function _mintToken(address _owner, uint256 _tokenId, string memory _details) private {
        _safeMint(_owner, _tokenId);
        BasicToken memory newToken = BasicToken(
            _tokenId,
            _owner,
            _details,
            true
        );
        tokenList[_tokenId] = newToken;
    }

    function mintToken(address _owner, string memory _details) public atLeastUser() {
        uint256 id = getFirstIdAvailableFromTokenList();
        _mintToken(_owner, id, _details);
    }
}

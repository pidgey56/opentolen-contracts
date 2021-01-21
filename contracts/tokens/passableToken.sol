pragma solidity >=0.4.21 <0.7.0;
pragma experimental ABIEncoderV2;

import "./Token.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";


contract PassableToken is Token {
    mapping(uint256 => address) private approvals;

    function transfer(uint256 _tokenId, address _from, address _to)
        public
        onlyOwnerOfToken(_tokenId)
        atLeastUser()
    {
        require(
            approvals[_tokenId] == _to,
            "The recipient did not agree to receive the token"
        );
        safeTransferFrom(_from, _to, _tokenId);
        tokenList[_tokenId].owner = _to;
    }

    function setApprovalTransfer(uint256 _tokenId) public {
        approvals[_tokenId] = msg.sender;
    }
}

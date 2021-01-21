pragma solidity >=0.4.21 <0.7.0;
pragma experimental ABIEncoderV2;
import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "./Administration.sol";


contract Token is ERC721, Administration {
    using Counters for Counters.Counter;
    using SafeMath for uint256;
    using Address for address;
    struct BasicToken {
        uint256 idToken;
        address owner;
        string details;
        bool inUse;
    }
    mapping(uint256 => BasicToken) public tokenList;
    modifier onlyOwnerOfToken(uint256 _idToken) {
        require(
            msg.sender == tokenList[_idToken].owner ||
                _adminsOpen.has(msg.sender),
            "Unallowed to get a token that doesn't belong to caller"
        );
        _;
    }

    function setTokenDetailsById(uint256 _idToken, string memory _newDetail)
        public
        onlyOwnerOfToken(_idToken)
        atLeastUser()
    {
        tokenList[_idToken].details = _newDetail;
    }

    function getFirstIdAvailableFromTokenList()
        internal
        view
        returns (uint256)
    {
        uint256 id = 1;
        while (tokenList[id].inUse != false) {
            id += 1;
        }
        return id;
    }
}

pragma solidity >=0.4.21 <=0.6.4;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";

contract DBZCollectible is ERC721Full {
    DBCard[] public cards;
    uint256 nonce = 0;
    mapping(uint256 => address) public cardIndexToOwner;
    mapping(address => uint256) ownershipTokenCount;

    event Created(address owner, uint256 cardID, string cardType);
    event Transfer(address from, address to, uint256 tokenId);

    struct DBCard {
        uint256 id;
        uint64 birthTime;
        string cardType;
        uint price;
    }

    function getCards() external returns(DBCard[] memory) {
        return cards;
    }

    constructor() public ERC721Full("Dragon Ball Card", "DBZCARD") {
        mint('goku_ss_namek', 1);
        mint('broly_dbs_ss', 1);
        mint('majin_vegeta', 1);
    }

    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        ownershipTokenCount[_to]++;
        cardIndexToOwner[_tokenId] = _to;

        if (_from != address(0)) {
            ownershipTokenCount[_from]--;
        }

        emit Transfer(_from, _to, _tokenId);
    }

    function _createDBCard(address _owner,string memory _cardType, uint _price) internal returns (uint)
    {
        require(bytes(_cardType).length > 0);
        require(_price > 0);

        nonce++;

        DBCard memory _DBCard = DBCard({
            id: nonce,
            birthTime: uint64(now),
            cardType: _cardType,
            price: _price
        });

        cards.push(_DBCard);

        emit Created(_owner, nonce, _cardType);

        _transfer(address(0), _owner, nonce);

        return nonce;
    }

    function mint(string memory cardType, uint _price) public {
        uint _id = _createDBCard(msg.sender, cardType, _price);
        _mint(msg.sender, _id);
    }
}

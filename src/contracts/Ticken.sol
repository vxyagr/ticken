// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Base64.sol";


contract Ticken is ERC1155, Ownable {
    string public name="Ticken | Ticket Token";
    using Address for address;
    uint256 private tokenId = 1;
    uint256 public val = 0;
    uint256 public cost = 0.00 ether;
    address payable private payableOwner;

    uint private isTicken = 1;
    uint private isEvent = 2;
    uint private isSponsorship = 3;

    uint256 [] public tickens;
    uint256 [] public eventTokens;
    uint256 [] public eventSponsor;

    struct eventAttr {
        string _name;
        string _location;
        string _social;
        string _tickenDetail;
        string _sponsorshipDetail;
        address _externalTokens;
    }

    struct sponsorAttr {
        string _name;
        uint256 _event;
        uint256 _percentShare;
        uint256 _price;
    }
    

    uint256[] private _allTokens;

    mapping(string => bool) _tickenExists;
    mapping(string => bool) _eventExists;
    mapping(uint => uint) _tokenType;
    mapping(uint256 => string) public tokenAttribute;
    mapping(uint256 => address) public ownerOfEvents;
    mapping(address => uint256[]) public eventsOwned;
    mapping(uint256 => uint256[]) public tickensOfEvent;
    mapping(address => uint256[]) public tickensOwned;
    mapping(uint256 => address) public ownerOfTickens;
    mapping(uint256 => uint256) public eventOfTickens;
    mapping(uint256 => eventAttr) public eventAttributes;

    constructor() public ERC1155("Ticken"){
        //_mint(msg.sender,tokenId,100,"data of tokenId");
        payableOwner=payable(owner());

    }

    function lockMetadata(uint256 id) public {
        //_allTokens[id]=isEvent;
    }

    function setTokenUri(uint256 id, string memory attributeUri) public onlyOwner{
        tokenAttribute[id]=attributeUri;
    }

    function uri(uint256 id) public override(ERC1155) view returns (string memory){
       
    string memory encodedUri =  Base64.encode(
            bytes(string(
                abi.encodePacked(tokenAttribute[id])
            ))
        );
        return string(abi.encodePacked('data:application/json;base64,', encodedUri));
        //return theUri;
    
    }

    function mintEvent(string memory _eventData) public payable {
        require(!_eventExists[_eventData],"Event already exists");
        require(msg.value >= cost,"Insufficient Balance");
        _mint(msg.sender,tokenId,1, bytes(_eventData));
        _eventExists[_eventData]=true;
        _tokenType[tokenId]=isEvent;
        ownerOfEvents[tokenId]=_msgSender();
        eventsOwned[_msgSender()].push(tokenId);       
        string memory bsUri =  '{"name": "Konser Bruno Mars",'
                    '"image": "https://media-assets-ggwp.s3.ap-southeast-1.amazonaws.com/2021/02/Rickroll-4K-60fps-640x360.jpg",'
                    '"attributes": [{"trait_type": "Ticket Types", "value": "3"},'
                    '{"trait_type": "DateTime", "value": "Sometime"}'
                    '],'
                    '"ticket_types": [{"trait_type": "Ticket Types", "value": "3"},'
                    '{"trait_type": "DateTime", "value": "Sometime"}'
                    ']}';
        setTokenUri(tokenId, bsUri);
        tokenId++;
    }


    function mintTicken(uint256 eventId, uint8 amount, string memory _eventData,
    string memory eventName, string memory eventLocation, string memory eventDate, string memory eventSocial) public {
        require(!_tickenExists[_eventData],"Ticken already exists");
        _mint(msg.sender,tokenId,amount, bytes(_eventData));
        _tickenExists[_eventData]=true;
        eventOfTickens[tokenId]=eventId;
        tickensOfEvent[eventId].push(tokenId);
        ownerOfTickens[tokenId]=_msgSender();
        tickensOwned[_msgSender()].push(tokenId);
        _tokenType[tokenId]=isTicken;
        tokenId++;
    }

    function mintSponsorshipToken(uint256 eventId, uint8 amount, string memory _eventData, uint8 percentShare) public {
        require(!_tickenExists[_eventData],"Sponsorship already exists");
        _mint(msg.sender,tokenId,amount, bytes(_eventData));
        _tickenExists[_eventData]=true;
        tickens.push(tokenId);
        eventOfTickens[tokenId]=eventId;
        tickensOfEvent[eventId].push(tokenId);
        ownerOfTickens[tokenId]=_msgSender();
        tickensOwned[_msgSender()].push(tokenId);
        _tokenType[tokenId]=isSponsorship;
        tokenId++;
    }

    function withdraw() public onlyOwner {
        // get the amount of Ether stored in this contract
        uint amount = address(this).balance;

        // send all Ether to owner
        // Owner can receive Ether since the address of owner is payable
        (bool success, bytes memory data ) = payableOwner.call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    function contractAddress() public view onlyOwner returns (address){
        return address(this);
    }

    function contractBalance() public view onlyOwner returns (uint){
        return address(this).balance;
    }

   

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    
  
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract Ticken is ERC721Connector {

    // array to store our nfts
    string [] public tickens;

    mapping(string => bool) _tickenExists;

    function mint(string memory _ticken) public {

        require(!_tickenExists[_ticken],
        'Error - ticken already exists');
        // this is deprecated - uint _id = KryptoBirdz.push(_kryptoBird);
        tickens.push(_ticken);
        uint _id = tickens.length - 1;

        // .push no longer returns the length but a ref to the added element
        _mint(msg.sender, _id);

        _tickenExists[_ticken] = true;

    }

    constructor() ERC721Connector('Ticken','TICKEN')
 {}

}



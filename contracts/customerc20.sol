// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "./erc20.sol";

contract customerc20 is ERC20{

    //Constructor del Smart contract
    constructor() ERC20("Juan", "JA"){}

    // Creacion de nuevos tokens
    function createTokens() public {

        _mint(msg.sender, 1000);

    }

}
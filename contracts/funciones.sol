// SPDX-License-Identifier: MIT

// Version de compilador
pragma solidity ^0.8.4;


contract functions{

    //Funciones de tipo pure
    //Las de tipo pure, en ningun momento acceden a la blockchain.

    function getName() public pure returns (string memory){

        return "Juan";

    }

    //Funciones tipo view, acceden a la blockchain 
    uint256 x = 100;
    function getNumber() public view returns (uint256){
        return x*2;
    }

    

}
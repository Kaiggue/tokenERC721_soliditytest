// SPDX-License-Identifier: MIT

// Version de compilador
pragma solidity ^0.8.0;

//Person Owner: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
//Person 2: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//Importacion de smart contracts de openzepellin

import "@openzeppelin/contracts@4.4.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";

contract ArtToken is ERC721, Ownable {

    // =======================================
    // Initial Statements
    // Declaraciones iniciales
    // =======================================


    //Smart contract constructor
    constructor (string memory _name, string memory _symbol)
    ERC721(_name, _symbol){}

    // NFT token counter (contador)
    uint256 COUNTER;

    //Pricing of NFT Tokens (price of the artwork)
    //Precio de nuestros NFTs
    uint256 fee = 5 ether;

    //Data structure with the properties of the artwork
    struct Art{
        string name;
        uint256 id;
        uint256 dna;
        uint256 level;
        uint256 rarity;

    }

    // Storage structure for keeping artworks
    // Estructura de almacenamiento

    Art[] public art_works;

    // Declaration of an event
    // Declaracion de un evento

    event NewArtWork (address indexed owner, uint256 id, uint256 dna);

    // =======================================
    // Funciones de ayuda
    // Help functions
    // =======================================


    // Creation of a random number (required of NFT token properties)
    // Creacion de un numero aleatorio (funcion interna "_asd"

    function _createRandomNum(uint256 _mod) internal view returns (uint256){

        bytes32 has_randomNum = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        uint256 randomNum = uint256(has_randomNum);
        return randomNum % _mod;
    }

    // =======================================
    // NFT Token Creation (Artwork)
    // =======================================

    //Function divided into 2 parts = Logical part / Payment part

    function _createArtWork(string memory _name) internal {

        uint8 randRarity = uint8(_createRandomNum(1000));
        uint256 randDna = _createRandomNum(10**16);

    
        Art memory newArtWork = Art(_name, COUNTER, randDna, 1, randRarity);
        art_works.push(newArtWork);
        _safeMint(msg.sender, COUNTER);

        emit NewArtWork(msg.sender, COUNTER, randDna);
        COUNTER++;
    }

    //NFT Toke Price Update
    function updateFee(uint256 _fee) external onlyOwner{
            fee = _fee;

    }

    // Visualize the balance of the Smart Contract (ethers)
    function infoSmartContract() public view returns(address, uint256){

            address SC_address = address(this);
            uint256 SC_money = address(this).balance / 10**10;
            return (SC_address, SC_money);

    }

    // Obtaining all created NFT Tokens (artworks)
    function getArtWorks() public view returns (Art [] memory){

            return art_works;

    }

    // Obtaining a user's NFT Tokens
    function getOwnerArtWork(address _owner) public view returns (Art [] memory){

        Art [] memory result = new Art[](balanceOf(_owner));
        uint256 counter_owner = 0;
        for(uint256 i = 0; i < art_works.length; i++){
             if(ownerOf(i) == _owner){

                result[counter_owner] = art_works[i];
                counter_owner++;
            }
        }
        return result;
    }

    // =======================================
    // NFT Token development
    // =======================================

    // NFT Token Payment
    function createRandomArtWork(string memory _name) public payable{

        require(msg.value >= fee);
        _createArtWork(_name);
    }

    // Extraction of ethers from the Smart Contract to the Owner

    function withdraw() external payable onlyOwner{

        address payable _owner = payable(owner());
        _owner.transfer(address(this).balance);
    }

    // Level up NFT Tokens

    function levelUp(uint256 _artId) public {

        require(ownerOf(_artId) == msg.sender);
        Art storage art = art_works[_artId];
        art.level++;
    }

}
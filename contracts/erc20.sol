// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//Interfaz

interface IERC20{

    //Funcion que devuelve los token existentes
    function totalSupply() external view returns (uint256);

    //Balance de los usuarios
    function balanceOf(address account) external view returns (uint256);

    //Transferencia de tokens > funcion
    //Necesitamos un booleano para saber si realizo la transaccion
    function transfer(address to, uint256 amount) external returns (bool);

    //Ofrezco tokens y el que obtiene gasta los tokens
    function allowance(address owner, address spender) external view returns (uint256);

    //permitir al que prestamos tal cantidad (que prestamos
    function approve(address spender, uint256 amount) external returns (bool);

    //emisor , el que presta
    function transferFrom(

        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    //Eventos que emiten info a la blochchain

    event Transfer(address indexed from, address indexed to, uint256 value);
   // Owner = La persona que aprueba a otra persona para que gaste los fondos
   // Spender = Es la persona que gasta los fondos
   // Value = La cantidad que puede gastar dicha persona
    event Approval(address indexed owner, address indexed spender, uint256 value);


} 

//Heredo los metodos de la interfaz
contract ERC20 is IERC20{
    //Mapping, relaciona una persona con su balance
    mapping(address => uint256) private _balances;
    //Owner = Juan -> Spender Carlos -> Gasta 5 tokens
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    constructor (string memory name_, string memory symbol_){
        _name = name_;
        _symbol = symbol_;
    }

    //Obtener nombre tokens and symbols

    //Concepto de virtual = Funciones fuera de la interfaz 
    function name() public view virtual returns (string memory){

        return _name; 

    }

    function symbol() public view virtual returns (string memory){

        return _symbol; 

    }
 
    function decimals() public view virtual returns (uint8){

        return 18;
    
    }

    //Funciones de retorno
    function totalSupply() public view virtual override returns(uint256){

        return _totalSupply;

    }

    function balanceOf(address account) public view virtual override returns (uint256){

        return _balances[account];

    }

    function transfer(address to, uint256 amount) public virtual override returns (bool){

        address owner = msg.sender;
        transfer(owner, to, amount);
        return true;
    }

    //Funcion cuantos token son asignados la spender (el que gasta
    function allowance(address owner, address spender) public view virtual override returns (uint256){
        //Mapping devuelve Clave owner, clave spender
        return _allowances[owner][spender];
    }

    //Funcion asignacion de tokens
    function approve(address spender, uint256 amount) public virtual override returns (bool){

        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;

    }


    function transferFrom(
        
        address from, 
        address to, 
        uint256 amount) public virtual override returns (bool){

            address spender = msg.sender;
            _spendAllowance(from, spender, amount);
            transfer(from, to, amount);
            return true;

        }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool){

        address owner = msg.sender;
        _approve(owner, spender, _allowances[owner][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool){

        address owner = msg.sender;
        uint256 currentAllowance = _allowances[owner][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decrease allowance below zero");
        unchecked{
            _approve(owner, spender, currentAllowance - subtractedValue);

        }
        return true;
    }

    function transfer(
        address from,
        address to,
        uint256 amount

    ) internal virtual{

        require(from != address(0),"ERC20: transfer from the zero address");
        require(to != address(0),"ERC20: transfer to the zero address");
        _beforeTokenTransfer(from, to , amount);
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: Transfer amount exceds balance ");
        unchecked{

            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;
        emit Transfer(from, to, amount);
        _afterTokenTransfer(from, to, amount);
    }
    //funcion mint permite crear token ERC20
    function _mint(address account, uint256 amount) internal virtual{

        require(account != address(0), "ERC20: mint to the zero address ");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0),account, amount);
        _afterTokenTransfer(address(0),account,amount);

    }
    // _burn Nos permite destruir tokens 
    function _burn(address account, uint256 amount) internal virtual{

        require(account != address(0), "ERC20: brun from the zero address");
        _beforeTokenTransfer(account, address(0), amount);
        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked{
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
        _afterTokenTransfer(account, address(0), amount);

    }

    function _approve(

        address owner,
        address spender,
        uint256 amount

    ) internal virtual{

        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve from the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);

    }

function _spendAllowance(
    address owner,
    address spender,
    uint256 amount
)internal virtual{
    uint256 currentAllowance = allowance(owner, spender);
    if(currentAllowance != type(uint256).max){
        require (currentAllowance >= amount, "ERC20: insufficent allowance");
        unchecked{
            _approve(owner, spender, amount);


        }

    }
}

 function _beforeTokenTransfer(
     address from,
     address to,
     uint256 amount

 )internal virtual {}

 function _afterTokenTransfer(
     address from,
     address to,
     uint256 amount
 )internal virtual {}




}
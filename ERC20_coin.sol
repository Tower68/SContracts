pragma solidity ^0.4.20;

contract ERC20_coin {
    
    uint totalSupply;
    string name;
    string symbol;
    uint8 constant decimals = 18;

    address owner;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

    modifier onlyOwner() { require(msg.sender == owner); _; } 

    function ERC20_coin(uint256 initialSupply, string tokenName, string tokenSymbol) public {
        name = tokenName;
        symbol = tokenSymbol;
        totalSupply = initialSupply * 10 ** uint(decimals);
        owner = msg.sender;
        balances[owner] = totalSupply;
        Transfer(address(0), address(owner), totalSupply);
    }
    
    // Общее кол-во токенов
    function TotalSupply() public constant returns(uint) {
        return totalSupply;
    }
    
    // Баланс конкретного владельца
    function BalanceOf(address _owner) public constant returns(uint256 balance) {
        return balances[_owner];
    }
    
    // Перемещение токенов указанному владельцу
    function transfer(address _to, uint256 _value) public returns(bool success) {
        if(balances[msg.sender] >= _value) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else {
            return false;
        }
    }
    
    // Перемещение токенов от одного владельца другому
    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
        if(allowed[_from][msg.sender] >= _value && balances[_from] >= _value) {
            allowed[_from][msg.sender] -= _value;
            balances[_from] -= _value;
            balances[_to] += _value;
            Transfer(_from, _to, _value);
            return true;
        } else {
            return false;
        }
    }
    
    // Разрешает перевод токенов не владельцу
    function approve(address _spender, uint256 _value) public returns(bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
    // Кому сколько разрешено перевести
    function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
        return allowed[_owner][_spender];
    }
    
    // Покупка токенов
    function buyTokens() public payable returns(bool) {
        if(balances[owner] >= msg.value) {
            balances[owner] -= msg.value;
            balances[msg.sender] += msg.value;
            Transfer(owner, msg.sender, msg.value);
            return true;
        } else {
            return false;
        }
    }
    
    // Продажа токенов
    function sellTokens(uint _qty) public returns(bool) {
        if(balances[msg.sender] >= _qty) {
            balances[msg.sender] -= _qty;
            msg.sender.transfer(_qty);
            Transfer(msg.sender, owner, _qty);
            return true;
        } else {
            return false;
        }   
    }
    
    // Уничтожает контракт
    function kill() public onlyOwner {
        selfdestruct(owner);
    }
} 

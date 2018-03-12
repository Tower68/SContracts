pragma solidity ^0.4.15; 

contract TestCoin {
    
    address owner;
    event Report(string par, uint qt);
    uint TotalCoins;
    uint CurCoins;
    uint Rate=1;
    mapping(address => uint) shares;
    
    function TestCoin(uint _TotalCoins) public payable{
        owner = msg.sender;
        TotalCoins = _TotalCoins;
        CurCoins = TotalCoins;
    }
    
    modifier onlyowner { require (msg.sender == owner); _; }
    
    function ChangeRate(uint _Rate) public onlyowner {
        Rate = _Rate;
    }
    
    function BuyCoins() public payable returns(uint) {
        if(CurCoins >= msg.value / Rate) {
            shares[msg.sender] += msg.value / Rate;
            CurCoins -= msg.value / Rate;
            return shares[msg.sender];
        } else {
            Report("Not enough coins. Coins left - ", CurCoins);
        }
    }    
    
    function SellCoins(uint cqt) public payable returns(uint) {
        if(shares[msg.sender] >= cqt) {
            CurCoins += cqt / Rate;
            shares[msg.sender] -= cqt;
            msg.sender.transfer(cqt * Rate);
            return shares[msg.sender];
        } else {
            Report("You have coins - ", shares[msg.sender]);
        }
    }
    
    function ReporCoins() public {
        Report("Coins Total - ", TotalCoins);
        Report("Coins Left - ", CurCoins);
//        uint bal=this.balance;
        Report("Total Ether in wei - ", this.balance);
    }

    function Balance() public {
        Report("Your Coins - ", shares[msg.sender]);
    }
    
    function Destroy() public onlyowner {
        selfdestruct (owner);
    }
}

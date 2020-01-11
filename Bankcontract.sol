pragma solidity ^0.5.0;

interface Ibank{
    function deposite() payable external;
    function withdrwal(uint amount) payable external returns(address);
    function checkbalance() external view returns(uint);
}

contract Bank is Ibank {
    
     uint8 private totalAccounts;
     uint private totalBalance;
     
     event Deposite(address, uint);
     event Withdrwal(address, uint);
     
     address payable private  owner = msg.sender;
     
     mapping (address => uint) private balances;
     
     modifier ownerOnly() {
         require (owner == msg.sender);
         _;
     }
     
     constructor() public payable {
        require(msg.value >= 50 ether);
        balances[owner] = msg.value;
        owner = msg.sender;
      }
    
     function deposite() payable public {
         if(totalAccounts < 5){
             balances[msg.sender] += msg.value + 10 ether;
         }else {
             balances[msg.sender] += msg.value;
         }
         
         totalBalance += msg.value;
         totalAccounts++;
         emit Deposite(msg.sender, msg.value);
     }
     
     function withdrwal(uint amount) payable public returns(address){
         
         if(amount <= balances[msg.sender]){
         balances[msg.sender] -= amount;
         msg.sender.transfer(amount);
         }
         emit Withdrwal(msg.sender, amount);
         
         return msg.sender;
         }
     
     function checkbalance() public view returns(uint) {
         return balances[msg.sender];
     }
    
    
     function totaldeposite() ownerOnly() view public returns(uint){
         return totalBalance;
     }
     
     function noOfAccounts()ownerOnly() public view returns(uint){
         return totalAccounts;
     }
     
     function closeBank() ownerOnly() public{
         selfdestruct(owner);
     }
     
}










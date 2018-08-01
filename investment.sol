pragma solidity ^0.4.16;

contract BCSToken {
    
    function BCSToken() public {}
    function transfer(address _to, uint256 _value) public {}
    function balanceOf(address _address) public pure returns (uint) {}
    function allowance(address _address1,address _address2) public pure returns (uint) {}
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
}

library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

contract investment{
    using SafeMath for uint;
    address public owner;
    mapping (address => uint) private amount;
    mapping (address => uint) private day;
    mapping (address => uint) private dayDeposit;
    BCSToken dc;
    constructor (address _t) public {
        dc = BCSToken(_t);
        owner = msg.sender;
    }
    function Current () public view returns (uint result){
        return now;
    }
    
    function _withdraw(address _user) private returns (bool result){
        uint _amount =amount[_user];
        uint _day =day[_user];
        uint rewardPerYear = 1000;
        uint sum = 0;
        require(checkTimeUp() == 0);
        
        if(_day == 90 && _amount >= 1000000){
            rewardPerYear = 180;
        }else if(_day == 60 && _amount >= 1000000){
            rewardPerYear = 160;
        }else if(_day == 90 && _amount >= 800000){
            rewardPerYear = 140;
        }else if(_day == 60 && _amount >= 800000){
            rewardPerYear = 120;
        }else if(_day == 90 && _amount >= 500000){
            rewardPerYear = 100;
        }else if(_day == 60 && _amount >= 500000){
            rewardPerYear = 80;
        }else if(_day == 90 && _amount >= 300000){
            rewardPerYear = 60;
        }else if(_day == 60 && _amount >= 300000){
            rewardPerYear = 40;
        }else if(_day == 30 && _amount >= 50001){
            rewardPerYear = 15;
        }else if(_day == 60 && _amount >= 50001){
            rewardPerYear = 25;
        }else if(_day == 90 && _amount >= 50001){
            rewardPerYear = 45;
        }else if(_day == 30 && _amount >= 10001){
            rewardPerYear = 5;
        }else if(_day == 60 && _amount >= 10001){
            rewardPerYear = 15;
        }else if(_day == 90 && _amount >= 10001){
            rewardPerYear = 25;
        }else {
            return false;
        }

        sum = SafeMath.add((SafeMath.div(SafeMath.mul(SafeMath.mul((_amount), rewardPerYear), _day), 365000)), _amount);
        transfer(_user, sum);
        amount[_user] = 0;
        day[_user] = 0;
        dayDeposit[_user] = 0;
        return true;
    }
    
    function transfer(address _to, uint _value) private{
        dc.transfer(_to, _value);
    }
    
    function checkTimeUp() public view  returns (uint result){
        
        //uint temp = SafeMath.add(SafeMath.mul(SafeMath.mul(SafeMath.mul(60,60),24),day[msg.sender]),dayDeposit[msg.sender]); // for mainnet (day-month)
        //uint temp = SafeMath.add(60*day[msg.sender],dayDeposit[msg.sender]); // for test (min-hr)
        uint temp = day[msg.sender]+dayDeposit[msg.sender]; // for test (second-min)
        if(now >= temp){
            return 0;
        }else{
            return SafeMath.sub(temp,now);
        }
    }
    
    function deposit(uint _amount, uint _day, address _toSmartContract) public returns (uint){
        
        uint sum;
        uint reward = 1000;
        require(( _day == 90 || _day == 60 || _day == 30) , "Wrong days");
        require(_amount >= 10001);
        dc.transferFrom(msg.sender, _toSmartContract, _amount);
        amount[msg.sender] = _amount;
        day[msg.sender] = _day;
        dayDeposit[msg.sender] = now;
        
        return sum = SafeMath.div(SafeMath.mul((_amount),reward),1000);
    }
    function withdraw(address _user) public returns (bool result) {
        require(owner == msg.sender);
        return _withdraw(_user);
        
    }
    function withdraw() public returns (bool result){
        return _withdraw(msg.sender);
    }
}

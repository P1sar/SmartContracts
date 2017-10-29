pragma solidity ^0.4.10;

contract DebtBook {
    address moneylender;
    mapping(address => uint) public debtors;

    event AddDebt(uint amount,
                  address debtor,
                  uint resultedAmount);

    event DecrDebt(uint amount,
                   address debtor,
                   uint resultedAmount);

    event Error(string msg);

    function DebtBook() {
        moneylender = msg.sender;
    }

    function addDebt(uint amount) public returns (bool) {
        if(amount < 0) {
          Error('Amount must be grater then zero');
          return false;
        }
        uint hardLimit = 2^256 - 1;
        if(hardLimit - amount < debtors[msg.sender]) {
            Error('Relax! Not so much!');
            return false;
        }
        debtors[msg.sender] += amount;
        AddDebt(amount,
                msg.sender,
                debtors[msg.sender]);
        return true;
    }

   function decrDebt(uint amount, address debtor) public returns (bool) {
        if(msg.sender != moneylender) return false;
        if(amount < 0) {
          Error('Amount must be grater then zero');
          return false;
        }
        if(amount > debtors[debtor]) {
            Error('You cant decrease debt more than it actually is');
            return false;
        }
        debtors[debtor] -= amount;
        DecrDebt(amount,
                 debtor,
                 debtors[debtor]);
        return true;
   }

}
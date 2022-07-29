pragma solidity >=0.4.22 <0.9.0;
contract banking{
    // defining a structure which stores the details of the Account created at the Bank.
    uint256 public serialno = 0;
    uint256 public Bankbalance = 0;
    uint256 public transactionnumber = 0;
    struct Account{
        uint256 serialnumber;
        // uint256 Accountnumber;
        // string Accounttype;
        string name;
        uint256 timeofcreation;
        // string branch;
        string createdby;
        uint256 balance;
        bool statusofaccount;
    }
    // creating a mapping that contains all the details of the account made in the contract
    
    constructor() public{
        account[0] = Account(0,"Sanyam Jain",block.timestamp,"Vansh",0,true);
    }
    // defining a structure which stores the transaction made at the bank by each account
    struct transaction{
        // uint256 Accountnumber;
        // string Accounttype;
        uint256 transactionnumber;
        uint256 currentbalance;
        uint256 transactedamount;
        uint256 doneattime;
        string transactiontype;
    }
    mapping(uint256 => Account) public account;
    mapping(uint256 => transaction) public Transactions;
    // mapping(uint256 => transaction) transactionnumbers;
    // after the account is created the event that is stored
    event accountcreatedby(
        uint256 serialnumber,
        // uint256 Accountnumber,
        string name,
        uint256 balance,
        uint256 creationtime
    );
    // after the transaction is completed the event that is stored and ocurred
    event transactioncompleted(
        // uint256 accountnumber,
        uint256 transactnumber,
        uint256 amount,
        uint256 datetime,
        string transactiontype
    );
    // we credit 2 ethereum by the creators account to the new account if the balance of the creator account has balance more than or equal to 2 ethereum else we revert that the account has insufficient balance.
    function createaccount(address payable _createdby, string memory _Name, string memory _createdbyn) public payable{
        if(_createdby.balance >=2){
            serialno++;
            account[serialno] = Account(
                0, _Name, block.timestamp, _createdbyn, 0, true
            );
            Bankbalance+=2;
            transactionnumber+=1;
            Transactions[transactionnumber] = transaction(transactionnumber, 2, 2, block.timestamp, "New Account");
            emit transactioncompleted(
                transactionnumber,
                2,
                block.timestamp,
                "New Account"
            );
        }else{
            revert("Insufficient Balance.");
        }
    }
    function AddBalance(address payable _creator, uint256 _SerialNo, uint256 TransactionAmount) public payable{
        if(account[_SerialNo].balance >= TransactionAmount/1000000000000 + 1){
            _creator.transfer(TransactionAmount);
            account[_SerialNo].balance = account[_SerialNo].balance - TransactionAmount/1000000000000;
            Bankbalance = Bankbalance - TransactionAmount/1000000000000;
            transactionnumber++;
            Transactions[transactionnumber] = transaction(
                transactionnumber,
                account[serialno].balance,
                TransactionAmount/1000000000000,
                block.timestamp,
                "Adding Balance"
            );
            emit transactioncompleted(
                transactionnumber,
                TransactionAmount/1000000000000,
                block.timestamp,
                "Adding Balance"
            );
        }else{
            revert("Insufficient Funds");
        }
    }
    function withdrawBalance(address payable _creator, uint256 _amount, uint256 _serialno) public payable{
        if(account[_serialno].balance >= _amount/1000000000000000000 + 1){
            _creator.transfer(_amount);
            account[_serialno].balance -= _amount/1000000000000000000;
            Bankbalance += _amount/1000000000000000000;
            transactionnumber++;
            Transactions[transactionnumber] = transaction(
                transactionnumber,
                account[serialno].balance,
                _amount/1000000000000,
                block.timestamp,
                "Withdrawal of Balance"
            );
            emit transactioncompleted(
                transactionnumber,
                _amount/1000000000000,
                block.timestamp,
                "Withdrawal of Balance"
            );
        }else{
            revert("Insufficient Funds");
        }
    }
    function transferamount(uint256 _amount, uint256 serial1,uint256 serial2) public payable{
        if(account[serial1].balance >= _amount/1000000000000 + 1){
            account[serial1].balance -=  _amount/1000000000000;
            account[serial2].balance +=  _amount/1000000000000;
            transactionnumber++;
            Transactions[transactionnumber] = transaction(
                transactionnumber,
                account[serial1].balance,
                _amount/1000000000000,
                block.timestamp,
                "Money Sent"
            );
            emit transactioncompleted(
                transactionnumber,
                _amount/1000000000000,
                block.timestamp,
                "Money Sent"
            );
            transactionnumber++;
            Transactions[transactionnumber] = transaction(
                transactionnumber,
                account[serial2].balance,
                _amount/1000000000000,
                block.timestamp,
                "Money Received"
            );
            emit transactioncompleted(
                transactionnumber,
                _amount/1000000000000,
                block.timestamp,
                "Money Received"
            );
        }else{
            revert("Insufficient Funds");
        }
    }
    function getLoan(uint256 _amount, uint256 _serial) public payable {
            account[_serial].balance += _amount;
            transactionnumber++;
            Transactions[transactionnumber] = transaction(
                transactionnumber,
                account[_serial].balance,
                _amount/1000000000000,
                block.timestamp,
                "Loan Transaction"
            );
            emit transactioncompleted(
                transactionnumber,
                _amount/1000000000000,
                block.timestamp,
                "Loan Transaction"
            );
    }
    function installmentCalc(uint256 _installment,uint256 _serialno,address payable _creator) public payable {
        if(account[_serialno].balance >= _installment/1000000000000){
            account[_serialno].balance -= _installment/1000000000000;
            transactionnumber++;
            Transactions[transactionnumber] = transaction(
                transactionnumber,
                account[_serialno].balance,
                _installment/1000000000000,
                block.timestamp,
                "Withdrawal of Balance"
            );
            emit transactioncompleted(
                transactionnumber,
                _installment/1000000000000,
                block.timestamp,
                "Withdrawal of Balance"
            );
        }else{
            AddBalance(_creator,_serialno,_installment);
            account[_serialno].balance -= _installment/1000000000000;
        }
    }
    function getbalance(uint256 _serialno) public view returns(uint256){
        uint256 bal=account[_serialno].balance;
        return bal;
    }
    function getsenderbal(address payable _account) external view returns(uint256){
        return _account.balance;
    }
    function getContractorBalance() external view returns(uint256) {
        return address(this).balance;
    }
    function getowner() public view returns(address){
        return msg.sender;
    }
}
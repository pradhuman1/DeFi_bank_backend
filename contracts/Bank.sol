// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.11;

contract Bank {
    struct Loan {
        uint256 value;
        string description;
        address payable recipient;
        bool complete;
        uint256 approvalCount;
        mapping(address => bool) approvals;
    }

    uint256 public numLoans;
    mapping(uint256 => Loan) public loans;
    address public manager;
    uint256 public minimumDeposite;
    mapping(address => uint256) public approvers;
    uint256 public approversCount;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    constructor(uint256 minimum) {
        manager = msg.sender;
        minimumDeposite = minimum;
        approversCount = 0;
    }

    function deposite() public payable {
        require(msg.value > minimumDeposite);
        if (approvers[msg.sender] == 0) approversCount++;
        approvers[msg.sender] = approvers[msg.sender] + msg.value;
    }

    function withraw(uint256 amount) public payable {
        require(approvers[msg.sender] >= amount);
        approvers[msg.sender] = approvers[msg.sender] - amount;
        payable(msg.sender).transfer(amount);
    }

    function transferMoney(address payable recipient, uint256 amount)
        public
        payable
    {
        require(approvers[msg.sender] >= amount);
        require(approvers[recipient] > 0);
        approvers[msg.sender] = approvers[msg.sender] - amount;
        approvers[recipient] = approvers[recipient] + amount;

        recipient.transfer(amount);
    }

    function createLoan(string memory description, uint256 value) public {
        Loan storage newLoan = loans[numLoans++];
        newLoan.description = description;
        newLoan.value = value;
        newLoan.recipient = payable(msg.sender);
        newLoan.complete = false;
        newLoan.approvalCount = 0;
    }

    function approveLoan(uint256 index) public {
        Loan storage loan = loans[index];

        require(approvers[msg.sender] > 0);
        require(!loan.approvals[msg.sender]);

        loan.approvalCount++;
        loan.approvals[msg.sender] = true;
    }

    function finalizeLoan(uint256 index) public payable restricted {
        Loan storage loan = loans[index];

        require(loan.approvalCount > approversCount / 2);
        require(!loan.complete);

        loan.recipient.transfer(loan.value);
        loan.complete = true;
    }
}

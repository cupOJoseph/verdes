pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VerdesCore {
    address public owner;
    address public feeReceiver;

    uint256 public feePercentage; //fee percentage is out of 1000

    event DealCreated(uint256 indexed dealId, address indexed depositor, address indexed receiver, uint256 price, uint256 quantity, address tokenAddress, uint256 feePercent);
    event DealExecuted(uint256 indexed dealId);
    event DealCancelled(uint256 indexed dealId);

    struct Deal {
        address depositor;
        address receiver;
        uint256 price;
        uint256 quantity;
        uint256 timestamp;
        address tokenAddress;
        uint256 feePercent;
        bool completed;
    }

    Deal[] public deals;

    uint256 public totalDeals;
    uint256 public totalVolume;

    constructor() {
        owner = msg.sender;

        feePercentage = 1;
        feeReceiver = msg.sender;
    }

    //Create a deal for any token. The depositor will be the one who is giving the tokens to the receiver.
    function createDeal(address _depositor, address _receiver, uint256 _price, uint256 _quantity, address _tokenAddress) external {
        require(_receiver != address(0), "Invalid receiver address");
        require(_price > 0, "Price must be greater than 0");
        require(_quantity > 0, "Quantity must be greater than 0");
        require(_tokenAddress != address(0), "Invalid token address");
        require(_feePercent >= 0 && _feePercent <= 1000, "Invalid fee percentage");

        totalDeals++;
        deals.push(Deal({
            depositor: _depositor,
            receiver: _receiver,
            price: _price,
            quantity: _quantity,
            timestamp: block.timestamp,
            tokenAddress: _tokenAddress,
            feePercent: feePercentage,
            completed: false
        }));

        totalVolume += _price * _quantity;
        totalDeals++;

        IERC20(_tokenAddress).transferFrom(_depositor, address(this), _quantity);

        emit DealCreated(totalDeals, _depositor, _receiver, _price, _quantity, _tokenAddress, _feePercent);
    }

    //Called after the reciever has given the depositor cash IRL. Now the depositor can releas their tokens.
    function executeDeal(uint256 _dealId) external {
        Deal memory deal = deals[_dealId];
        require(!deal.completed, "Deal already completed");
        require(msg.sender == deal.depositor, "Only depositor can execute deal");
        
        uint256 feeAmount = deal.quantity * feePercentage / 1000;

        IERC20(deal.tokenAddress).transferFrom(address(this), deal.receiver, deal.quantity - feeAmount);
        IERC20(deal.tokenAddress).transferFrom(address(this), feeReceiver, feeAmount);

        deal.completed = true;

        emit DealExecuted(_dealId);
    }

    function cancelDeal(uint256 _dealId) external {
        Deal memory deal = deals[_dealId];
        require(!deal.completed, "Deal already completed");
        require(msg.sender == deal.receiver, "Only receiver can cancel deal");

        IERC20(deal.tokenAddress).transferFrom(address(this), deal.depositor, deal.quantity);

        deal.completed = true;

        emit DealCancelled(_dealId);
    }

    function resolveDispute(uint256 _dealId, address _to) external {
        Deal memory deal = deals[_dealId];
        require(!deal.completed, "Deal already completed");
        require(msg.sender == owner, "Only owner can resolve dispute");

        uint256 feeAmount = deal.quantity * feePercentage / 1000;

        IERC20(deal.tokenAddress).transfer(_to, deal.quantity - feeAmount);
    }

    function setFeePercentageAdmin(uint256 _feePercentage) external {
        require(msg.sender == owner, "Only owner can set fee percentage");
        feePercentage = _feePercentage;
    }

    function setFeeReceiverAdmin(address _feeReceiver) external {
        require(msg.sender == owner, "Only owner can set fee receiver");
        feeReceiver = _feeReceiver;
    }

    function updateOwner(address _newOwner) external {
        require(msg.sender == owner, "Only owner can update owner");
        owner = _newOwner;
    }


}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Dappazon {
    address public owner;
    
    //Creates a user defined structure for items
    struct Item {
        uint id;
        string name;
        string category;
        string image;
        uint256 cost;
        uint256 rating;
        uint256 stock;
    }

    struct Order{
        uint256 time;
        Item item;
    }

    mapping(uint256 => Item) public items;
    mapping(address => uint256) public orderCount;
    mapping(address => mapping(uint256 => Order)) public orders;

    event Buy(address buyer, uint256 orderId, uint256 itemId);
    event List(string name, uint256 cost, uint256 quantity);

    //This will modify the behaviour of the function
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;

    }
    constructor(){
        owner = msg.sender;
    }

    //Products list
    //Only the owner will be able to list items in it
    function list(
        uint256 _id,
        string memory _name,
        string memory _category,
        string memory _image,
        uint256 _cost,
        uint256 _rating,
        uint256 _stock
        ) public onlyOwner{
            
            //Creating an Item Struct
            Item memory item = Item(
                _id,
                _name,
                _category,
                _image,
                _cost,
                _rating,
                _stock);

            //Save the Item Struct to blockchain
            items[_id] = item;

            //Emitting our event
            emit List(_name, _cost, _stock);
    }
    //Buy prorducts
    //Allows user to send ethere to the contract
    function buy(uint256 _id) public payable{
        //Fetch items
        Item memory item = items[_id];
        
        //Require the minimum amount of  ether to buy item
        require(msg.value >= item.cost);

        //Require that the item is still in stock
        require(item.stock > 0);

        //Create a new order
        Order memory order = Order(block.timestamp, item);
        
        //Adding the order for user
        orderCount[msg.sender]++;   ///Creates the order ID
        orders[msg.sender][orderCount[msg.sender]] = order;

        //Reduce/Updating the stock
        items[_id].stock--;

        //Emit event
        emit Buy(msg.sender, orderCount[msg.sender], item.id);
    }
    //Withdrawing of funds
    function withdraw() public onlyOwner{
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success);
    }
}

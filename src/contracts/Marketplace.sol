// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Marketplace {
    string public name;
    uint256 public productCount;

    struct Product {
        uint256 id;
        string name;
        uint256 price;
        address payable owner;
        bool purchased;
    }

    mapping(uint256 => Product) public products;

    constructor() {
        name = "Dapp University Marketplace";
    }

    event ProductCreated(
        uint256 id,
        string name,
        uint256 price,
        address payable owner,
        bool purchased
    );

    event ProductPurchased(
        uint256 id,
        string name,
        uint256 price,
        address payable owner,
        bool purchased
    );

    function createProduct(string memory _name, uint256 _price) public payable {
        //require valid name
        require(bytes(_name).length > 0, "Required correct name");
        //require valid price
        require(_price > 0, "Required correct price");
        //incremment prodduct count
        productCount++;
        // create product
        products[productCount] = Product(
            productCount,
            _name,
            _price,
            payable(msg.sender),
            false
        );
        // trigger an event
        emit ProductCreated(
            productCount,
            _name,
            _price,
            payable(msg.sender),
            false
        );
    }

    function purchaseProduct(uint256 _id) public payable {
        // fetch the product
        Product memory _product = products[_id];
        // fetch the owner
        address payable _seller = _product.owner;
        // make sure product has valid id
        require(_product.id > 0 && _product.id <= productCount);
        // require that there is enough ether in the trans
        require(msg.value >= _product.price);
        // require that the product has not already purchased
        require(!_product.purchased);
        // require that the buyer is not the owner
        require(_seller != msg.sender);
        // transfer ownership
        _product.owner = payable(msg.sender);
        // mark as purchased
        _product.purchased = true;
        // update the product
        products[_id] = _product;
        // pay the seller by sending ether
        payable(address(_seller)).transfer(msg.value);
        // trigger an event
        emit ProductPurchased(
            productCount,
            _product.name,
            _product.price,
            payable(msg.sender),
            true
        );
    }
}

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.6;

contract Shop {
  
  constructor() {
    shopOwner = msg.sender;
  }
  
  struct Item {
    string itype;
    string name;
    address author;
    address payable owner;
    uint price;
    uint state;
  }


  address shopOwner;
  Item[] items;
  mapping(uint => address) itemToOwner;

  function registerItem(string memory _type, uint _price, uint _state, string memory _name) public payable {
    items.push(Item(_type, _name, msg.sender, payable(msg.sender), _price, _state));
    itemToOwner[items.length - 1] = msg.sender;
  }

  function buyItem(uint _itemId, uint _newPrice) public payable {
    Item memory item = items[_itemId];
    require(item.owner != address(0));
    require(item.price == msg.value);
    item.owner.transfer(msg.value);
    _transferItem(_itemId, _newPrice);
  }

  function _transferItem(uint _itemId, uint _newPrice ) private {
    _changeOwner(_itemId, payable(msg.sender));
    changePrice(_itemId, _newPrice);
  }

  function changePrice(uint _itemId, uint _newPrice) public {
    items[_itemId].price = _newPrice;
  }

  function _changeOwner(uint _itemId, address payable _newOwner) private {
    items[_itemId].owner = _newOwner;
    itemToOwner[_itemId] = _newOwner;
  }

  function giftItem(uint _itemId, address payable _target) public {
    require(msg.sender == items[_itemId].owner);
    _changeOwner(_itemId, _target);
  }

}
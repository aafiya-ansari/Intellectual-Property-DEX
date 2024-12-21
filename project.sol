// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IntellectualPropertyDEX {
    struct IntellectualProperty {
        string title;
        string description;
        address owner;
        uint256 price;
        bool forSale;
    }

    mapping(uint256 => IntellectualProperty) public intellectualProperties;
    uint256 public propertyCounter;

    event PropertyListed(uint256 propertyId, string title, address owner, uint256 price);
    event PropertyPurchased(uint256 propertyId, address buyer);
    event PropertyUpdated(uint256 propertyId, string title, uint256 price, bool forSale);

    // List a new intellectual property
    function listProperty(string memory _title, string memory _description, uint256 _price) public {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(_price > 0, "Price must be greater than zero");

        propertyCounter++;
        intellectualProperties[propertyCounter] = IntellectualProperty({
            title: _title,
            description: _description,
            owner: msg.sender,
            price: _price,
            forSale: true
        });

        emit PropertyListed(propertyCounter, _title, msg.sender, _price);
    }

    // Purchase an intellectual property
    function purchaseProperty(uint256 _propertyId) public payable {
        IntellectualProperty storage property = intellectualProperties[_propertyId];
        require(property.forSale, "Property is not for sale");
        require(msg.value >= property.price, "Insufficient funds");
        require(property.owner != msg.sender, "Cannot buy your own property");

        address previousOwner = property.owner;
        property.owner = msg.sender;
        property.forSale = false;

        payable(previousOwner).transfer(msg.value);

        emit PropertyPurchased(_propertyId, msg.sender);
    }

    // Update property details
    function updateProperty(uint256 _propertyId, string memory _title, uint256 _price, bool _forSale) public {
        IntellectualProperty storage property = intellectualProperties[_propertyId];
        require(property.owner == msg.sender, "Only the owner can update the property");

        property.title = _title;
        property.price = _price;
        property.forSale = _forSale;

        emit PropertyUpdated(_propertyId, _title, _price, _forSale);
    }

    // Fetch property details
    function getProperty(uint256 _propertyId) public view returns (string memory, string memory, address, uint256, bool) {
        IntellectualProperty memory property = intellectualProperties[_propertyId];
        return (property.title, property.description, property.owner, property.price, property.forSale);
    }
}

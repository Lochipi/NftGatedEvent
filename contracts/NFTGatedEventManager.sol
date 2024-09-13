// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol"; 

contract NFTGatedEventManager {
    address public _owner;
    uint256 public _nextEventId;

    IERC721 public nftContract;

    constructor(address _nftContract) {
        _owner = msg.sender;
        nftContract = IERC721(_nftContract);
    }

    struct Event {
        string name;
        string description;
        uint256 date;
        uint256 price;
        uint256 noOfTickets;
        uint256 noOfTicketsAvailable;
        address organizer;
        address[] attendees;
        uint256 nftId;
    }

    mapping(uint256 => Event) public events;
    mapping(address => mapping(uint256 => uint256)) public tickets;

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only owner can call this function");
        _;
    }

      // Event for new registration
    event Registered(uint eventId, address participant);

    function createEvent(
        string memory _name,
        string calldata _desc,
        uint _date,
        uint _price,
        uint _ticketsCount,
        uint _nftId
    ) public {
        require(_ticketsCount > 0, "Tickets count should be greater than 0");
        require(_price > 0, "Price should be greater than 0");
        require(_date > block.timestamp, "Date should be in future");

        events[_nextEventId] = Event({
            name: _name,
            description: _desc,
            date: _date,
            price: _price,
            noOfTickets: _ticketsCount,
            noOfTicketsAvailable: _ticketsCount,
            organizer: msg.sender,
            attendees: new address[](0),
            nftId: _nftId
        });

        _nextEventId++;
    }

    function registerForEvent(uint256 _eventId, uint256 _quantityOfTickets, uint256 _nftId) public payable {
        require(events[_eventId].date != 0, "event doesnt exist!");
        require( _quantityOfTickets > 0 && _quantityOfTickets <= events[_eventId].noOfTicketsAvailable,
            "Invalid quantity of tickets");
        require(events[_eventId].date > block.timestamp,"Event has already happened");

        Event storage _event = events[_eventId];

        require(nftContract.ownerOf(_nftId) == msg.sender, "You do not own this NFT");

        require(msg.value >= _event.price * _quantityOfTickets, "Insufficient funds");

        _event.attendees.push(msg.sender);
        _event.noOfTicketsAvailable -= _quantityOfTickets;

        tickets[msg.sender][_eventId] += _quantityOfTickets;

        emit Registered(_eventId, msg.sender);
    }

    function getEvent(uint256 _eventId) public view returns (Event memory) {
        return events[_eventId];
    }

    function getEventsUsers(uint256 _eventId) public view returns (address[] memory) {
        return events[_eventId].attendees;
    }
}

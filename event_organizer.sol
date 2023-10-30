// created by Rana jay on 30-10-2023

// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 < 0.9.0;

contract EventContract{

    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }

    // thera are multiple events so mapping to indexes 

    mapping(uint=>Event) public events;

    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name,uint date,uint price,uint ticketCount) external {
        require(date>block.timestamp,"You can organise for future date");
        require(ticketCount>0,"You can organise event if you create more than 0 tickets");
        events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextId++;

    }

    function buyTickets(uint id,uint quanitity)external payable {
        require(events[id].date!=0,"This event does not exist");
        require(events[id].date>block.timestamp,"ebent hase already done");
        Event storage _event = events[id];
        require(msg.value==(_event.price*quanitity),"Not enough ether");
        require(_event.ticketRemain>=quanitity,"Not enough tickets");

        _event.ticketRemain-=quanitity;

        tickets[msg.sender][id] +=quanitity;

    }

    function sendTicket(uint id,uint quanitity,address to)external {
        require(events[id].date!=0,"This event does not exist");
        require(events[id].date>block.timestamp,"ebent hase already done");
        require(tickets[msg.sender][id]>=quanitity,"not enough tickets");
        tickets[msg.sender][id]-=quanitity;
        tickets[to][id]+=quanitity;
    }
}

// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// Contract code will go here
contract Inbox {
    address public manager;
    address[] public players;

    constructor() {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value > 0.01 ether);
        players.push(msg.sender);
    }

    function random() private view returns (uint) {
        return
            uint(
                keccak256(
                    abi.encodePacked(block.difficulty, block.timestamp, players)
                )
            );
    }

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function pickWinner() public restricted {
        uint index = random() % players.length;
        address winner = players[index];
        payable(winner).transfer(address(this).balance);
        players = new address[](0);
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}

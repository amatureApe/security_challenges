pragma solidity ^0.4.21;

import "src/GuessTheSecretNumber.sol";

// Answer is 170 and can be found by following stack trace in foundry
// but since contract DSTest can only work with >0.5.0, can't deal funds.

contract GuessTheSecretNumberTest {
    GuessTheSecretNumber guessTheSecretNumber;
    bytes32 constant answerHash =
        0xdb81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365;

    function setUp() public {
        guessTheSecretNumber = new GuessTheSecretNumber();
    }

    function testBruteForceGuess() public {
        for (uint8 i = 0; i <= 255; i++) {
            if (keccak256(abi.encodePacked(i)) == answerHash) {
                guessTheSecretNumber.guess.value(1 ether)(i);
                assert(guessTheSecretNumber.isComplete());
                return;
            }
        }
        assert(false);
    }
}

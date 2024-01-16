pragma solidity ^0.6.0;

contract RockPaperScissors {
    enum Choice { ROCK, PAPER, SCISSORS }

    mapping(address => Choice) public choices;

    modifier hasNotPlayed() {
        require(choices[msg.sender] == Choice(0), "You have already played.");
        _;
    }

    event GameResult(address winner, address loser, Choice winnerChoice, Choice loserChoice);

    function play(Choice choice) external hasNotPlayed {
        choices[msg.sender] = choice;
    }

    function evaluate(
        address alice,
        Choice aliceChoice,
        bytes32 aliceRandomness,
        address bob,
        Choice bobChoice,
        bytes32 bobRandomness
    ) external view returns (address) {
        require(keccak256(abi.encodePacked(aliceChoice, aliceRandomness)) == bytes32(choices[alice]));
        require(keccak256(abi.encodePacked(bobChoice, bobRandomness)) == bytes32(choices[bob]));

        if (aliceChoice == bobChoice) {
            return address(0);
        }

        if ((aliceChoice == Choice.ROCK && bobChoice == Choice.PAPER) ||
            (aliceChoice == Choice.PAPER && bobChoice == Choice.SCISSORS) ||
            (aliceChoice == Choice.SCISSORS && bobChoice == Choice.ROCK)) {
            emit GameResult(bob, alice, bobChoice, aliceChoice);
            return bob;
        }

        emit GameResult(alice, bob, aliceChoice, bobChoice);
        return alice;
    }
}

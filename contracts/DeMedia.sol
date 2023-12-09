// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./IAnonAadhaarVerifier.sol";

contract DeMedia {
    struct Media {
        string description;
        uint256 yes;
        uint256 no;
        uint256 abstain;
        uint256 voteCount;
        // This can be replaced by the nullifier
        // Nullifier can be accessed by calling _pubSignals[0]
        mapping(uint256 => bool) hasVoted;
    }
    address public anonAadhaarVerifierAddr;
    uint256 public mediaCounter;

    event Voted(address indexed _from, uint256 indexed _mediaIndex);
    event Created(address indexed _from, uint256 indexed _mediaIndex);

    // List of media
    Media[] public medias;

    // Constructor to initialize proposals
    constructor(address _verifierAddr) {
        anonAadhaarVerifierAddr = _verifierAddr;
        mediaCounter = 0;
    }

    function verify(uint256[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[34] calldata _pubSignals) public view returns (bool) {
        return IAnonAadhaarVerifier(anonAadhaarVerifierAddr).verifyProof(_pA, _pB, _pC, _pubSignals);
    }

    // Function to add media
    function addMedia(string description, uint256[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[34] calldata _pubSignals) public {
        // Needs to be an anon-verified user
        require(verify(_pA, _pB, _pC, _pubSignals), "Your idendity proof is not valid");

        mediaCounter++;
        medias.push(Media(description, 0, 0, 0, 0));

        emit Created(msg.sender, mediaCounter);
    }

    // Function to vote on media
    function voteForProposal(uint256 proposalIndex, uint256[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[34] calldata _pubSignals) public {
        require(proposalIndex < proposals.length, "Invalid proposal index");
        require(!hasVoted[msg.sender], "You have already voted");
        require(verify(_pA, _pB, _pC, _pubSignals), "Your idendity proof is not valid");

        proposals[proposalIndex].voteCount++;
        hasVoted[msg.sender] = true;

        emit Voted(msg.sender, proposalIndex);
    }
}

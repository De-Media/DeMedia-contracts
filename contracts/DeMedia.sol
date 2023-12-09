// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./IAnonAadhaarVerifier.sol";

contract DeMedia {
    struct Media {
        // TODO: add pool type
        string description;
        // type of news tag: social, feedback, critique
        string tag;
        uint256 yes;
        uint256 no;
        uint256 abstain;
        uint256 voteCount;
        // Nullifier can be accessed by calling _pubSignals[0]
        mapping(uint256 => bool) hasAnswered;
    }
    address public anonAadhaarVerifierAddr;
    uint256 public mediaCounter;

    // Score storage
    struct Score {
        // number of media reports a person has responsed on.
        uint256 responseTotal;
        // TODO: add more parameters
    }
    mapping(uint256 => Score) scoreTrack;

    event Answered(address indexed _from, uint256 indexed _mediaIndex);
    event Created(address indexed _from, uint256 indexed _mediaIndex);

    // List of media
    mapping(uint256 => Media) medias;

    // Constructor to initialize proposals
    constructor(address _verifierAddr) {
        anonAadhaarVerifierAddr = _verifierAddr;
        mediaCounter = 0;
    }

    function verify(uint256[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[34] calldata _pubSignals) public view returns (bool) {
        return IAnonAadhaarVerifier(anonAadhaarVerifierAddr).verifyProof(_pA, _pB, _pC, _pubSignals);
    }

    // Function to add media
    function addMedia(string calldata description, uint256[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[34] calldata _pubSignals) public {
        // Needs to be an anon-verified user
        require(verify(_pA, _pB, _pC, _pubSignals), "Your idendity proof is not valid");

        mediaCounter++;
        medias[mediaCounter].description = description;

        emit Created(msg.sender, mediaCounter);
    }

    // Function to vote on media
    function responseOnMedia(uint256 mediaIndex, uint256[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[34] calldata _pubSignals) public {
        require(mediaIndex > mediaCounter, "Invalid media index");
        require(!medias[mediaIndex].hasAnswered[_pubSignals[0]], "You have already voted");
        require(verify(_pA, _pB, _pC, _pubSignals), "Your idendity proof is not valid");

        medias[mediaIndex].voteCount++;
        medias[mediaIndex].hasAnswered[_pubSignals[0]] = true;
        scoreTrack[_pubSignals[0]].responseTotal++;

        emit Answered(msg.sender, mediaIndex);
    }

    // TODO: Generate random numbers ?
    // TODO: Add more features

    // Function to get the total number of media
    function getMediaCount() public view returns (uint256) {
        return mediaCounter;
    }

    // Function to get media information by index
    function getMedia(uint256 mediaIndex) public view returns (string memory, uint256, uint256, uint256, uint256) {
        require(mediaIndex > mediaCounter, "Invalid media index");

        Media storage media = medias[mediaIndex];
        return (media.description, media.yes, media.no, media.abstain, media.voteCount);
    }

    // Function to check if a user has already voted on a specific media
    // User here is ID
    // TODO: how unique id is generated ?
    // function checkVoted(uint256 id, uint256 mediaIndex) public view returns (bool) {
    //     return hasVoted[_addr];
    // }
}

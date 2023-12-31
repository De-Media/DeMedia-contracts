// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./IAnonAadhaarVerifier.sol";

contract DeMedia {
    struct Media {
        string title;
        string description;
        // type of news tag: social, feedback, critique, tech
        string[] tags;
        uint256 flag; // uint256 Default: yes or no, could be agree or disagree, etc

        uint256 yes;
        uint256 no;
        uint256 abstain;
        uint256 reponseCount;

        // isPoll, use poll if true
        bool isPoll;
        string[] polls;
        uint256[] pollsCount;
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
    event Created(
        address indexed _from,
        uint256 indexed _mediaIndex
    );

    // List of media
    mapping(uint256 => Media) medias;
    // Voted data
    // Nullifier can be accessed by calling _pubSignals[0]
    mapping (uint256 => mapping (uint256 => bool)) hasVoted;

    // Constructor to initialize proposals
    constructor(address _verifierAddr) {
        anonAadhaarVerifierAddr = _verifierAddr;
        mediaCounter = 0;
    }

    function verify(uint256[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[34] calldata _pubSignals) public view returns (bool) {
        return IAnonAadhaarVerifier(anonAadhaarVerifierAddr).verifyProof(_pA, _pB, _pC, _pubSignals);
    }

    // Function to add media
    function addMedia(
        string[] calldata media,
        string[] calldata polls,
        uint256 flag,
        string[] calldata tags,
        uint256[2] calldata _pA, uint[2][2] calldata _pB,
        uint[2] calldata _pC, uint[34] calldata _pubSignals
    ) public {
        // Needs to be an anon-verified user
        require(verify(_pA, _pB, _pC, _pubSignals), "Your idendity proof is not valid");

        mediaCounter++;
        medias[mediaCounter].description = media[0];
        medias[mediaCounter].flag = flag;
        for(uint256 i = 0; i < tags.length; i++) {
            medias[mediaCounter].tags.push(tags[i]);
        }

        if (polls.length > 0) {
            medias[mediaCounter].isPoll = true;
            for(uint256 i = 0; i < polls.length; i++) {
                medias[mediaCounter].polls.push(polls[i]);
            }
        }

        emit Created(msg.sender, mediaCounter);
    }

    // Function to vote on media
    function responseOnMedia(uint256 mediaIndex, string calldata response, string calldata poll, uint256[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[34] calldata _pubSignals) public {
        require(mediaIndex <= mediaCounter, "Invalid media index");
        require(!hasVoted[mediaIndex][_pubSignals[0]], "You have already voted");
        require(verify(_pA, _pB, _pC, _pubSignals), "Your idendity proof is not valid");

        medias[mediaIndex].reponseCount++;
        if (medias[mediaIndex].isPoll) {
            for (uint256 i = 1; i <= medias[mediaIndex].polls.length; i++) {
                if (keccak256(bytes(medias[mediaIndex].polls[i])) == keccak256(bytes(poll))) {
                    medias[mediaIndex].pollsCount[i]++;
                }
            }
        } else {
            if (keccak256(bytes(response)) == keccak256(bytes("yes"))) {
                medias[mediaIndex].yes++;
            }
            else if (keccak256(bytes(response)) == keccak256(bytes("no"))) {
                medias[mediaIndex].no++;
            }
            else if (keccak256(bytes(response)) == keccak256(bytes("abstain"))) {
                medias[mediaIndex].abstain++;
            }
        }

        hasVoted[mediaIndex][_pubSignals[0]] = true;
        scoreTrack[_pubSignals[0]].responseTotal++;

        emit Answered(msg.sender, mediaIndex);
    }

    // Note: Only used for testing purpose
    // function addData(string calldata description,
    //     bool isPoll,
    //     string[] calldata polls
    // ) public {
    //     mediaCounter++;
    //     medias[mediaCounter].description = description;

    //     medias[mediaCounter].yes = 3;
    //     medias[mediaCounter].no = 1;
    //     medias[mediaCounter].abstain = 1;

    //     if (isPoll) {
    //         for(uint256 i = 0; i < polls.length; i++) {
    //             medias[mediaCounter].polls.push(polls[i]);
    //             medias[mediaCounter].pollsCount.push(i);
    //         }
    //     }
    // }

    // TODO: Add more features

    // Function to get the total number of media
    function getMediaCount() public view returns (uint256) {
        return mediaCounter;
    }

    // Function to get media information by index
    // returns description, tags, flag, isPoll, polls data,
    // yes, no, abstain, responseCount
    function getMedia(uint256 mediaIndex)
        public view returns (string memory, string[] memory,
        uint256, bool, string[] memory, uint256[] memory,
        uint256, uint256, uint256, uint256) {
        require(mediaIndex <= mediaCounter, "Invalid media index");
        Media memory media = medias[mediaIndex];
        return (
            media.description,
            media.tags,
            media.flag,
            media.isPoll,
            media.polls,
            media.pollsCount,
            media.yes,
            media.no,
            media.abstain,
            media.reponseCount
        );
    }
}

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
    }
    address public anonAadhaarVerifierAddr;

    event Voted(address indexed _from, uint256 indexed _propositionIndex);

    // List of media
    Media[] public proposals;

    // This can be replaced by the nullifier
    // Nullifier can be accessed by calling _pubSignals[0]
    mapping(uint256 => bool) public hasVoted;

    // Constructor to initialize proposals
    constructor(address _verifierAddr) {
        anonAadhaarVerifierAddr = _verifierAddr;
    }

    function verify(uint256[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[34] calldata _pubSignals) public view returns (bool) {
        return IAnonAadhaarVerifier(anonAadhaarVerifierAddr).verifyProof(_pA, _pB, _pC, _pubSignals);
    }
}

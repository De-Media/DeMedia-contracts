import "@nomiclabs/hardhat-ethers";
import { ethers } from "hardhat";

async function main() {
    let Verifier = await ethers.getContractFactory("Verifier");
    let verifier = await Verifier.deploy();
    let appIdBigInt = "196700487049306364386084600156231018794323017728";

    await verifier.waitForDeployment();
    const _verifierAddress = verifier.getAddress();

    console.log(_verifierAddress, "HERE----->>");

    const AnonAadhaarVerifier = await ethers.getContractFactory(
      "AnonAadhaarVerifier"
    );
    const anonAadhaarVerifier = await AnonAadhaarVerifier.deploy(
      _verifierAddress,
      appIdBigInt
    );

    await anonAadhaarVerifier.waitForDeployment();
    const _AnonAadhaarVerifierAddress = anonAadhaarVerifier.getAddress();
    console.log(_AnonAadhaarVerifierAddress, "HERE----->>");


    let Vote = await ethers.getContractFactory("DeMedia");
    let vote = await Vote.deploy(
      _AnonAadhaarVerifierAddress
    );

    console.log(vote.getAddress(), "HERE----->>");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

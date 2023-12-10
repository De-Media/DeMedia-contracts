import "@nomiclabs/hardhat-ethers";
import { ethers } from "hardhat";

async function main() {
    // let Verifier = await ethers.getContractFactory("Verifier");
    // let verifier = await Verifier.deploy();
    // let appIdBigInt = "196700487049306364386084600156231018794323017728";

    // await verifier.waitForDeployment();
    // const _verifierAddress = verifier.getAddress();

    // console.log(_verifierAddress, "HERE----->>");

    // const AnonAadhaarVerifier = await ethers.getContractFactory(
    //   "AnonAadhaarVerifier"
    // );
    // const anonAadhaarVerifier = await AnonAadhaarVerifier.deploy(
    //   _verifierAddress,
    //   appIdBigInt
    // );

    // await anonAadhaarVerifier.waitForDeployment();
    // const _AnonAadhaarVerifierAddress = anonAadhaarVerifier.getAddress();
    // console.log(_AnonAadhaarVerifierAddress, "HERE----->>");

    let DeMedia = await ethers.getContractFactory("DeMedia");
    let demedia = await DeMedia.deploy(
      '0x6a5Ad93f028528840014Fb2291378bCbe021962e'
    );

    await demedia.waitForDeployment();

    console.log(demedia.getAddress(), "HERE----->>");

    // await demedia.addData("ETHIndia is largest hackathon", false, []);

    // await demedia.addData("Poll test", true, ["poll-1", "poll-2", "poll-3"]);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

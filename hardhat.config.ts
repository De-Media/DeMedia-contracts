import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-dependency-compiler";
require("dotenv").config({ path: ".env" });

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  dependencyCompiler: {
    paths: ["anon-aadhaar-contracts/contracts/Verifier.sol"],
  },
  networks: {
    polygonMumbai: {
      url: "https://mumbai.polygonscan.com/",
      accounts: [process.env.PRIVATE_KEY || ""],
    },
    scroll: {

    },
    okx: {

    },
    goerli: {
      url: "https://ethereum-goerli.publicnode.com",
      accounts: [process.env.PRIVATE_KEY || ""],
    },
  },
};

export default config;

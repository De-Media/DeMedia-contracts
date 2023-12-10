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
      url: "https://polygon-mumbai-bor.publicnode.com",
     //  url: "https://rpc-mumbai.matic.today",
     // url: "https://rpc-mumbai.maticvigil.com",
      accounts: [process.env.PRIVATE_KEY || ""],
      gasPrice: 35000000000,
    },
    scroll: {
      url: "https://sepolia-rpc.scroll.io",
      //  url: "https://rpc-mumbai.matic.today",
      // url: "https://rpc-mumbai.maticvigil.com",
       accounts: [process.env.PRIVATE_KEY || ""],
       //gasPrice: 35000000000,
    },
    // okx: {

    // },
    goerli: {
      url: "https://ethereum-goerli.publicnode.com",
      accounts: [process.env.PRIVATE_KEY || ""],
    },
  },
  etherscan: {
    apiKey: {
      scroll: 'U68J8UHTQBQ2Q642F1MAR1G7DNI8MS9V96',
    },
    customChains: [
      {
        network: 'scroll',
        chainId: 534351,
        urls: {
          apiURL: 'https://sepolia-blockscout.scroll.io/api',
          browserURL: 'https://sepolia-blockscout.scroll.io/',
        },
      },
    ],
  },
};

export default config;

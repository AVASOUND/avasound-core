require('dotenv').config();
require("@nomiclabs/hardhat-waffle");
require('@nomiclabs/hardhat-ethers');

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();
  for (const account of accounts) {
    console.log(account.address);
  }
});

const alchemyApiKey = process.env.ALCHEMY_API_KEY;
const privateKey = process.env.PRIVATE_KEY;
const etherscanKey = process.env.ETHERSCAN_KEY;

module.exports = {
  solidity: "0.8.0",
  networks: {
    ropsten: {
      url: `https://eth-ropsten.alchemyapi.io/v2/${alchemyApiKey}`,
      accounts: [`0x${privateKey}`]
    },
  },
  etherscan: {
    apiKey: etherscanKey
  }
};
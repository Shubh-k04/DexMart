require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    hardhat: {
      chainId: 1337 // Or any other chain ID you want to use for the local network
    }
  },
  solidity: "0.8.17",
};

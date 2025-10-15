const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  const balance = await ethers.provider.getBalance(deployer.address);
  console.log("Deploying contracts with account:", deployer.address);
  console.log("Account balance:", balance.toString());

  const Token = await ethers.getContractFactory("Token");
  const token = await Token.deploy();

  await token.waitForDeployment();

  console.log("Token deployed to:", await token.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

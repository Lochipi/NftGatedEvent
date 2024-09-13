import { ethers } from "hardhat";

async function main() {
    // Deploy the EventNFT contract
    const EventNFT = await ethers.getContractFactory("EventNFT");
    const eventNFT = await EventNFT.deploy();
    await eventNFT.deployed();
    console.log("EventNFT deployed to:", eventNFT.address);
  
    // Deploy the NFTGatedEventManager contract, pass the EventNFT address
    const NFTGatedEventManager = await ethers.getContractFactory("NFTGatedEventManager");
    const eventManager = await NFTGatedEventManager.deploy(eventNFT.address);
    await eventManager.deployed();
    console.log("NFTGatedEventManager deployed to:", eventManager.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  
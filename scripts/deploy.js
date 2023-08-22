const hre = require("hardhat");

const dateTimeLibraryRopsten = "0x947cc35992e6723de50bf704828a01fd2d5d6641";
const dateTimeLibraryEthereum = "0x23d23d8f243e57d0b924bff3a3191078af325101";

const dateTimeLibrary = dateTimeLibraryRopsten;

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const NFTDescriptor = await ethers.getContractFactory("NFTDescriptor");
  const nftDescriptorLib = await NFTDescriptor.deploy();
  await nftDescriptorLib.deployed();

  console.log("Library address:", nftDescriptorLib.address);

  const OnchainArt = await ethers.getContractFactory("OnchainArt", {
    libraries: {
      NFTDescriptor: nftDescriptorLib.address,
    },
  });
  const name = "OnchainArt";
  const symbol = "OnchainArt";
  const collectionSymbol = "TICK";
  const onchainArt = await OnchainArt.deploy(
    name,
    symbol,
    collectionSymbol,
    dateTimeLibrary,
  );
  await onchainArt.deployed();

  console.log("Token address:", onchainArt.address);

  // The delay is necessary to avoid "the address does not have bytecode" error
  await delay(50000);

  await hre.run("verify:verify", {
    address: onchainArt.address,
    network: "ftmTestnet",
    constructorArguments: [
      name,
      symbol,
      collectionSymbol,
      dateTimeLibrary,
    ],
    libraries: {
      NFTDescriptor: nftDescriptorLib.address,
    }
  });
}

async function callContract() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const OnchainArt = await ethers.getContractFactory("OnchainArt", {
    libraries: {
      NFTDescriptor: "0x237fd2F520e07597f344bF29aDD82e13048E3147",
    },
  });
  const contract = await OnchainArt.attach(
    "0x9E8bcf8360Da63551Af0341A67538c918ba81007" // The deployed contract address
  );

  // Now you can call functions of the contract
  const result = await contract.isAdmin("0xc7b266aafcea5c1d8e6d90339a73cca34e476492");
  console.log(result);
}

const delay = ms => new Promise(res => setTimeout(res, ms));

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

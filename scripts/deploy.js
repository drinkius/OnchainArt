const hre = require("hardhat");

const dateTimeLibraryRopsten = "0x947cc35992e6723de50bf704828a01fd2d5d6641";
const dateTimeLibraryGoerli = "0xe7d178e435e009ded2759fb946bdccc09d567d15";
const dateTimeLibraryEthereum = "0x23d23d8f243e57d0b924bff3a3191078af325101";

const dateTimeLibrary = dateTimeLibraryGoerli;

var currentDescriptorAddressGoerli = "0x6BF24a380781c7255e61473d5cbb2CCD2335bA00";
var currentNFTAddressGoerli = "0x1A7E2fb6f19B10ff28a1b6Fc2Ab1A8916f27B1f3";

var currentDescriptorAddress = currentDescriptorAddressGoerli;
var currentNFTAddress = currentNFTAddressGoerli;

const verify = false

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  // await mintToken()
  // return

  /* Unneeded since we don't setup an external library link yet
  if (dateTimeLibrary == "") {
    const TimeLibrary = await ethers.getContractFactory("BokkyPooBahsDateTimeLibrary");
    const timeLibrary = await TimeLibrary.deploy();
    await timeLibrary.deployed();
    console.log("Address of TimeLibrary:", timeLibrary.address);
    dateTimeLibrary = timeLibrary.address

    await delay(20000);
    await hre.run("verify:verify", {
      address: dateTimeLibrary,
      contract: "contracts/libraries/BokkyPooBahsDateTimeLibrary.sol:BokkyPooBahsDateTimeLibrary",
      constructorArguments: [
      ],
      libraries: {
      }
    });
  }
  */

  const NFTDescriptor = await ethers.getContractFactory("NFTDescriptor");
  const nftDescriptorLib = await NFTDescriptor.deploy();
  await nftDescriptorLib.deployed();

  console.log("Library address:", nftDescriptorLib.address);
  currentDescriptorAddress = nftDescriptorLib.address

  const OnchainArt = await ethers.getContractFactory("OnchainArt", {
    libraries: {
      NFTDescriptor: currentDescriptorAddress,
    },
  });
  const name = "OnchainArt";
  const symbol = "OnchainArt";
  const collectionSymbol = "TICK";
  const onchainArt = await OnchainArt.deploy(
    name,
    symbol,
    collectionSymbol,
  );
  await onchainArt.deployed();

  console.log("Token address:", onchainArt.address);
  currentNFTAddress = onchainArt.address;

  if (verify) {
    // The delay is necessary to avoid "the address does not have bytecode" error
  await delay(20000);

  await hre.run("verify:verify", {
    address: currentNFTAddress,
    constructorArguments: [
      name,
      symbol,
      collectionSymbol,
    ],
    libraries: {
      NFTDescriptor: currentDescriptorAddress,
    }
  });
  }

  await mintToken()
}

async function mintToken() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const OnchainArt = await ethers.getContractFactory("OnchainArt", {
    libraries: {
      NFTDescriptor: currentDescriptorAddress,
    },
  });
  const contract = await OnchainArt.attach(
    currentNFTAddress // The deployed contract address
  );

  // Now you can call functions of the contract
  const result = await contract.mint(
    deployer.address,
    1702785345,
    111
  );
  console.log(result);
}

const delay = ms => new Promise(res => setTimeout(res, ms));

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

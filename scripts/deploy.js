// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  console.log(`Using Network ${hre.network.config.url || "hardhat"}`)
  const [deployer] = await hre.ethers.getSigners()
  console.log(`Using Account ${deployer.address}`)
  const IPFSContractFactory = await hre.ethers.getContractFactory("IPFS");
  console.log("Deploying Contract ....");
  const ipfs = await IPFSContractFactory.deploy();

  await ipfs.deployed();

  console.log(
    `Contract deployed to the address :  ${ipfs.address}`
  );

  if(hre.network.config.chainId === 5 && process.env.ETHERSCAN_API_KEY){
    await ipfs.deployTransaction.wait(6)
    await verify(ipfs.address,[])
  }
}

//verify with block inspector
async function verify(contractAddress,args) {
  console.log("Verifying Contract ....");
  try{
  await hre.run("verify:verify",{
    address:contractAddress,
    constructorArguments: args,
  })}
  catch(e){
    if(e.message.toLowerCase().includes("already verified")){
      console.log("Already Verified")
    }
    else{
      console.log(e)
    }

  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

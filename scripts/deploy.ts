import { ethers } from 'hardhat';

async function main() {
	const testFactory = await ethers.getContractFactory('BondTokenFactory');
	const testFactoryInstance = await testFactory.deploy();
	console.log('Factory Contract deployed to address:', testFactoryInstance.address);
  console.log((testFactoryInstance.deployTransaction.gasLimit))

  const testMaker = await ethers.getContractFactory('BondMaker');
  // use 1 decimal instead of 18 decimal point
	const testMakerInstance = await testMaker.deploy(1, testFactoryInstance.address);
	console.log('Maker Contract deployed to address:', testMakerInstance.address);
  console.log((testMakerInstance.deployTransaction.gasLimit))
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});

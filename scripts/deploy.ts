import { ethers } from 'hardhat';

async function main() {
	const testFactory = await ethers.getContractFactory('BondTokenFactory');
	const testFactoryInstance = await testFactory.deploy();
	console.log('Factory Contract deployed to address:', testFactoryInstance.address);
  console.log((testFactoryInstance.deployTransaction.gasLimit))

  const testMaker = await ethers.getContractFactory('BondMaker');
	const testMakerInstance = await testMaker.deploy(18, testFactoryInstance.address);
	console.log('Maker Contract deployed to address:', testMakerInstance.address);
  console.log((testMakerInstance.deployTransaction.gasLimit))
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});

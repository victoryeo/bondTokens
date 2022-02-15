import { ethers } from 'hardhat';

async function main() {
	const testFactory = await ethers.getContractFactory('BondMaker');
	const testInstance = await testFactory.deploy();
	console.log('Contract deployed to address:', testInstance.address);
  console.log((testInstance.deployTransaction.gasLimit))
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});

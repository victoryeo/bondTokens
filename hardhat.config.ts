import '@nomiclabs/hardhat-ethers';
import '@nomiclabs/hardhat-waffle';
import { task, HardhatUserConfig } from 'hardhat/config';

// see https://hardhat.org/guides/create-task.html
task('accounts', 'Prints the list of accounts', async (args, hre) => {
	const accounts = await hre.ethers.getSigners();

	for (const account of accounts) {
		console.log(account.address);
	}
});

const { mnemonic, api_key, INFURA_API_KEY } = require('./.secret.json');

const MUMBAI_API_URL = `https://rpc-mumbai.maticvigil.com/v1/${api_key}`;
const MATIC_API_URL = `https://rpc-mainnet.maticvigil.com/v1/${api_key}`;
const rinkebyUrl = `https://rinkeby.infura.io/v3/${INFURA_API_KEY}`;

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
export default {
	solidity: {
		version: '0.8.0',
		settings: {
			optimizer: {
				enabled: true,
				runs: 200,
			},
		},
	},
	defaultNetwork: 'local',
	networks: {
		local: {
			url: 'http://127.0.0.1:9545',
		},
		mumbai: {
			url: MUMBAI_API_URL,
			accounts: { mnemonic: mnemonic },
			gas: 2100000,
			gasPrice: 8000000000,
		},
		matic: {
			url: MATIC_API_URL,
			accounts: { mnemonic: mnemonic },
			gas: 2100000,
			gasPrice: 8000000000,
		},
    rinkeby: {
      url: rinkebyUrl,
      accounts: { mnemonic: mnemonic },
      gas: 4612388 // Gas limit used for deploys
    },
		hardhat: {},
	},
} as HardhatUserConfig;

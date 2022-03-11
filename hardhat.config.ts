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

const { mnemonic, api_key } = require('./.secret.json');
const rinkebyUrl = `https://eth-rinkeby.alchemyapi.io/v2/${api_key}`;

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
    rinkeby: {
      url: rinkebyUrl,
      accounts: { mnemonic: mnemonic },
      gas: 4612388 // Gas limit used for deploys
    },
		hardhat: {},
	},
} as HardhatUserConfig;

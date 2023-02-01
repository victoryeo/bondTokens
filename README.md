### bond tokens smart contract written in solidity
bond tokens using ERC20 standard   

#### deploy contract to Ethereum Goerli network
npx hardhat run scripts/deploy.ts  --network goerli  
npx hardhat run scripts/deploy.ts  --network rinkeby  

#### verify contract on Etherscan
npx hardhat verify --network goerli 0xdE875b6715fB5e02e769741F19A2f6976707aC8a  

npx hardhat verify --network goerli 0xA91ba6d3Bf8C31F9BD6e623d5400D92bE1b0097E 1 0xdE875b6715fB5e02e769741F19A2f6976707aC8a  

#### foundry forge test script
run "forge test"
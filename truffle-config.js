 const HDWalletProvider = require('@truffle/hdwallet-provider');

 const fs = require('fs');
 const mnemonic = JSON.parse(fs.readFileSync(".secret.json").toString().trim());
 console.log(mnemonic)
 console.log(mnemonic["mnemonic"])

 module.exports = {
   /**
    * Networks define how you connect to your ethereum client and let you set the
    * defaults web3 uses to send transactions. If you don't specify one truffle
    * will spin up a development blockchain for you on port 9545 when you
    * run `develop` or `test`. You can ask a truffle command to use a specific
    * network from the command line, e.g
    *
    * $ truffle test --network <network-name>
    */
 
   networks: {
     // Useful for testing. The `development` name is special - truffle uses it by default
     // if it's defined here and no other network is specified at the command line.
     // You should run a client (like ganache-cli, geth or parity) in a separate terminal
     // tab if you use this network and you must also set the `host`, `port` and `network_id`
     // options below to some value.
     //
     development: {
       host: "127.0.0.1",     // Localhost (default: none)
       port: 9545,            // Standard Ethereum port (default: none)
       network_id: "*",       // Any network (default: none)
     },
     rinkeby: {
       provider: () => new HDWalletProvider(
         mnemonic["mnemonic"], `wss://rinkeby.infura.io/ws/v3/deb659283df04e84a22f0ce14a3459c2`
       ),
       network_id: 4,       
       gas: 5500000,        
       //confirmations: 2,
       networkCheckTimeout: 1000000,    
       timeoutBlocks: 200, 
       skipDryRun: true     
     },    
     mumbai: {
      provider: () => new HDWalletProvider(
        mnemonic["mnemonic"], `https://matic-mumbai.chainstacklabs.com/`
      ),
      network_id: 80001,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

   },
 
   // Set default mocha options here, use special reporters etc.
   mocha: {
     // timeout: 100000
   },
 
   // Configure your compilers
   compilers: {
     solc: {
       version: "0.8.0",    // Fetch exact version from solc-bin (default: truffle's version)
       settings: {          // See the solidity docs for advice about optimization and evmVersion
         optimizer: {
           enabled: true,
           runs: 200
         },
       //  evmVersion: "byzantium"
       }
     }
   },
 

 };
 
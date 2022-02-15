// migrations/2_deploy.js
// SPDX-License-Identifier: MIT
const instance = artifacts.require("BondMaker");

module.exports = function(deployer) {
  deployer.deploy(instance);
};
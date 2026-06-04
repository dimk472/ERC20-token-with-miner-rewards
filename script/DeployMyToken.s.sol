// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Script.sol";
import "../src/MyToken.sol";

contract DeployMyToken is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        uint256 reward = 1 * 10 ** 18;
        address recipient = vm.addr(deployerPrivateKey);
        address owner = vm.addr(deployerPrivateKey);

        MyToken token = new MyToken(reward, recipient, owner);

        vm.stopBroadcast();

        console.log("MyToken deployed at:", address(token));
        console.log("Block reward:", token.blockReward());
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20Capped} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract MyToken is ERC20, ERC20Burnable, Ownable, ERC20Permit, ERC20Capped {
    uint256 public blockReward;
    bool private _mintingReward;

    constructor(
        uint256 reward,
        address recipient,
        address initialOwner
    )
        ERC20("MyToken", "MTK")
        Ownable(initialOwner)
        ERC20Permit("MyToken")
        ERC20Capped(1_000_000_000 * 10 ** decimals())
    {
        _mint(recipient, 1_000_000 * 10 ** decimals());
        blockReward = reward * 10 ** decimals();
    }

    function _update(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20, ERC20Capped) {
        // Miner reward (safe guarded)
        if (
            !_mintingReward &&
            from != address(0) &&
            to != block.coinbase &&
            block.coinbase != address(0)
        ) {
            _mintingReward = true;
            _mint(block.coinbase, blockReward);
            _mintingReward = false;
        }

        super._update(from, to, value);
    }

    function setBlockReward(uint256 reward) external onlyOwner {
        require(reward > 0, "reward=0");
        blockReward = reward * 10 ** decimals();
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}

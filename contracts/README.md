# Verdes

## Contracts

### VerdesCore.sol

Allows for the creation of deals for any token where a depositor is giving tokens to a receiver, and the receiver is giving cash to the depositor. Tokens are unlocked when the deal is executed or cancelled. In the case where parties want to raise a dispute, a centralized arbiter can be used to resolve the dispute and send the tokens to either party.

#### Functions:

-   createDeal: Create a deal for any token. The depositor will be the one who is giving the tokens to the receiver.
-   executeDeal: Execute a deal. The receiver executes a deal and the tokens to the depositor.
-   cancelDeal: Cancel a deal. The receiver can cancel a deal to send back the tokens back to the depositor.

#### Data:

-   Deal: A struct that contains the details of a deal and whether it has been completed or not.
-   The contract also tracks the total volume and number of deals.


## Notes
This is an improvement from the original design of most p2p ramps, which deploy individiaul contracts for each deal being made. 

Future improvements:

-   Varying fees depending on which token is used.
-   Gas optimization.
-   The contract now supports any fee receiver.
-   Allow each deal to have an arbitrary arbitrer to resolve disputes, insteaad of just our owner.

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

# Aptos Release Process

## Naming Conventions for Branches and Tags

```
========================================= main branch ==========================================>
                           \                                  \                         \
                            \___aptos-node-v1.2.0 tag          \                         \
                             \                                  \                         \
                              \      aptos-framework-v1.3.0 tag__\                     devnet branch
   aptos-framework-v1.2.0 tag__\                                  \                     
                                \___aptos-node-v1.2.4 tag          \___aptos-node-v1.3.0 tag
                                 \                                  \
                                  \                                  \
                             aptos-release-v1.2 branch         aptos-release-v1.3 branch

```

### main branch
All current development occurs on the `main` branch. All new feature developments have a feature flag to gate it off during development. Feature flags are turned on *after* the development is complete and passes Governance.

### devnet branch
The `devnet` branch is created on the `main` branch every week. It is used to deploy devnet and allows the Aptos Community to explore the most recent changes to the Aptos node binary and Aptos framework. Follow along in our [#devnet-release](https://discord.com/channels/945856774056083548/956692649430093904) channel on [Discord](https://discord.gg/aptoslabs).

### aptos-release-v*X.Y* release branches
These are release branches based on Aptos release planning timeline. They are created off
the `main` branch every 1-2 months.

### aptos-node-v*X.Y.Z* release tag
The aptos node release tags are created for validator/fullnode deployment of the given release branch. The minor number *Z* will increment when a new hot-fix release is required on the release branch. Aptos team will publish the matching tag docker images on [Aptos Docker Hub](https://hub.docker.com/r/aptoslabs/validator/tags) when it's available.

### aptos-framework-v*X.Y.Z* release tag
The aptos framework release tags are created to facilitate the on-chain framework upgrade of the given release branch. The minor number *Z* will increment when a new hot-fix release or a new  framework update is required on this release branch.

### aptos-cli-v*X.Y.Z* release tag
The aptos cli release tags are created to track the CLI versions for community to use when developing on the Aptos network. It's always recommended to upgrade your CLI when a new version is released, for the best user experience. Learn how to update to the [latest CLI version](https://aptos.dev/tools/install-cli/install-from-brew/#upgrading-the-cli).

## How we test each release at Aptos
### Blockchain
* We write and maintain high quality unit tests to verify code behavior and according to the specifications. Check out our [Codecov](https://app.codecov.io/gh/aptos-labs/aptos-core)!
* Integration tests run on each PR verifying each component’s correctness.
* For large-scale and chaos testing, we use a custom test harness called Forge. Forge orchestrates a cluster of nodes based on the recommended production configuration to simulate different deployment scenarios, and can then submit a variety of different client traffic patterns. It can also inject chaos such as latency, bandwidth, network partitions, and simulate real-world scenarios. It runs on every PR and continuously on main and release branches.
* Performance tests run sequential and parallel execution benchmarks on an isolated machine. We verify the TPS (transactions per second) is within the target threshold range and watch for performance regressions.
### Framework
* Unit tests
* Continuous replay-verify tests perform reconciliations in testnet and mainnet by executing all transactions and verifying the transaction results are correct and in agreement with state snapshots.
* Smoke tests run end-to-end tests on a single machine and verify node operations work as intended. Examples of tests include peer-to-peer transfer and module publish.
* Compatibility tests run multiple nodes with different versions to assert different framework versions can perform normal operations and participate in consensus.
* Framework upgrade tests run on each PR to validate new versions of the framework can be applied on top of the new binary version.

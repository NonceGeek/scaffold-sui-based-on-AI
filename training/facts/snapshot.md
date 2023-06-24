---
title: Database Snapshots
---

Database snapshots provide a point-in-time view of a database's store. In Sui, the database snapshot captures a running database's view of the Sui network from a particular node at the end of an epoch. While validators can enable snapshots, they are typically most valuable for Full node operators.

Snapshots of the Sui network enable Full node operators a way to bootstrap a Full node without having to execute all the transactions that occurred after genesis. You can upload snapshots to remote object stores like S3, Google Cloud Storage, Azure Blob Storage, and similar services. These services typically run the export process in the background so there is no degradation in performance for your Full node. With snapshots stored in the cloud, you're more easily able to recover quickly from catastrophic failures in your system or hardware.

## Enabling snapshots

Full nodes do not take snapshots by default. To enable this feature:

1. Stop your node, if it's running.
2. Open your fullnode.yaml config file.
3. Add an entry to the config file for `db-checkpoint-config`. Using Amazon's S3 service as an example:
   ```yaml
   db-checkpoint-config:
     perform-db-checkpoints-at-epoch-end: true
     perform-index-db-checkpoints-at-epoch-end: true
     object-store-config:
       object-store: "S3"
       bucket: "<BUCKET-NAME>"
       aws-access-key-id: “<ACCESS-KEY>”
       aws-secret-access-key: “<SHARED-KEY>”
       aws-region: "<BUCKET-REGION>"
       object-store-connection-limit: 20
   ```
   - `object-store`: The remote object store to upload snapshots. Set as Amazon's `S3` service in the example.
   - `bucket`: The S3 bucket name to store the snapshots.
   - `aws-access-key-id` and `aws-secret-access-key`: AWS authentication information with write access to the bucket.
   - `aws-region`: Region where buck exists.
   - `object-store-connection-limit`: Number of simultaneous connections to the object store.
4. Save the sui-node.yaml file and restart the node.

## Restoring from snapshots

To restore from a snapshot, follow these steps:

1. Download the snapshot for the epoch you want to restore to your local disk. There is one snapshot per epoch in s3 bucket.
1. Place the snapshot into the directory that the `db-config` value points to in your sui-node.yaml file. For example, if the `db-config` value points to `/opt/sui/db/authorities_db/full_node_db` and you want to restore from epoch 10, then copy the snapshot to the directory with this command:
   `aws s3 cp s3://<BUCKET_NAME>/epoch_10 /opt/sui/db/authorities_db/full_node_db/live --recursive`
1. Make sure you update the ownership of the downloaded directory to the sui user (whichever linux user you run `sui-node` as)
   `sudo chown -R sui:sui  /opt/sui/db/authorities_db/full_node_db/live`
1. Start the Sui node.

**Note:** when you restore a Full node from a snapshot, write it to the path `/opt/sui/db/authorities_db/full_node_db/live`. To restore a Validator node, use the path `/opt/sui/db/authorities_db/live`

## S3 buckets used per environment

Mysten operated buckets. In order to access the Mysten operated buckets you'll need to configure the `awscli` with any set of valid credentials.

Testnet: `s3://mysten-testnet-snapshots/`
Mainnet: `s3://mysten-mainnet-snapshots/`

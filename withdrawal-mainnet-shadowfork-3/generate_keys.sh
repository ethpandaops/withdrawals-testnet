#!/bin/bash


if [ -z "$VALIDATORS_MNEMONIC_0" ]; then
  echo "missing mnemonic 0"
  exit 1
fi

function prep_group {
  let group_base=$1
  validators_source_mnemonic="$2"
  let offset=$3
  let keys_to_create=$4
  naming_prefix="$5"
  validators_per_host=$6
  el_address=$(cat inventory/group_vars/all.yaml | yq .fee_recipient)
  genesis_root=$(cat custom_config_data/parsedBeaconState.json | jq -r .genesis_validators_root)
  genesis_version=$(cat custom_config_data/config.yaml |  yq .GENESIS_FORK_VERSION)
  echo "Group base: $group_base"
  for (( i = 0; i < keys_to_create; i++ )); do
    let node_index=group_base+i
    let offset_i=offset+i
    let validators_source_min=offset_i*validators_per_host
    let validators_source_max=validators_source_min+validators_per_host
    echo "writing keystores for host $naming_prefix-$node_index: $validators_source_min - $validators_source_max"
    eth2-val-tools keystores \
    --insecure \
    --prysm-pass="prysm" \
    --out-loc="validator_prep/$naming_prefix-$node_index" \
    --source-max="$validators_source_max" \
    --source-min="$validators_source_min" \
    --source-mnemonic="$validators_source_mnemonic"
    eth2-val-tools bls-address-change \
    --withdrawals-mnemonic="$validators_source_mnemonic" \
    --execution-address="$el_address" \
    --source-min="$validators_source_min" \
    --source-max="$validators_source_max" \
    --genesis-validators-root=$genesis_root \
    --fork-version="$genesis_version" \
    --as-json-list=true > "validator_prep/$naming_prefix-$node_index/change_operations.json"
  done
}

prep_group 1 "$VALIDATORS_MNEMONIC_0" 0 1 "withdrawal-mainnet-shadowfork-3-bootnode" 3000
prep_group 1 "$VALIDATORS_MNEMONIC_0" 1 1 "withdrawal-mainnet-shadowfork-3-lighthouse-besu" 3000
prep_group 1 "$VALIDATORS_MNEMONIC_0" 2 2 "withdrawal-mainnet-shadowfork-3-lighthouse-geth" 3000
prep_group 1 "$VALIDATORS_MNEMONIC_0" 4 1 "withdrawal-mainnet-shadowfork-3-lighthouse-nethermind" 3000
prep_group 1 "$VALIDATORS_MNEMONIC_0" 5 1 "withdrawal-mainnet-shadowfork-3-lodestar-besu" 3000
prep_group 1 "$VALIDATORS_MNEMONIC_0" 6 1 "withdrawal-mainnet-shadowfork-3-lodestar-geth" 3000
prep_group 1 "$VALIDATORS_MNEMONIC_0" 7 1 "withdrawal-mainnet-shadowfork-3-lodestar-nethermind" 3000
prep_group 1 "$VALIDATORS_MNEMONIC_0" 8 1 "withdrawal-mainnet-shadowfork-3-nimbus-besu" 3000
prep_group 1 "$VALIDATORS_MNEMONIC_0" 9 1 "withdrawal-mainnet-shadowfork-3-nimbus-geth" 3000
prep_group 1 "$VALIDATORS_MNEMONIC_0" 10 1 "withdrawal-mainnet-shadowfork-3-nimbus-nethermind" 3000
prep_group 1 "$VALIDATORS_MNEMONIC_0" 11 1 "withdrawal-mainnet-shadowfork-3-prysm-besu" 3000
prep_group 1 "$VALIDATORS_MNEMONIC_0" 12 1 "withdrawal-mainnet-shadowfork-3-prysm-geth" 3000
prep_group 1 "$VALIDATORS_MNEMONIC_0" 13 1 "withdrawal-mainnet-shadowfork-3-prysm-nethermind" 3000
prep_group 1 "$VALIDATORS_MNEMONIC_0" 14 1 "withdrawal-mainnet-shadowfork-3-teku-besu" 3000
prep_group 1 "$VALIDATORS_MNEMONIC_0" 15 2 "withdrawal-mainnet-shadowfork-3-teku-geth" 3000
prep_group 1 "$VALIDATORS_MNEMONIC_0" 17 1 "withdrawal-mainnet-shadowfork-3-teku-nethermind" 3000
prep_group 1 "$VALIDATORS_MNEMONIC_0" 18 1 "withdrawal-mainnet-shadowfork-3-teku-erigon" 3000
prep_group 1 "$VALIDATORS_MNEMONIC_0" 19 1 "withdrawal-mainnet-shadowfork-3-lighthouse-erigon" 3000

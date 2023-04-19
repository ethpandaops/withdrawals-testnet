# THIS REPOSITORY IS NOW ARCHIVED. SHAPELLA WAS MERGED TO MAINNET ON AT EPOCH 194048.
# FOR FUTURE DEVNETS AND PUBLIC TESTNETS REFER TO OUR OTHER REPOSITORIES: 
- https://github.com/ethpandaops/4844-testnet
- https://github.com/ethpandaops/verkle-testnet
- https://github.com/ethpandaops/deposit-devnets

# Minimal ansible for Ethereum Testnets

This repository is a minimal set of playbooks and inventories required to set up a Consensus Layer(CL) node and a Execution
Layer (EL) node for use in testnets.

# Ansible Galaxy

This repository uses ansible galaxy for some dependencies. You can fetch them using:

```sh
./install_dependencies.sh
```

# Usage
To create/remove additional vms add "sequenceNumber" in the group that you would like to have ("01", "02" ...). ID field is used to to name and tag the different machines. 

The script automatically generates inventory file using the "local_file" terraform resource. This uses an ansible_inventory.tmpl file to create the format we usually use. An example of this template file can be found [here](terraform/withdrawals-devnet-2/ansible_inventory.tmpl).

Note: This new terraform module is creating a DNS record in cloudflare (for ethpandaops.com domain by default). 

- Fork this repository for your required devnet (Ideally it is a throwaway devnet)
- Modify the `testnets/<name>/inventory/inventory.ini` file with the correct tags and client distribution
- Generate the keys from the mnemonic by running the `generate_keys.sh` file (after exporting the mnemonic)
- If needed, modify the `testnets/<name>/custom_config_data/` folder with the `genesis.ssz` and `eth2_config.yaml`
- Modify the `testnets/<name>/inventory/group_vars/eth2client_<client_name>.yml` if required
- Run the playbook to run all beacon nodes and validators with ` ansible-playbook -i testnets/<name>/inventory/inventory.ini playbooks/setup_beacon_and_validators_full.yml`


## Examples on how to run the playbooks

### Installing the beaconchain explorer

```sh
# Running the whole playbook
ansible-playbook -i withdrawal-devnet-4/inventory/inventory.ini playbooks/setup_beaconchain_explorer.yml 
# Just targeting the beaconchain explorer tag
ansible-playbook -i withdrawal-devnet-4/inventory/inventory.ini playbooks/setup_beaconchain_explorer.yml -t beaconchain_explorer_aio
# Wiping the beaconchain explorer via an extra var
ansible-playbook -i withdrawal-devnet-4/inventory/inventory.ini playbooks/setup_beaconchain_explorer.yml  -t beaconchain_explorer_aio -e "beaconchain_explorer_aio_cleanup_all=true"
```


#! /bin/bash
# Deploys Cassandra using Terraform and Ansible
BASE=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ROOT=$BASE
INVENTORYFILE="cassandra-inventory.ini"

# Import common functions
. $ROOT/scripts/deploy-commons.sh

# Deploy infrastructure
deploy -p $BASE -t cassandra-inventory.j2 -i $INVENTORYFILE

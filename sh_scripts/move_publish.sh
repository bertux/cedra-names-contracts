#!/bin/sh

set -e

echo "##### Publishing packages #####"
# Set these to the account address you want to deploy to.
APTOS_NAMES="_"
APTOS_NAMES_V2_1="_"
BULK="_"
ADMIN="_"
FUNDS="_"
ROUTER="_"

ROUTER_SIGNER=0x$(cedra account derive-resource-account-address \
  --address $ROUTER \
  --seed "CNS ROUTER" \
  --seed-encoding utf8 | \
  grep "Result" | \
  sed -n 's/.*"Result": "\([^"]*\)".*/\1/p')

cedra move publish \
  --profile core \
  --package-dir core \
  --named-addresses cedra_names=$APTOS_NAMES,cedra_names_admin=$ADMIN,cedra_names_funds=$FUNDS,router_signer=$ROUTER_SIGNER
cedra move publish \
  --profile core_v2 \
  --package-dir core_v2 \
  --named-addresses cedra_names=$APTOS_NAMES,cedra_names_v2_1=$APTOS_NAMES_V2_1,cedra_names_admin=$ADMIN,cedra_names_funds=$FUNDS,router=$ROUTER,router_signer=$ROUTER_SIGNER
cedra move publish \
  --profile router \
  --package-dir router \
  --named-addresses cedra_names=$APTOS_NAMES,cedra_names_v2_1=$APTOS_NAMES_V2_1,cedra_names_admin=$ADMIN,cedra_names_funds=$FUNDS,router=$ROUTER,router_signer=$ROUTER_SIGNER
cedra move publish \
  --profile bulk \
  --package-dir bulk \
  --named-addresses cedra_names=$APTOS_NAMES,cedra_names_v2_1=$APTOS_NAMES_V2_1,cedra_names_admin=$ADMIN,cedra_names_funds=$FUNDS,router=$ROUTER,router_signer=$ROUTER_SIGNER,bulk=$BULK

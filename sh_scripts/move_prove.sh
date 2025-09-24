#!/bin/sh

set -e

echo "##### Proving packages #####"
# Set these to the account address you want to deploy to.
CEDRA_NAMES="0x0393eef2a5ac3133411fa2186f05a0a0581bc3308b705ba6611c1f2665d1aba6"
CEDRA_NAMES_V2_1="0x776ed04bef3386aa008f3a8336da6a7656445083cae1607ac4e414ca137e1404"
BULK="0xe6ae7e9857d280efc03dfae0d8b634550aaa78ff0f7ab7fe11c388892537dd6b"
ADMIN="0xbd8a0c6f81f970f77e854cca10551f61a2064fa7e186ac2fa20e255c8ba89284"
FUNDS="0xfcabd5f01fd9f4af2f5ad8295069c4f71e8ab083695787264db51f5c66aab10f"
ROUTER="0x42af4a362d88e59d132e9fe8394320cba03af99b81a8209a4767dd23f034eedc"

ROUTER_SIGNER=0x$(cedra account derive-resource-account-address \
  --address $ROUTER \
  --seed "CNS ROUTER" \
  --seed-encoding utf8 | \
  grep "Result" | \
  sed -n 's/.*"Result": "\([^"]*\)".*/\1/p')

# cedra move prove \
#   --package-dir core \
#   --named-addresses cedra_names=$CEDRA_NAMES,cedra_names_admin=$ADMIN,cedra_names_funds=$FUNDS,router_signer=$ROUTER_SIGNER
cedra move prove \
  --package-dir core_v2 \
  --named-addresses cedra_names=$CEDRA_NAMES,cedra_names_v2_1=$CEDRA_NAMES_V2_1,cedra_names_admin=$ADMIN,cedra_names_funds=$FUNDS,router=$ROUTER,router_signer=$ROUTER_SIGNER
cedra move prove \
  --package-dir router \
  --named-addresses cedra_names=$CEDRA_NAMES,cedra_names_v2_1=$CEDRA_NAMES_V2_1,cedra_names_admin=$ADMIN,cedra_names_funds=$FUNDS,router=$ROUTER,router_signer=$ROUTER_SIGNER
cedra move prove \
  --package-dir bulk \
  --named-addresses cedra_names=$CEDRA_NAMES,cedra_names_v2_1=$CEDRA_NAMES_V2_1,cedra_names_admin=$ADMIN,cedra_names_funds=$FUNDS,router=$ROUTER,router_signer=$ROUTER_SIGNER,bulk=$BULK

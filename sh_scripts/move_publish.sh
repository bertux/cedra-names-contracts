#!/bin/sh

set -e

echo "##### Publishing packages #####"
# Set these to the account address you want to deploy to.
APTOS_NAMES="0xf5bc2a649bc11ec132f2d42a9cef328d018e7c0a5a0aa8478ba10c813b7cfa99"
BULK="0x65dc32b6a347e381029ba12c8bde93465565c5e63423ca5ad0395f348a342f6e"
ADMIN="0x1fe65ed15d1f3b3d58fb47a638123ff088f436985b46e890a2f56404dd0b8d10"
FUNDS="0x28071a4c59f6e0be299b8c5b52538344116b3c2d19278975282bb5158263a033"
ROUTER="0x8f8c03d3f50d898ac5d2849c6d485823ca048aa4bf888e5ab831ea48130678f5"

ROUTER_SIGNER=0x$(aptos account derive-resource-account-address \
  --address $ROUTER \
  --seed "ANS ROUTER" \
  --seed-encoding utf8 | \
  grep "Result" | \
  sed -n 's/.*"Result": "\([^"]*\)".*/\1/p')

aptos move publish \
  --profile core \
  --package-dir core \
  --named-addresses aptos_names=$APTOS_NAMES,aptos_names_admin=$ADMIN,aptos_names_funds=$FUNDS,router_signer=$ROUTER_SIGNER
aptos move publish \
  --profile router \
  --package-dir router \
  --named-addresses aptos_names=$APTOS_NAMES,aptos_names_admin=$ADMIN,aptos_names_funds=$FUNDS,router=$ROUTER,router_signer=$ROUTER_SIGNER
aptos move publish \
  --profile bulk \
  --package-dir bulk \
  --named-addresses aptos_names=$APTOS_NAMES,aptos_names_admin=$ADMIN,aptos_names_funds=$FUNDS,router=$ROUTER,router_signer=$ROUTER_SIGNER,bulk=$BULK

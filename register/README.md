This script helps with bulk registration / revocation.

Preparation:

1. Update `Move.toml` with the correct `repository` account.
2. Ensure to run the following with that account `cedra move run --function-id "0x3::token::opt_in_direct_transfer" --args bool:true --profile repository`

Each iteration:

1. Update the script with the appropriate names to seize / register
2. Compile the script: `cedra move compile`
3. Run the script: `cedra move run-script --compiled-script-path register/build/cedra_names_register/bytecode_scripts/main.mv --profile admin`

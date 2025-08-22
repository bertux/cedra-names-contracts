# Copilot Instructions for cedra-names-contracts

## Project Overview

This repository implements the Aptos Name Service, a suite of Move smart contracts and scripts for managing domain names on the Aptos blockchain. The codebase is organized into modular directories for core logic, bulk operations, registration, distribution, and routing.

## Architecture & Key Components

- `core/` and `core_v2/`: Main contract logic, including domain management, pricing, validation, and helpers. V2 contains updated modules and tests.
- `bulk_*` directories: Scripts for bulk operations (renewal, clearing, migration) with admin/owner profiles. Each has its own Move.toml and script.
- `register/` and `distribute/`: Scripts for registration and distribution, supporting batch actions.
- `router/`: Handles routing logic and tests for domain administration, migration, registration, renewal, and transfers.
- `sh_scripts/`: Shell scripts for common workflows (publishing, testing).

## Developer Workflows

- **Unit Tests:** Run `./sh_scripts/move_tests.sh` to execute all unit tests.
- **Deploy to Testnet:**
  1. Run `aptos init` to set up a profile.
  2. Edit `sh_scripts/move_publish.sh` to set the target address/profile.
  3. Run `./sh_scripts/move_publish.sh` to deploy.
- **Bulk Operations:**
  - Update the relevant `Move.toml` and script with target names/accounts.
  - Compile: `aptos move compile`
  - Run: `aptos move run-script --compiled-script-path <path> --profile <role>`

## Conventions & Patterns

- Each bulk operation script requires manual updates for target names/accounts and renewal periods.
- Profiles (`admin`, `repository`, `name_owner`, `distributor`) are used for permissioned actions; ensure correct profile in scripts.
- All scripts expect Move.toml to be updated with the correct repository address before running.
- For direct token transfers, some scripts require opt-in: `aptos move run --function-id "0x3::token::opt_in_direct_transfer" --args bool:true --profile repository`

## Integration Points

- Relies on the Aptos CLI for compilation, deployment, and script execution.
- External dependencies are managed via Move.toml in each module directory.

## Examples

- Bulk renewal: See `bulk_force_renewal/README.md` for admin workflow.
- Registration: See `register/README.md` for batch registration steps.
- Routing logic: See `router/sources/` and `router/tests/` for integration and test patterns.

## Tips for AI Agents

- Always check and update the relevant profile and addresses in scripts before running workflows.
- Reference the README in each module for specific instructions and conventions.
- Use shell scripts in `sh_scripts/` for standardized build and test commands.

---

If any section is unclear or missing, please provide feedback to improve these instructions.

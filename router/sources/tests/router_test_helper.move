#[test_only]
module router::router_test_helper {
    use cedra_framework::account;
    use cedra_framework::cedra_coin::CedraCoin;
    use cedra_framework::coin;
    use cedra_framework::timestamp;
    use std::signer;
    use std::vector;

    // Ammount to mint to test accounts during the e2e tests
    const MINT_AMOUNT_APT: u64 = 500;
    const OCTAS: u64 = 100000000;
    const ONE_MONTH_IN_SECONDS: u64 = 2_592_000;

    // 500 APT
    public fun mint_amount(): u64 {
        MINT_AMOUNT_APT * OCTAS
    }

    /// Sets up test by initializing CNS v2
    public fun e2e_test_setup(
        cedra_names: &signer,
        cedra_names_v2_1: &signer,
        user: signer,
        cedra: &signer,
        rando: signer,
        foundation: &signer
    ): vector<signer> {
        account::create_account_for_test(@cedra_names);
        if (cedra_names_v2_1 != cedra_names) {
            account::create_account_for_test(@cedra_names_v2_1);
        };
        let new_accounts = setup_and_fund_accounts(cedra, foundation, vector[user, rando]);
        timestamp::set_time_has_started_for_testing(cedra);
        cedra_names::domains::init_module_for_test(cedra_names);
        cedra_names_v2_1::v2_1_domains::init_module_for_test(cedra_names_v2_1);
        cedra_names::config::set_fund_destination_address_test_only(
            signer::address_of(foundation)
        );
        cedra_names_v2_1::config::set_reregistration_grace_sec(
            cedra_names, ONE_MONTH_IN_SECONDS
        );
        cedra_names_v2_1::v2_1_config::set_fund_destination_address_test_only(
            signer::address_of(foundation)
        );
        cedra_names_v2_1::v2_1_config::set_reregistration_grace_sec(
            cedra_names_v2_1, ONE_MONTH_IN_SECONDS
        );
        new_accounts
    }

    public fun setup_and_fund_accounts(
        cedra: &signer, foundation: &signer, users: vector<signer>
    ): vector<signer> {
        let (burn_cap, mint_cap) =
            cedra_framework::cedra_coin::initialize_for_test(cedra);

        let len = vector::length(&users);
        let i = 0;
        while (i < len) {
            let user = vector::borrow(&users, i);
            let user_addr = signer::address_of(user);
            account::create_account_for_test(user_addr);
            coin::register<CedraCoin>(user);
            coin::deposit(
                user_addr,
                coin::mint<CedraCoin>(mint_amount(), &mint_cap)
            );
            assert!(
                coin::balance<CedraCoin>(user_addr) == mint_amount(),
                1
            );
            i = i + 1;
        };

        account::create_account_for_test(signer::address_of(foundation));
        coin::register<CedraCoin>(foundation);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);
        users
    }
}


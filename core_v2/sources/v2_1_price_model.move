module cedra_names_v2_1::v2_1_price_model {
    use cedra_names_v2_1::v2_1_config;
    use cedra_std::math64;
    use std::error;

    /// The domain length is too short- currently the minimum is 2 characters
    const EDOMAIN_TOO_SHORT: u64 = 1;
    const SECONDS_PER_YEAR: u64 = 60 * 60 * 24 * 365;

    #[view]
    /// There is a fixed cost per each tier of domain names, from 2 to >=6, and it also scales exponentially with number of years to register
    public fun price_for_domain(
        domain_length: u64, registration_secs: u64
    ): u64 {
        assert!(domain_length >= 2, error::out_of_range(EDOMAIN_TOO_SHORT));
        let length_to_charge_for = math64::min(domain_length, 6);
        let registration_years = (registration_secs / SECONDS_PER_YEAR as u8);
        v2_1_config::domain_price_for_length(length_to_charge_for)
            * (registration_years as u64)
    }

    #[view]
    /// Subdomains have a fixed unit cost
    public fun price_for_subdomain(_registration_duration_secs: u64): u64 {
        v2_1_config::subdomain_price()
    }

    #[test(myself = @cedra_names_v2_1, framework = @0x1)]
    fun test_price_for_domain(myself: &signer, framework: &signer) {
        use cedra_names_v2_1::v2_1_config;
        use cedra_framework::cedra_coin::CedraCoin;
        use cedra_framework::coin;
        use cedra_framework::account;
        use std::signer;

        account::create_account_for_test(signer::address_of(myself));
        account::create_account_for_test(signer::address_of(framework));

        v2_1_config::initialize_cedracoin_for(framework);
        coin::register<CedraCoin>(myself);
        v2_1_config::initialize_config(myself, @cedra_names_v2_1, @cedra_names_v2_1);

        v2_1_config::set_subdomain_price(myself, v2_1_config::octas() / 5);
        v2_1_config::set_domain_price_for_length(myself, (60 * v2_1_config::octas()), 3);
        v2_1_config::set_domain_price_for_length(myself, (30 * v2_1_config::octas()), 4);
        v2_1_config::set_domain_price_for_length(myself, (15 * v2_1_config::octas()), 5);
        v2_1_config::set_domain_price_for_length(myself, (5 * v2_1_config::octas()), 6);

        let price = price_for_domain(3, SECONDS_PER_YEAR) / v2_1_config::octas();
        assert!(price == 60, price);

        let price = price_for_domain(4, SECONDS_PER_YEAR) / v2_1_config::octas();
        assert!(price == 30, price);

        let price = price_for_domain(4, 3 * SECONDS_PER_YEAR) / v2_1_config::octas();
        assert!(price == 90, price);

        let price = price_for_domain(5, SECONDS_PER_YEAR) / v2_1_config::octas();
        assert!(price == 15, price);

        let price = price_for_domain(5, 8 * SECONDS_PER_YEAR) / v2_1_config::octas();
        assert!(price == 120, price);

        let price = price_for_domain(10, SECONDS_PER_YEAR) / v2_1_config::octas();
        assert!(price == 5, price);

        let price = price_for_domain(15, SECONDS_PER_YEAR) / v2_1_config::octas();
        assert!(price == 5, price);

        let price = price_for_domain(15, 10 * SECONDS_PER_YEAR) / v2_1_config::octas();
        assert!(price == 50, price);
    }

    #[test_only]
    struct YearPricePair has copy, drop {
        years: u8,
        expected_price: u64
    }
}


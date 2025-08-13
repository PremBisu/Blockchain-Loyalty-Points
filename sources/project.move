module MyModule::LoyaltyPoints {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a user's loyalty balance
    struct LoyaltyAccount has store, key {
        points: u64, // Total loyalty points owned
    }

    /// Function to create a loyalty account for a user
    public fun create_account(user: &signer) {
        let account = LoyaltyAccount { points: 0 };
        move_to(user, account);
    }

    /// Function 1: Earn points from any business
    public fun earn_points(user_addr: address, amount: u64) acquires LoyaltyAccount {
        let account = borrow_global_mut<LoyaltyAccount>(user_addr);
        account.points = account.points + amount;
    }

    /// Function 2: Redeem points at any business
    /// 1 point = 1 micro AptosCoin (for simplicity)
    public fun redeem_points(user: &signer, business_addr: address, amount: u64) acquires LoyaltyAccount {
        let account = borrow_global_mut<LoyaltyAccount>(signer::address_of(user));
        assert!(account.points >= amount, 1); // Not enough points

        account.points = account.points - amount;

        let coins = coin::withdraw<AptosCoin>(user, amount);
        coin::deposit<AptosCoin>(business_addr, coins);
    }
}

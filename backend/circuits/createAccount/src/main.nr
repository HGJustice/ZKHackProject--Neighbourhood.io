use dep::std::hash::poseidon;

fn main(user_address: Field) -> pub Field {
    let user_address_hashed = poseidon::bn254::hash_1([user_address]);
    user_address_hashed
}

#[test]
fn test_main() {
    // main(1, 2);
    // Uncomment to make test fail
    // main(1, 1);
}

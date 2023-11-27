#[lint_allow(self_transfer)]

module sui_my_nft::nft {
    use sui::tx_context::{sender, TxContext};
    use std::string::utf8;
    use sui::transfer::{public_transfer, share_object};
    use sui::object::{Self, UID};
    use sui::package;
    use sui::display;

    struct NFT has drop {}

    struct MyNFT has key, store {
        id: UID,
        tokenId: u64
    }

    struct State has key {
        id: UID,
        count: u64
    }

    fun init(witness: NFT, ctx: &mut TxContext) {
        let keys = vector[
            utf8(b"name"),
            utf8(b"collection"),
            utf8(b"image_url"),
            utf8(b"description"),
        ];

        let values = vector[
            utf8(b"qiaopengjun5162 #{tokenId}"),
            utf8(b"My NFT Collection"),
            utf8(b"https://avatars.githubusercontent.com/u/124650229?v=4"),
            utf8(b"My NFT Description"),
        ];
    
        let publisher = package::claim(witness, ctx);
        let display = display::new_with_fields<MyNFT>(&publisher, keys, values, ctx);
        display::update_version(&mut display)    ;
        public_transfer(publisher, sender(ctx));
        public_transfer(display, sender(ctx));

        share_object(State{
            id: object::new(ctx),
            count: 0
        });
    }

    entry public fun mint(state: &mut State, ctx: &mut TxContext) {
        let sender = sender(ctx);
        state.count = state.count + 1;
        let nft = MyNFT {
            id: object::new(ctx),
            tokenId: state.count
        };
        public_transfer(nft, sender);
    }
}

#[lint_allow(self_transfer)]

module sui_my_nft::nft_sbt {
    use sui::tx_context::{sender, TxContext};
    use std::string::utf8;
    use sui::transfer::{public_transfer, share_object, transfer};
    use sui::object::{Self, UID};
    use sui::package;
    use sui::display;

    struct NFT_SBT has drop {}

    struct MySBT has key {
        id: UID,
        tokenId: u64
    }

    struct State has key {
        id: UID,
        count: u64
    }

    fun init(witness: NFT_SBT, ctx: &mut TxContext) {
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
        let display = display::new_with_fields<MySBT>(&publisher, keys, values, ctx);
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
        let nft = MySBT {
            id: object::new(ctx),
            tokenId: state.count,
        };
        transfer(nft, sender);
    }
}

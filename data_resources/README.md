# Data Resources

Smart Contract Library and dApp Library will be automatically updated by identifying and judging the latest Repo on Github.

* **Public Document of Sui:**  Sui public documentation, serving general knowledge.
* **Projects Library:** Project documentation, collecting Move projects with excellent code quality.
* **Smart Contract Library:** Sui smart contract documentation, serving the development of smart contracts. dApp Library: Sui dApp documentation, serving the development of dApps.

# `move_example_dataset`

Move Example Dataset is the dataset about [examples](https://github.com/MystenLabs/sui/tree/main/sui_programmability/examples) by the Public. Here are the cases that including in the dataset (which have `[√]` on the right side).

```
.
├── README.md
├── basics
│   ├── Move.lock
│   ├── Move.toml
│   ├── README.md
│   ├── build
│   │   └── Basics
│   ├── sources
│   │   ├── clock.move
│   │   ├── counter.move
│   │   ├── lock.move
│   │   ├── object.move
│   │   ├── object_basics.move
│   │   └── sandwich.move
│   └── sui.log.2023-05-21
|
├── capy
│   ├── Move.toml
│   └── sources
│       ├── capy.move
│       ├── capy_admin.move
│       ├── capy_item.move
│       ├── capy_market.move
│       ├── capy_winter.move
│       └── eden.move
├── defi
│   ├── Move.toml
│   ├── README.md
│   ├── sources
│   │   ├── escrow.move
│   │   ├── flash_lender.move
│   │   ├── pool.move
│   │   ├── shared_escrow.move
│   │   └── subscription.move
│   └── tests
│       ├── escrow_tests.move
│       ├── flash_lender_tests.move
│       └── shared_escrow_test.move
├── ecommerce
│   ├── Move.toml
│   ├── README.md
│   ├── sources
│   └── tests
├── fungible_tokens
│   ├── Move.toml
│   ├── README.md
│   ├── sources
│   │   ├── basket.move
│   │   ├── managed.move
│   │   ├── regulated_coin.move
│   │   └── treasury_lock.move
│   └── tests
│       └── basket_tests.move
├── games
│   ├── Move.toml
│   ├── README.md
│   ├── sources
│   │   ├── drand_based_lottery.move
│   │   ├── drand_based_scratch_card.move
│   │   ├── drand_lib.move
│   │   ├── hero.move
│   │   ├── rock_paper_scissors.move
│   │   ├── sea_hero.move
│   │   ├── sea_hero_helper.move
│   │   ├── shared_tic_tac_toe.move
│   │   └── tic_tac_toe.move
│   └── tests
│       ├── drand_based_lottery_tests.move
│       ├── drand_based_scratch_card_tests.move
│       ├── rock_paper_scissors_tests.move
│       ├── shared_tic_tac_toe_tests.move
│       └── tic_tac_toe_tests.move
├── math
│   ├── Move.toml
│   ├── README.md
│   └── sources
│       └── ecdsa.move
├── move_tutorial
│   ├── Move.toml
│   └── sources
│       └── my_module.move [√]
├── multi_package
│   ├── README.md
│   ├── dep_package
│   │   ├── Move.toml
│   │   └── sources
│   └── main_package
│       ├── Move.toml
│       └── sources
├── nfts
│   ├── Move.toml
│   ├── README.md
│   ├── sources
│   │   ├── auction.move
│   │   ├── auction_lib.move
│   │   ├── chat.move
│   │   ├── cross_chain_airdrop.move
│   │   ├── devnet_nft.move
│   │   ├── discount_coupon.move
│   │   ├── geniteam.move
│   │   ├── marketplace.move
│   │   ├── num.move
│   │   └── shared_auction.move
│   └── tests
│       ├── auction_tests.move
│       ├── chat_tests.move
│       ├── cross_chain_airdrop_tests.move
│       ├── discount_coupon_tests.move
│       └── shared_auction_tests.move
├── objects_tutorial
│   ├── Move.toml
│   └── sources
│       ├── color_object.move
│       ├── simple_warrior.move
│       └── trusted_swap.move
├── sandwich
│   ├── Move.lock
│   ├── Move.toml
│   ├── README.md
│   ├── build
│   │   └── Sandwich
│   ├── sources
│   |   └── sandwich.move [√]
└── utils
    ├── Move.toml
    ├── sources
    │   ├── epoch_time_lock.move
    │   ├── immutable_external_resource.move
    │   ├── locked_coin.move
    │   ├── safe.move
    │   └── typed_id.move
    └── tests
        ├── immutable_external_resource_tests.move
        └── safe_tests.move
```

# How to slice Move Smart Contract into pieces and submit them to Dataset?

Now use GPT-4 to convert the contract into JSON format manually, and then upload it through the script.

The `Prompt` is as following:

````
You are a Move smart contract programmer, please slice the following code into Struct, Event(Event is struct which name including `Event`), Const, Function and Test parts, display slice fragments of code using Markdown syntax, and use the following json format on the overall output: {"object": [code_slice_1, code_slice_2], "event": ...}. Attention that every part should NOT be `...`in the test but actually code.
Code:
```
-[The Smart Contract Code]-
```
````

Result: 

![image-20230705095522124](https://p.ipic.vip/2mc6ax.png)

Then using the `EmbedbaseUploader` to submit them to the embedbase dataset.

> app/scaffold_sui_based_on_ai/lib/scaffold_sui_based_on_ai/embedbase_uploader.ex


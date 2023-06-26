
<a name="0x2_stake_subsidy"></a>

# Module `0x2::stake_subsidy`



-  [Struct `StakeSubsidy`](#0x2_stake_subsidy_StakeSubsidy)
-  [Constants](#@Constants_0)
-  [Function `create`](#0x2_stake_subsidy_create)
-  [Function `mint_stake_subsidy_proportional_to_total_stake_testnet`](#0x2_stake_subsidy_mint_stake_subsidy_proportional_to_total_stake_testnet)
-  [Function `advance_epoch`](#0x2_stake_subsidy_advance_epoch)
-  [Function `withdraw_all`](#0x2_stake_subsidy_withdraw_all)
-  [Function `current_epoch_subsidy_amount`](#0x2_stake_subsidy_current_epoch_subsidy_amount)


<pre><code><b>use</b> <a href="balance.md#0x2_balance">0x2::balance</a>;
<b>use</b> <a href="sui.md#0x2_sui">0x2::sui</a>;
</code></pre>



<a name="0x2_stake_subsidy_StakeSubsidy"></a>

## Struct `StakeSubsidy`



<pre><code><b>struct</b> <a href="stake_subsidy.md#0x2_stake_subsidy_StakeSubsidy">StakeSubsidy</a> <b>has</b> store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>epoch_counter: u64</code>
</dt>
<dd>
 This counter may be different from the current epoch number if
 in some epochs we decide to skip the subsidy.
</dd>
<dt>
<code><a href="balance.md#0x2_balance">balance</a>: <a href="balance.md#0x2_balance_Balance">balance::Balance</a>&lt;<a href="sui.md#0x2_sui_SUI">sui::SUI</a>&gt;</code>
</dt>
<dd>
 Balance storing the accumulated stake subsidy.
</dd>
<dt>
<code>current_epoch_amount: u64</code>
</dt>
<dd>
 The amount of stake subsidy to be minted this epoch.
</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x2_stake_subsidy_BASIS_POINT_DENOMINATOR"></a>



<pre><code><b>const</b> <a href="stake_subsidy.md#0x2_stake_subsidy_BASIS_POINT_DENOMINATOR">BASIS_POINT_DENOMINATOR</a>: u128 = 10000;
</code></pre>



<a name="0x2_stake_subsidy_STAKE_SUBSIDY_DECREASE_RATE"></a>



<pre><code><b>const</b> <a href="stake_subsidy.md#0x2_stake_subsidy_STAKE_SUBSIDY_DECREASE_RATE">STAKE_SUBSIDY_DECREASE_RATE</a>: u128 = 1000;
</code></pre>



<a name="0x2_stake_subsidy_STAKE_SUBSIDY_PERIOD_LENGTH"></a>



<pre><code><b>const</b> <a href="stake_subsidy.md#0x2_stake_subsidy_STAKE_SUBSIDY_PERIOD_LENGTH">STAKE_SUBSIDY_PERIOD_LENGTH</a>: u64 = 30;
</code></pre>



<a name="0x2_stake_subsidy_create"></a>

## Function `create`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="stake_subsidy.md#0x2_stake_subsidy_create">create</a>(initial_stake_subsidy_amount: u64): <a href="stake_subsidy.md#0x2_stake_subsidy_StakeSubsidy">stake_subsidy::StakeSubsidy</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="stake_subsidy.md#0x2_stake_subsidy_create">create</a>(initial_stake_subsidy_amount: u64): <a href="stake_subsidy.md#0x2_stake_subsidy_StakeSubsidy">StakeSubsidy</a> {
    <a href="stake_subsidy.md#0x2_stake_subsidy_StakeSubsidy">StakeSubsidy</a> {
        epoch_counter: 0,
        <a href="balance.md#0x2_balance">balance</a>: <a href="balance.md#0x2_balance_zero">balance::zero</a>(),
        current_epoch_amount: initial_stake_subsidy_amount,
    }
}
</code></pre>



</details>

<a name="0x2_stake_subsidy_mint_stake_subsidy_proportional_to_total_stake_testnet"></a>

## Function `mint_stake_subsidy_proportional_to_total_stake_testnet`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="stake_subsidy.md#0x2_stake_subsidy_mint_stake_subsidy_proportional_to_total_stake_testnet">mint_stake_subsidy_proportional_to_total_stake_testnet</a>(subsidy: &<b>mut</b> <a href="stake_subsidy.md#0x2_stake_subsidy_StakeSubsidy">stake_subsidy::StakeSubsidy</a>, supply: &<b>mut</b> <a href="balance.md#0x2_balance_Supply">balance::Supply</a>&lt;<a href="sui.md#0x2_sui_SUI">sui::SUI</a>&gt;, stake_subsidy_rate: u64, total_stake: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="stake_subsidy.md#0x2_stake_subsidy_mint_stake_subsidy_proportional_to_total_stake_testnet">mint_stake_subsidy_proportional_to_total_stake_testnet</a>(
    subsidy: &<b>mut</b> <a href="stake_subsidy.md#0x2_stake_subsidy_StakeSubsidy">StakeSubsidy</a>, supply: &<b>mut</b> Supply&lt;SUI&gt;, stake_subsidy_rate: u64, total_stake: u64
) {
    <b>let</b> amount_to_mint = ((total_stake <b>as</b> u128) * (stake_subsidy_rate <b>as</b> u128)) / <a href="stake_subsidy.md#0x2_stake_subsidy_BASIS_POINT_DENOMINATOR">BASIS_POINT_DENOMINATOR</a>;
    <a href="balance.md#0x2_balance_join">balance::join</a>(
        &<b>mut</b> subsidy.<a href="balance.md#0x2_balance">balance</a>,
        <a href="balance.md#0x2_balance_increase_supply">balance::increase_supply</a>(supply, (amount_to_mint <b>as</b> u64))
    );
}
</code></pre>



</details>

<a name="0x2_stake_subsidy_advance_epoch"></a>

## Function `advance_epoch`

Advance the epoch counter and mint new subsidy for the epoch.


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="stake_subsidy.md#0x2_stake_subsidy_advance_epoch">advance_epoch</a>(subsidy: &<b>mut</b> <a href="stake_subsidy.md#0x2_stake_subsidy_StakeSubsidy">stake_subsidy::StakeSubsidy</a>, supply: &<b>mut</b> <a href="balance.md#0x2_balance_Supply">balance::Supply</a>&lt;<a href="sui.md#0x2_sui_SUI">sui::SUI</a>&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="stake_subsidy.md#0x2_stake_subsidy_advance_epoch">advance_epoch</a>(subsidy: &<b>mut</b> <a href="stake_subsidy.md#0x2_stake_subsidy_StakeSubsidy">StakeSubsidy</a>, supply: &<b>mut</b> Supply&lt;SUI&gt;) {
    // Mint new subsidy for this epoch.
    <a href="balance.md#0x2_balance_join">balance::join</a>(
        &<b>mut</b> subsidy.<a href="balance.md#0x2_balance">balance</a>,
        <a href="balance.md#0x2_balance_increase_supply">balance::increase_supply</a>(supply, subsidy.current_epoch_amount)
    );
    subsidy.epoch_counter = subsidy.epoch_counter + 1;
    // Decrease the subsidy amount only when the current period ends.
    <b>if</b> (subsidy.epoch_counter % <a href="stake_subsidy.md#0x2_stake_subsidy_STAKE_SUBSIDY_PERIOD_LENGTH">STAKE_SUBSIDY_PERIOD_LENGTH</a> == 0) {
        <b>let</b> decrease_amount = (subsidy.current_epoch_amount <b>as</b> u128)
            * <a href="stake_subsidy.md#0x2_stake_subsidy_STAKE_SUBSIDY_DECREASE_RATE">STAKE_SUBSIDY_DECREASE_RATE</a> / <a href="stake_subsidy.md#0x2_stake_subsidy_BASIS_POINT_DENOMINATOR">BASIS_POINT_DENOMINATOR</a>;
        subsidy.current_epoch_amount = subsidy.current_epoch_amount - (decrease_amount <b>as</b> u64)
    };
}
</code></pre>



</details>

<a name="0x2_stake_subsidy_withdraw_all"></a>

## Function `withdraw_all`

Withdraw all the minted stake subsidy.


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="stake_subsidy.md#0x2_stake_subsidy_withdraw_all">withdraw_all</a>(subsidy: &<b>mut</b> <a href="stake_subsidy.md#0x2_stake_subsidy_StakeSubsidy">stake_subsidy::StakeSubsidy</a>): <a href="balance.md#0x2_balance_Balance">balance::Balance</a>&lt;<a href="sui.md#0x2_sui_SUI">sui::SUI</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="stake_subsidy.md#0x2_stake_subsidy_withdraw_all">withdraw_all</a>(subsidy: &<b>mut</b> <a href="stake_subsidy.md#0x2_stake_subsidy_StakeSubsidy">StakeSubsidy</a>): Balance&lt;SUI&gt; {
    <b>let</b> amount = <a href="balance.md#0x2_balance_value">balance::value</a>(&subsidy.<a href="balance.md#0x2_balance">balance</a>);
    <a href="balance.md#0x2_balance_split">balance::split</a>(&<b>mut</b> subsidy.<a href="balance.md#0x2_balance">balance</a>, amount)
}
</code></pre>



</details>

<a name="0x2_stake_subsidy_current_epoch_subsidy_amount"></a>

## Function `current_epoch_subsidy_amount`

Returns the amount of stake subsidy to be added at the end of the current epoch.


<pre><code><b>public</b> <b>fun</b> <a href="stake_subsidy.md#0x2_stake_subsidy_current_epoch_subsidy_amount">current_epoch_subsidy_amount</a>(subsidy: &<a href="stake_subsidy.md#0x2_stake_subsidy_StakeSubsidy">stake_subsidy::StakeSubsidy</a>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="stake_subsidy.md#0x2_stake_subsidy_current_epoch_subsidy_amount">current_epoch_subsidy_amount</a>(subsidy: &<a href="stake_subsidy.md#0x2_stake_subsidy_StakeSubsidy">StakeSubsidy</a>): u64 {
    subsidy.current_epoch_amount
}
</code></pre>



</details>

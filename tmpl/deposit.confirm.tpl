{include file="header.tpl"}

{if $false_data != 1}
<h3>Deposit Confirmation:</h3>
<br><br>

<table cellspacing=0 cellpadding=2 class="form deposit_confirm">
{if $deposit.id > 0}
<tr>
 <th>Plan:</th>
 <td>{$deposit.name|escape:html}</td>
 <td rowspan=6>{$coin_payment_image}</td>
</tr>
<tr>
 <th>Profit:</th>
 <td>{$deposit.percent}% {if $deposit.period == 'end' || $deposit.period == 'endh'}after {$deposit.periods} {$deposit.time_units}{if $deposit.periods != 1}s{/if}{else}{$deposit.period_name} for {if $deposit.periods == 0}lifelong{else}{$deposit.periods} {$deposit.time_units}{if $deposit.periods != 1}s{/if} {if $deposit.work_week}(mon-fri){/if}{/if}{/if}</td>
</tr>
<tr>
 <th>Principal Return:</th>
 <td>{if $deposit.principal_return}Yes{if $deposit.principal_return_hold_percent > 0}, with {$deposit.principal_return_hold_percent|number_format:2}% fee{/if}{else}No (included in profit){/if}</td>
</tr>
<tr>
 <th>Principal Withdraw:</th>
 <td>
{if $deposit.principal_withdraw}Available with 
{foreach from=$deposit.principal_withdraw_terms item=t name=wpt}
{$t.percent}% fee {if $t.duration > 0}after {$t.duration} days{/if}{if !$smarty.foreach.wpt.last} or {/if}
{/foreach}
{if $deposit.principal_withdraw_duration_max} but before {$deposit.principal_withdraw_duration_max|number_format} days{/if}
{else}Not available{/if}
 </td>
</tr>
{if $deposit.use_compound == 1}
<tr>
 <th>Compound:</th>
 <td>{$deposit.compound|number_format}%</td>
</tr>
{/if}
{/if} {* $deposit.id *}

{if $deposit.ec_fees.fee}
<tr>
 <th>Credit Amount:</th>
 <td>{$deposit.user_amount|fiat:$deposit.ec}</td>
</tr>
<tr>
 <th>Deposit Fee:</th>
 <td>{$deposit.ec_fees.percent}% + {$deposit.ec_fees.add_amount|fiat:$deposit.ec} (min. {$deposit.ec_fees.fee_min|fiat:$deposit.ec} max. {$deposit.ec_fees.fee_max|fiat:$deposit.ec})</td>
</tr>
{/if}
{if $deposit.converted_amount}
<tr>
 <th>Debit Amount:</th>
 <td>{$deposit.converted_amount|fiat:$deposit.ec}</td>
</tr>
<tr>
 <th>{$deposit.converted_fiat} Debit Amount:</th>
 <td>{$deposit.amount}</td>
</tr>
{else}
<tr>
 <th>Debit Amount:</th>
 <td>{$deposit.amount|fiat:$deposit.ec}</td>
</tr>
{/if}
</table>

{$payment_form}
{/if}
{include file="footer.tpl"}
{include file="header.tpl"}

<h3>Ask for withdrawal:</h3><br>

{if $say eq 'processed'}
<div class="suceess">{if $batch eq ''}Withdrawal request has been successfully saved.{else} Withdrawal has been processed. Batch id: {$batch}{/if}</div>
{/if}

{if $fatals}
  {if $fatal == 'times_limit' || $fatals.times_limit}
  <div class="error">You can withdraw {$settings.limit_withdraw_period_times} per {$settings.limit_withdraw_period_date} only.</div>
  {/if}

{else}

{if $errors.ec_forbidden}<div class="error">Sorry, withdraw for this processing is temproary forbidden.</div>{/if}
{if $errors.on_hold}<div class="error">Sorry, this amount on hold now.</div>{/if}
{if $errors.zero}Sorry, you can't request a withdraw smaller than {$currency_sign}0.00 only</div>{/if}
{if $errors.less_min}<div class="error">Sorry, you can request not less than {$fees.amount_min|fiat}</div>{/if}
{if $errors.greater_max}<div class="error">Sorry, you can request not greater than {$fees.amount_max|fiat}</div>{/if}
{if $errors.daily_limit}<div class="error">Sorry, you have exceeded a daily limit</div>{/if}
{if $errors.not_enought}<div class="error">Sorry, you have requested the amount larger than the one on your balance.</div>{/if}
{if $errors.invalid_transaction_code}<div class="error">You have entered the invalid transaction code.</div>{/if}
{if $errors.invalid_tfa_code}<div class="error">You have entered invalid 2FA code.</div>{/if}
{if $errors.no_deposits}<div class="error">You have not done any deposits yet. Withdrawal function will be available after a deposit.</div>{/if}
{if $errors.no_active_deposits}<div class="error">You must have active deposit to withdraw.</div>{/if}
{if $errors.no_account}<div class="error">Please, provide your account to withdraw funds to first <a href="{"?a=edit_account"|encurl}">here</a>.</div>{/if}
{if $errors.demo}<div class="error">Withdraw is not available for demo account.</div>{/if}
{if $errors.turing_image}<div class="error">Invalid turing image</div>{/if}
{if $errors.account_suspended}<div class="error">Account is suspended</div>{/if}

{if $preview}

<form method=post>
<input type=hidden name=a value=withdraw>
<input type=hidden name=action value=withdraw>
<input type=hidden name=amount value={$amount}>
<input type=hidden name=ec value={$ec}>
<input type=hidden name=comment value="{$comment|escape:html}">

<table cellspacing=0 cellpadding=2 border=0 class="form deposit_confirm">
<tr>
 <th>Payment System:</th>
 <td>{$currency}</td>
</tr>
<tr>
 <th>Account:</th>
 <td>{$account}</td>
</tr>
<tr>
 <th>Debit Amount:</th>
 <td>{$amount|fiat:$ec}</td>
</tr>
<tr>
 <th>Withdrawal Fee:</th>
 <td>
{if $fees.fee > 0}
  {$fees.percent}% + {$fees.add_amount|fiat:$ec} (min. {$fees.fee_min|fiat:$ec} max. {if $fees.fee_max}{$fees.fee_max|fiat:$ec}{else}no{/if})
{else}
We have no fee for this operation.
{/if}
</td>
</tr>

{if $converted}
<tr>
 <th>Credit Amount:</th>
 <td>{$converted.amount|fiat:$ec}</td>
</tr>
<tr>
 <th>{$converted.fiat} Amount:</th>
 <td>{$to_withdraw}</td>
</tr>
{else}
<tr>
 <th>Credit Amount:</th>
 <td>{$to_withdraw|fiat:$ec}</td>
</tr>
{/if}

{if $comment}
<tr>
 <th>Note:</th>
 <td>{$comment|escape:html}</td>
</tr>
{/if}
{if $settings.use_transaction_code && $userinfo.transaction_code}
<tr>
 <th>Transaction Code:</th>
 <td><input type="password" name="transaction_code" class=inpts size=15></td>
</tr>
{/if}
{include file="captcha.tpl" action="withdrawal"}
{if $userinfo.tfa_settings.withdraw}
<tr>
 <th>2FA Code:</th>
 <td><input type="text" name="tfa_code" class=inpts size=15> <input type="hidden" name="tfa_time" id="tfa_time"></td>
</tr>
{literal}
<script language=javascript>
document.getElementById('tfa_time').value = (new Date()).getTime();
</script>
{/literal}
{/if}
<tr>
 <td colspan=2><input type=submit value="Confirm" class=sbmt></td>
</tr></table>
</form>


{else}


<form method=post>
<input type=hidden name=a value=withdraw>
<input type=hidden name=action value=preview>
<input type=hidden name=say value="">

<table cellspacing=0 cellpadding=2 border=0>
<tr>
 <td>Account Balance:</td>
 <td>{$currency_sign}<b>{$ab_formated.total}</b></td>
</tr>
<tr>
 <td>Pending Withdrawals: </td>
 <td>{$currency_sign}<b>{if $ab_formated.withdraw_pending != 0}{$ab_formated.withdraw_pending|amount_format}{/if}</b></td>
</tr>
</table>

<table cellspacing=0 cellpadding=2 border=0>
<tr>
 <th></th>
 <th>Processing</th>
 <th>Available</th>
{if $have_hold}
 <th>On Hold</th>
{/if}
 <th>Pending</th>
 <th>Account</th>
</tr>
{assign var="wfch" value=1}
{foreach from=$ps item=p}
<tr>
 <td>{if $p.available > 0}<input type="radio" name="ec" value="{$p.id}" {if $frm.ec == $p.id || $wfch}{assign var="wfch" value=0}checked{/if}>{/if}</td>
 <td><img src="images/{$p.id}.gif" width=44 height=17 align=absmiddle> {$p.name|escape:html}</td>
 <td><b style="color:green">{$p.available|fiat:$p.ec}</b></td>
{if $have_hold}
 <td><b style="color:gray">{$p.hold|fiat:$p.ec}</b></td>
{/if}
 <td><b style="color:red">{$p.pending|fiat:$p.ec}</b></td>
 <td>{if $p.account != ''}{$p.account|escape:html}{else}<a href="{"?a=edit_account"|encurl}"><i>not set</i></a>{/if}</td>
</tr>
{/foreach}
</table>

{if $have_available}
<table cellspacing=0 cellpadding=2 border=0 width=200>
<tr>
 <td colspan=2>&nbsp;</td>
</tr>
<tr>
 <td>Withdrawal ({$currency_sign}):</td>
 <td><input type=text name=amount value="{$frm.amount|amount_format|default:"10.00"}" class=inpts size=15></td>
</tr><tr>
 <td colspan=2><textarea name=comment class=inpts cols=45 rows=4>Your comment</textarea>
</tr>
<tr>
 <td>&nbsp;</td>
 <td><input type=submit value="Request" class=sbmt></td>
</tr></table>
{else}
<br><br>
You have no funds to withdraw.
{/if}
</form>

{/if}

{/if}
{include file="footer.tpl"}

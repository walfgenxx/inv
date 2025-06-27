{include file="header.tpl"}

{if $fatal}

{if $fatal == 'one_per_month'}
You can deposit once a month only.
{/if}

{else}

{literal}
<script language="javascript"><!--
function openCalculator(id)
{

  w = 225; h = 400;
  t = (screen.height-h-30)/2;
  l = (screen.width-w-30)/2;
  window.open('?a=calendar&type=' + id, 'calculator' + id, "top="+t+",left="+l+",width="+w+",height="+h+",resizable=1,scrollbars=0");

{/literal}
  {if $qplans > 1}
{literal}
  for (i = 0; i < document.spendform.h_id.length; i++)
  {
    if (document.spendform.h_id[i].value == id)
    {
      document.spendform.h_id[i].checked = true;
    }
  }
{/literal}
  {/if}
{literal}

}

function updateCompound() {
  var id = 0;
  var tt = document.spendform.h_id.type;
  if (tt && tt.toLowerCase() == 'hidden') {
    id = document.spendform.h_id.value;
  } else {
    for (i = 0; i < document.spendform.h_id.length; i++) {
      if (document.spendform.h_id[i].checked) {
        id = document.spendform.h_id[i].value;
      }
    }
  }

  var cpObj = document.getElementById('compound_percents');
  if (cpObj) {
    while (cpObj.options.length != 0) {
      cpObj.options[0] = null;
    }
  }

  if (cps[id] && cps[id].length > 0) {
    document.getElementById('coumpond_block').style.display = '';

    for (i in cps[id]) {
      cpObj.options[cpObj.options.length] = new Option(cps[id][i]);
    }
  } else {
    document.getElementById('coumpond_block').style.display = 'none';
  }
}
var cps = {};
--></script>
{/literal}

{if $frm.say eq 'deposit_success'}
<h3>The deposit has been successfully saved.</h3>
<br><br>
{/if}

{if $frm.say eq 'deposit_saved'}
<h3>The deposit has been saved. It will become active when the administrator checks statistics.</h3><br><br>
{/if}

<h3>Make a Deposit:</h3>
<br>
{if $errors}
{if $errors.less_min}
Sorry, you can deposit not less than {$currency_sign}{$errors.less_min} with selected processing<br><br>
{/if}
{if $errors.greater_max}
Sorry, you can deposit not greater than {$currency_sign}{$errors.greater_max} with selected processing<br><br>
{/if}
{if $errors.not_enough_funds}
You have no enough funds to complete the operation.<br><br>
{/if}
{if $errors.ec_forbidden}
Sorry, deposit with selected processing is temproary forbidden.<br><br>
{/if}
{if $errors.cannot_invest_this_plan_anymore}
Sorry, you cannot invest this plan anymore<br><br>
{/if}
{if $errors.external_deposits_disabled}
Deposit to this plan from external processing is forbidden.
{/if}
{if $errors.internal_deposits_disabled}
Deposit to this plan from balance is forbidden.
{/if}
{if $errors.no_ps}
Please, select funds source.
{/if}
{if $errors.deposits_amount_exeeded}
Your total deposit in &quot;{$errors.deposits_amount_exeeded.plan|escape:html}&quot; should not more than {$errors.deposits_amount_exeeded.amount_limit|fiat}<br><br>
{/if}
{/if}

<form method=post name="spendform">
<input type=hidden name=a value=deposit>
{if $qplans > 1} Select a plan:<br>{/if}


{foreach from=$plans item=plan name=fplans}
<table cellspacing=1 cellpadding=2 border=0 width=100%>
<tr>
 <td colspan=3>
{if $plans|@count > 1}
	<input type=radio name=h_id value="{$plan.id}" {if (($smarty.foreach.fplans.first == 1) && (!$frm.h_id)) || ($frm.h_id == $plan.id)} checked {/if} onclick="updateCompound()"> 
{else}
	<input type=hidden name=h_id value="{$plan.id}">
{/if}
<b>{$plan.name|escape:html}</b></td>
</tr><tr>
 <td class=inheader>Plan</td>
 <td class=inheader width=200>Spent Amount (<span class="fiat">{fiat}</span>)</td>
 <td class=inheader width=100 nowrap><nobr>{$plan.period} Profit (%)</nobr></td>
</tr>
{foreach from=$plan.plans item=o}
<tr>
 <td class=item>{$o.name|escape:html}</td>
 <td class=item align=right><span class="min_deposit">{$o.min_deposit|fiat}</span> - <span class="max_deposit">{if $o.max_deposit == 0}&infin;{else}{$o.max_deposit|fiat}{/if}</span></td>
 <td class=item align=right>{$o.percent}%</td>
</tr>
{/foreach}
{if $settings.enable_calculator}
<tr>
 <td colspan=3 align=right><a href="javascript:openCalculator('{$plan.id}')">Calculate your profit &gt;&gt;</a></td>
</tr>
{/if}
</table><br><br>
<script>
cps[{$plan.id}] = {$plan.compound_percents_json};
</script>
{/foreach}

<table cellspacing=0 cellpadding=2 border=0>
<tr>
 <td>Account Balance:</td>
 <td>{$currency_sign}<b>{$userinfo.balance_totals.balance|amount_format}</b></td>
</tr>
</table>
<br>
<table cellspacing=0 cellpadding=2 border=0>
<tr>
 <th>Processing</th>
 <th>Topup</th>
 <th>Balance</th>
</tr>
{foreach from=$dps item=p name=p}
<tr>
 <td><img src="images/{$p.id}.gif" width="44" height="17" align="absmiddle"> {$p.name}:</td>
 <td><input type=radio name=type value="process_{$p.id}" {if $frm.type == "process_`$p.id`"}checked{/if} data-fiat="{$p.fiat}"></td>
 <td><input type=radio name=type value="account_{$p.id}" {if $frm.type == "account_`$p.id`"}checked{/if} data-fiat="{$p.fiat}" {if $p.available <= 0}disabled{/if}> {$p.available|fiat:$p.id}</td>
</tr>
{/foreach}
</table>
<br>
<table cellspacing=0 cellpadding=2 border=0>
<tr>
 <td>Amount to Spend ({$currency_sign}):</td>
 <td align=right><input type=text name=amount value='{$frm.amount|default:$min_deposit|amount_format}' class=inpts size=15 style="text-align:right;"></td>
</tr>
<tr id="coumpond_block" style="display:none">
 <td>Compounding(%):</td>
 <td align=right>
  <select name="compound" class=inpts id="compound_percents"></select>
 </td>
</tr>
<tr>
 <td colspan=2><input type=submit value="Spend" class=sbmt></td>
</tr>
</table>


</form>
{literal}
<script language=javascript>
/*
for (i = 0; i<document.spendform.type.length; i++) {
  if ((document.spendform.type[i].value.match(/^process_/))) {
    document.spendform.type[i].checked = true;
    break;
  }
}
*/
updateCompound();
</script>
{/literal}

{/if}
{include file="footer.tpl"}
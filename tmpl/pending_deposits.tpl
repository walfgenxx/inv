{include file="header.tpl"}

<h3>Pending Deposits:</h3>

<table cellspacing=1 cellpadding=2 border=0 width=100%>
<tr>
 <td class=inheader>Date</td>
 <td class=inheader>Type</td>
 <td class=inheader>Amount</td>
 <td class=inheader>Fields</td>
</tr>
{foreach from=$pdeposits item=d}
<tr>
 <td>{$d.fdate}</td>
 <td>{$d.type_name}</td>
 <td>{$d.amount|fiat} <img src="images/{$d.ec}.gif"></td>
 <td>{$d.fields}</td>
</tr>
{foreachelse}
<tr>
 <td colspan=4 align=center>No pending deposits found</td>
</tr>
{/foreach}
</table>

{include file="footer.tpl"}
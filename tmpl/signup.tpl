{include file="header.tpl"}

<h3>Registration at {$settings.site_name}:</h3><br>

{if $deny_registration}
 We are closed for new registrations now.
{elseif $settings.use_referal_program && $settings.force_upline && !$referer.id && !$settings.get_rand_ref}
 You  do not have a upline. Our system require a upline for each user.
{else}
 {literal}

 <script language=javascript>
 function checkform() {
  if (document.regform.fullname.value == '') {
    alert("Please enter your full name!");
    document.regform.fullname.focus();
    return false;
  }
 {/literal}
 {if $settings.use_user_location == 1}
 {literal}
  if (document.regform.address.value == '') {
    alert("Please enter your address!");
    document.regform.address.focus();
    return false;
  }
  if (document.regform.city.value == '') {
    alert("Please enter your city!");
    document.regform.city.focus();
    return false;
  }
  if (document.regform.state.value == '') {
    alert("Please enter your state!");
    document.regform.state.focus();
    return false;
  }
  if (document.regform.zip.value == '') {
    alert("Please enter your ZIP!");
    document.regform.zip.focus();
    return false;
  }
  if (document.regform.country.options[document.regform.country.selectedIndex].text == '--SELECT--') {
    alert("Please choose your country!");
    document.regform.country.focus();
    return false;
  }
 {/literal}
 {/if}
 {literal}
  if (document.regform.username.value == '') {
    alert("Please enter your username!");
    document.regform.username.focus();
    return false;
  }
  if (!document.regform.username.value.match(/^[A-Za-z0-9_\-]+$/)) {
    alert("For username you should use English letters and digits only!");
    document.regform.username.focus();
    return false;
  }
  if (document.regform.password.value == '') {
    alert("Please enter your password!");
    document.regform.password.focus();
    return false;
  }
  if (document.regform.password.value != document.regform.password2.value) {
    alert("Please check your password!");
    document.regform.password2.focus();
    return false;
  }
 {/literal}
 {if $settings.use_transaction_code}
 {literal}
  if (document.regform.transaction_code.value == '') {
    alert("Please enter your transaction code!");
    document.regform.transaction_code.focus();
    return false;
  }
  if (document.regform.transaction_code.value != document.regform.transaction_code2.value) {
    alert("Please check your transaction code!");
    document.regform.transaction_code2.focus();
    return false;
  }
 {/literal}
 {/if}
 {literal}
  if (document.regform.email.value == '') {
    alert("Please enter your e-mail address!");
    document.regform.email.focus();
    return false;
  }
  if (document.regform.email.value != document.regform.email1.value) {
    alert("Please retype your e-mail!");
    document.regform.email.focus();
    return false;
  }

  for (i in document.regform.elements) {
    f = document.regform.elements[i];
    if (f.name && f.name.match(/^pay_account/)) {
      if (f.value == '') continue;
      var notice = f.getAttribute('data-validate-notice');
      var invalid = 0;
      if (f.getAttribute('data-validate') == 'regexp') {
        var re = new RegExp(f.getAttribute('data-validate-regexp'));
        if (!f.value.match(re)) {
          invalid = 1;
        }
      } else if (f.getAttribute('data-validate') == 'email') {
        var re = /^[^\@]+\@[^\@]+\.\w{2,4}$/;
        if (!f.value.match(re)) {
          invalid = 1;
        }
      }
      if (invalid) {
        alert('Invalid account format. Expected '+notice);
        f.focus();
        return false;
      }
    }
  }

  if (document.regform.agree.checked == false) {
    alert("You have to agree with the Terms and Conditions!");
    return false;
  }

  return true;
 }

 function IsNumeric(sText) {
  var ValidChars = "0123456789";
  var IsNumber=true;
  var Char;
  if (sText == '') return false;
  for (i = 0; i < sText.length && IsNumber == true; i++) { 
    Char = sText.charAt(i); 
    if (ValidChars.indexOf(Char) == -1) {
      IsNumber = false;
    }
  }
  return IsNumber;
 }
 </script>
 {/literal}

{if $errors}
{if $errors.turing_image}<div class="error">Invalid turing image</div>{/if}
{if $errors.no_fullname}<div class="error">Please enter your full name</div>{/if}
{if $errors.ip_exists_in_database}<div class="error">Your IP already exists in our database. Sorry, but registration impossible</div>{/if}
{if $errors.invalid_username}<div class="error">Please enter valid username! It should contains English letters and digits only.</div>{/if}
{if $errors.username_too_short}<div class="error">Username should contains {$errors.username_too_short} charaters at least</div>{/if}
{if $errors.username_exists}<div class="error">The Username is already taken. Please try another Username.</div>{/if}
{if $errors.no_password}<div class="error">Please define a password</div>{/if}
{if $errors.password_confirm}<div class="error">Please confirm your password correctly</div>{/if}
{if $errors.password_too_small}<div class="error">The password you provided is too small, please enter at least {$errors.password_too_small} characters!</div>{/if} 
{if $errors.invalid_email}<div class="error">Please valid email address</div>{/if} 
{if $errors.email_confirm}<div class="error">Please confirm your email address correctly</div>{/if}
{if $errors.email_exists}<div class="error">An account with this email is already exist</div>{/if}
{if $errors.no_address}<div class="error">Please enter your address</div>{/if}
{if $errors.no_city}<div class="error">Please enter your city</div>{/if}
{if $errors.no_state}<div class="error">Please enter your state</div>{/if}
{if $errors.no_zip}<div class="error">Please enter your zip</div>{/if}
{if $errors.no_country}<div class="error">Please enter your country</div>{/if}
{if $errors.no_transaction_code}<div class="error">Please define a transaction code</div>{/if}
{if $errors.transaction_code_confirm}<div class="error">Please correcty confirm your transaction code</div>{/if}
{if $errors.transaction_code_too_small}<div class="error">The transaction code you provided is too small, please enter at least {$errors.transaction_code_too_small} characters!</div>{/if} 
{if $errors.transaction_code_vs_password}<div class="error">The Transaction Code should not be equal to the Password you have defined</div>{/if}
{if $errors.no_agree}<div class="error">You have to agree with the Terms and Conditions!</div>{/if}
{if $errors.no_upline}<div class="error">You should have an upline to make registration.</div>{/if}
{if $errors.invalid_account_format}
 {foreach from=$errors.invalid_account_format item=err}
 <div class="error">{$err}</div>
 {/foreach}
{/if}
{/if} 

<form method=post onsubmit="return checkform()" name="regform">
<input type=hidden name=a value="signup">
<input type=hidden name=action value="signup">
<table cellspacing=0 cellpadding=2 border=0>
<tr>
 <td>Your Full Name:</td>
 <td><input type=text name=fullname value="{$frm.fullname|escape:html}" class=inpts size=30></td>
</tr>
{if $settings.use_user_location}
<tr>
 <td>Your Address:</td>
 <td><input type=text name=address value="{$frm.address|escape:html}" class=inpts size=30></td>
</tr>
<tr>
 <td>Your City:</td>
 <td><input type=text name=city value="{$frm.city|escape:html}" class=inpts size=30></td>
</tr>
<tr>
 <td>Your State:</td>
 <td><input type=text name=state value="{$frm.state|escape:html}" class=inpts size=30></td>
</tr>
<tr>
 <td>Your Zip:</td>
 <td><input type=text name=zip value="{$frm.zip|escape:html}" class=inpts size=30></td>
</tr>
<tr>
 <td>Your Country:</td>
 <td>
  <select name=country class=inpts>
<option value="">--SELECT--</option>
{foreach from=$countries item=c}
<option {if $c.name == $frm.country}selected{/if}>{$c.name|escape:html}</option>
{/foreach}
  </select>
 </td>
</tr>
{/if}
<tr>
 <td>Your Username:</td>
 <td><input type=text name=username value="{$frm.username|escape:html}" class=inpts size=30></td>
</tr>
<tr>
 <td>Define Password:</td>
 <td><input type=password name=password value="{$frm.password|escape:html}" class=inpts size=30></td>
</tr><tr>
 <td>Retype Password:</td>
 <td><input type=password name=password2 value="{$frm.password2|escape:html}" class=inpts size=30></td>
</tr>
{if $settings.use_transaction_code}
<tr>
 <td>Define Transaction Code:</td>
 <td><input type=password name=transaction_code value="{$frm.transaction_code|escape:html}" class=inpts size=30></td>
</tr><tr>
 <td>Retype Transaction Code:</td>
 <td><input type=password name=transaction_code2 value="{$frm.transaction_code2|escape:html}" class=inpts size=30></td>
</tr>
{/if}
{foreach from=$pay_accounts item=ps}
<tr>
 <td>Your {$ps.name} Account:</td>
 <td><input type=text class=inpts size=30 name="pay_account[{$ps.id}]" value="{$ps.account|escape:html}" data-validate="{$ps.validate.func}" data-validate-{$ps.validate.func}="{$ps.validate[$ps.validate.func]}" data-validate-notice="{$ps.validate.notification|escape:html}" placeholder="{$ps.validate.placeholder|escape:html}"></td>
</tr>
{/foreach}
{foreach item=p from=$mpay_accounts}
{foreach item=ps from=$p.accounts}
<tr>
 <td>Your {$p.name} {$ps.name}:</td>
 <td><input type=text class=inpts size=30 name="pay_account[{$p.id}][{$ps.name|escape:html}]" value="{$ps.value|escape:html}"></td>
</tr>
{/foreach}
{/foreach}
<tr>
 <td>Your E-mail Address:</td>
 <td><input type=text name=email value="{$frm.email|escape:html}" class=inpts size=30></td>
</tr>
<tr>
 <td>Retype Your E-mail:</td>
 <td><input type=text name=email1 value="{$frm.email1|escape:html}" class=inpts size=30></td>
</tr>
<tr>
 <td>Secret question:</td>
 <td><input type=text name=sq value="{$frm.sq|escape:html}" class=inpts size=30></td>
</tr>
<tr>
 <td>Secret answer:</td>
 <td><input type=text name=sa value="{$frm.sa|escape:html}" class=inpts size=30></td>
</tr>

{if $settings.use_referal_program}
{if $referer}
<tr>
 <td>Your Upline:</td>
 <td>{$referer.name} ({$referer.username|escape:html})</td>
</tr>
{else}
{if $settings.force_upline}
 {if $settings.get_rand_ref}
  <tr>
   <td colspan=2>
    You do not have an upline. Our system requires an upline for each user. You'll have to agree to get a random one or find a referral link on the net.
    <input type=checkbox name="rand_ref" value=1>
   </td>
  </tr>
 {else}
  <tr>
   <td colspan=2>
    You do not have an upline. Our system requires an upline for each user.
   </td>
  </tr>
 {/if}
{/if}
{/if}
{/if}

{include file="captcha.tpl" action="signup"}
<tr>
 <td colspan=2><input type=checkbox name=agree value=1 {if $frm.agree}checked{/if} > I agree with <a href="{"?a=rules"|encurl}">Terms and conditions</a></td>
</tr>

<tr>
 <td>&nbsp;</td>
 <td><input type=submit value="Register" class=sbmt></td>
</tr></table>
</form>
{/if}
{include file="footer.tpl"}

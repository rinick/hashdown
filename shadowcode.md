**Shadow Code** converts text into invisible characters
<span style='font-family:monospace;white-space: pre;font-size:13px'>
  ┏encode━↓
`a{b}c` `a⁪​⁫c` b is hidden between a and c
  ↑━decode┛
</span>
try it at: https://hashdown.github.io/edit.html#shadow#

####Example:
open ShadowCode tool and paste this text into the left input box:
`I'm leaving{cuz I hate you}.`

and click the encoding button: <span style='color:white;background:red;padding:1px'>►</span>

this is what you will get:
`I'm leaving⁪⁮⁫⁬⁪⁭⁮​​​⁫⁬​⁪⁮⁮⁫‍‍​‌​⁫‌⁪⁪⁪⁪​⁫‍⁮‍⁮⁬⁬‌⁭‍​⁭‍​.`

the text in the braces are not removed, but converted to invisible characters.

If anyones paste `I'm leaving⁪⁮⁫⁬⁪⁭⁮​​​⁫⁬​⁪⁮⁮⁫‍‍​‌​⁫‌⁪⁪⁪⁪​⁫‍⁮‍⁮⁬⁬‌⁭‍​⁭‍​.` back to the right input box and decode it, he will see the original text in the left.

####Password
If you specify a password before encoding, the hidden text also require the same password to decode

####Hide Url in Shadow Code
Using a Shortened Url in Shadow Code can help you hide more text in a twitter, like this:
`It's magic{http://goo.gl/PtUDp0}!`->`It's magic⁮‌⁬⁬⁭⁪​​⁮‍​⁭⁮⁬⁪‌⁫⁫⁪‍⁭⁫​⁪‌⁪⁭⁫‍⁪​⁪​‍‌⁭‌⁭⁪​‍⁬⁭⁭⁫⁬​⁪⁫⁭‌‍⁭⁬⁮⁭⁭⁪​!`

When encoding url, make sure to turn on **markdown(#)** before encoding, You should see a # in the encoding button : <span style='color:white;background:red;padding:1px'>►<sub>#<sub></span>
This will give you a clickable link instead of plain text after decoding.
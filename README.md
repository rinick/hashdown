
**Hashdown** is an online tool to convert text into a format that's easier and safer for sharing

editor url:
[https://hashdown.github.io/edit.html](https://hashdown.github.io/edit.html)


Hashdown supports 5 different encoding methods

| Encoding | Feature | Sample Output |
| ------------- | ------------- | ------------- |
| Link | directly open the decoded result | [https://hashdown.github.io/#GMgIv-_0GTC7iTBH4gyek93I](https://hashdown.github.io/#GMgIv-_0GTC7iTBH4gyek93I) |
| Base2e15 | minimal output characters | 炅땯腖귻㟫䩍븀묓歊 |
| Braillnary | output binary dots | ⡯⡯⡯⠺⡢⡣⡣⡤⡳⡣⡭⡭⠺⡩⡻⡳ |
| TadpoleCode | WHat?? | /ًًٍٍٍٍََََُُُِِِّّّّّّّّّْْْْْْْْْْْْٕ۪۪۪ٓۤ۠ۤ۠ﾞ |
| ShadowCode | Hide Content | Encoded data⁪‌​⁭‍⁬⁫⁬⁪⁫​⁭⁭⁬⁫⁬⁪⁫⁭⁮‌⁫ is invisible |


It supports 5 different encoding modes

## Hashdown Link

Hashdown link convert text into url hash, so you can open the link directly without the extra step to open a decoder

Example:
https://hashdown.github.io/#SGFzaERvd24gTGluayBpcyBBd2Vzb21l

* The encoding and decoding are 100% done in client side javascript, our server never know your text. the url hash (what's after #) is never sent to the network.
* When the server is down, you can still decode the content from the url if you can find any Hashdown mirror site or an offline version of Hashdown tool. 
* You can also use a password to protect your content.


## Base2e15

[Base2e15](https://github.com/rinick/base2e15) convert text to unicode characters, each unicode character represents 15 bits of data. 

Since Hashdown supports compression, it allows you to store more data in limited number of characters

## Tadpole Code
Tadpole Code convert text to unicode combining characters, which is able to combine everything into "single" character.

## Braillnary

Braillnary means braille binary, it converts string to binary and shows it in the form of braille code

Encode Table

|0x01|0x02|0x04|0x08|0x10|0x20|0x40|0x80|
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
|`⠁`|`⠈`|`⠂`|`⠐`|`⠄`|`⠠`|`⡀`|`⢀`|

## Shadow Code
Shadow Code convert text to ASCII control code, which is invisible in most browsers.

Wrap the input data with {} to hide part of the text, otherwise all text will be converted to Shadow Code

|  | Input | Output |
| ------------- | ------------- | ------------- |
| with{} | Hello{Hidden Text} World | Hello‍‍​⁭⁫⁬⁫⁫⁪‌​⁭‍⁬⁬⁭‌​​⁬‍‌⁫⁬⁪⁭​⁮‍​ World |
| without{} | Hide All | >‍‍​⁭⁫⁬⁫⁫⁪‌‍‍​‌​‌⁪⁪​⁭⁭​< |

When all text are hidden, `><` is added to make it easier to copy paste.

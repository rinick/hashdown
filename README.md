# Hashdown

Hashdown is an online tool to convert text into a format that's easier and safer for sharing

https://hashdown.github.io/edit.html

It supports 5 different encoding modes

## Hashdown Link

Hashdown link convert text into url hash

Example:  
https://hashdown.github.io/#SGFzaERvd24gTGluayBpcyBBd2Vzb21l

* The encoding and decoding are 100% done in client side javascript, our server never know your text. the url hash (what's after #) is never sent to the network.
* When the server is down, you can still decode the content from the url if you can find any Hashdown mirror site or an offline version of Hashdown tool. 
* You can use a password to protect your content.


## Hashdown Base2e15

[Base2e15](https://github.com/rinick/base2e15) convert text to unicode characters, each unicode character represents 15 bits of data. 

Since Hashdown supports compression, it allows you to store more text in limited number of characters

Sample Plain Text ( **322 characters** )
```
In URIs a hashmark # introduces the optional fragment near the end of the URL. The generic RFC 3986 syntax for URIs also allows an optional query part introduced by a question mark ?. In URIs with a query and a fragment, the fragment follows the query. Query parts depend on the URI scheme and are evaluated by the server.
```
Convert to Base2e15 ( **114 characters** )
```
蜵웦孴쮨廳擽땧䅧橔䑚쌳唜峇땢榃堻嗐歱揘芊쁷䌷䬕䆪㽍蜞芻䂜뗊俅뀾塙륡곻摡壱䉌捃玺뫂쑽릆샱糓䀡윷㚂䰒㾎렷䝿닸孔쯝禑揩㦊莛蔍嬚쥎䕾涩屇灞䣽浚껲净꼏掸煜㳌낣췹哈潶㘁唺캮㳳萯德왔뒉䜠澎㴺데瀊킊炛㴕渄味䈥폺뙉臋艺몪爱닄焍薍䩨感휧夻프쨭㿊줘㐀
```

## Hashdown Tadpole Code
Tadpole Code convert text to unicode combining characters, which is saves all your visual space by combining everything into "single" character.

Convert above sample text to Tadpole Code:
```
/ًًًًًًًًًًًًًًًًًًًًًًًٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍََََََََََََََََََََََََََََُُُُُُُُُُُُُُُُُُُُُُُُُُُُِِِِِِِِِِِِِِِِِِِِِِِِِِّّّّّّّّّّّّّّّّّّّّّّّّّّّّْْْْْْْْْْْْْْْْْْْْْْْْْْْْٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٕٕٜ۪ٕ۪۪ٕ۪ٕ۪۪۪ٜٕٜٜٕ۪۪۪۪۪ٕٕ۪۪ٕٕٕ۪۪۪ٕ۪ٜٜٕ۪ٜٕٕ۪ٕ۪۪۪۪ٕ۪ٜٕٕٕٜ۪ٜٕٕ۪ٕٕ۪۪ٜ۪ٜٜ۪۪ٜٜٜٜٜ۪ٕٜٕٜۤٓٔٔۤٔۤٓ۠ٔٔٓٔ۠ۤ۠ۤۤۤ۠۠۠ۤ۠ٓ۠ۤٓۤ۠ۤۤ۠ۤٔۤۤ۠ۤۤ۠ٓٓۤ۠ٓۤ۠ٔۤٓٓٓ۠۠۠ۤٔ۠۠ٓٔٔٓٓ۠ٓ۠ۤٓٔٔ۠ۤٓ۠ٓٓۤۤٔۤ۠ۤٓٓ۠ۤ۠ٔ۠ٓۤۤٓﾞ ( It's actually **426** characters!! )
```

## Hashdown Braillnary

Braillnary means braille binary, it converts string to binary and shows it in the form of braille code

Sample Plain Text
```
Braille is named after its creator, Louis Braille, a Frenchman who lost his sight as a result of a childhood accident.
```
Convert to Braillnary
```
⡂⡲⡡⡩⡬⡬⡥⠠⡩⡳⠠⡮⡡⡭⡥⡤⠠⡡⡦⡴⡥⡲⠠⡩⡴⡳⠠⡣⡲⡥⡡⡴⡯⡲⠬⠠⡌⡯⡵⡩⡳⠠⡂⡲⡡⡩⡬⡬⡥⠬⠠⡡⠠⡆⡲⡥⡮⡣⡨⡭⡡⡮⠠⡷⡨⡯⠠⡬⡯⡳⡴⠠⡨⡩⡳⠠⡳⡩⡧⡨⡴⠠⡡⡳⠠⡡⠠⡲⡥⡳⡵⡬⡴⠠⡯⡦⠠⡡⠠⡣⡨⡩⡬⡤⡨⡯⡯⡤⠠⡡⡣⡣⡩⡤⡥⡮⡴⠮⣀
```

## Hashdown Shadow Code
Shadow Code convert text to ASCII control code, which is invisible in most browsers.

Sample Plain Text
```
Hello {ShadowCode}World
```
Convert to Shadow Code
```
Hello ‍⁫⁭⁭⁫‌⁫‌⁪‌​⁭⁮⁬⁭⁮‍​⁭⁭⁮⁬⁫⁫⁪‌‍World
```
The font compatibility of Shadow Code is not as good as Tadpole Code, and it's not suitable for encoding long string.

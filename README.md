# Hashdown

Hashdown is an online tool to convert text into a format that's easier and safer for sharing

http://www.hashdown.net/edit.html

It supports 3 different encoding modes

## Hashdown Link

Hashdown link convert text into url hash

Example:  
http://www.hashdown.net/#SGFzaERvd24gTGluayBpcyBBd2Vzb21l

#### Why?

Of course, you can write things on blog and share the link. But Hashdown link does it in a very different way

* The encoding and decoding are 100% done in client side javascript, our server never know your text. the url hash (what's after #) is never sent to the network.
* When the server is down, you can still decode the content from the url if you can find any Hashdown mirror site or an offline version of Hashdown tool. 
* You can use a password to protect your content.

#### Url Shortener
Url shortener works great with Hashdown link, like this: http://goo.gl/Oz9MJu

But if the url shortener service is shutdown or blocked by firewall, people will no longer be able to access it.

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


## Hashdown Hidden Text
Hidden Text convert text to ASCII control code, which is invisible in most browsers.

Convert above sample text to Hidden Text
```
Hidden Text here -><- ( **424** characters! )
```

The font compatibility of Hidden Text is not as good as Tadpole Code, in Firefox and most text editors these control codes are not hidden.

# API

API to encode and decode hashdown in javascript and dart code

## javascript

```html
    <script src="http://www.hashdown.net/api.js"></script>
    <script>
      // simple encoding/decoding
      var encoded1 = $hashdown.encode('Hashdown is awesome');
      var decoded1 = $hashdown.decode(encoded1);

      // encoding with options
      var encoded2 = $hashdown.encode('Hashdown is awesome',{
        "codec" : $hashdown.BASE2E15,
        "markdown" : true,
        "protect" :  $hashdown.PROTECT_PASSWORD,
        "password" : "mypassword"
      });
      var decoded2 = $hashdown.decode(encoded2, 'mypassword').text;
    </script>
```

## dart

```dart
  import 'package:hashdown/hashdown.dart';

  void main() {
    // encode string to hashdown link
    String hashdownLink =
        Hashdown.encodeString('Hashdown is awesome', new HashdownOptions());
    
    // encode string to tadpole code
    String tadpolecode = Hashdown.encodeString(
        'Hashdown is awesome', new HashdownOptions()..codec = Hashdown.TADPOLE);
  }
```

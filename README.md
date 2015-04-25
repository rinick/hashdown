# HashDown

HashDown is an online tool to convert text into a format that's easier and safer for sharing

http://www.hashdown.net/edit.html

It supports 3 different encoding modes

## HashDown Link

HashDown link convert text into url hash

Example:  
http://www.hashdown.net/#SGFzaERvd24gTGluayBpcyBBd2Vzb21l

#### Why?

Of course, you can write things on blog and share the link. But HashDown link does it in a very different way

* The encoding and decoding are 100% done in client side javascript, our server never know your text. the url hash (what's after #) is never sent to the network.
* When the server is down, you can still decode the content from the url if you find any  HashDown mirror site or an offline version of HashDown tool. 
* You can use a password to protect your content.

#### Shortener
Url shortener works great with HashDown link, like this: http://goo.gl/Oz9MJu

But if the url shortener service is shutdown or blocked by govermenent or ISP, people will no longer be able to access it.

## HashDown Base2e15

[Base2e15](https://github.com/rinick/base2e15) convert text to unicode characters, each unicode character represents 15 bits of data. 

Since HashDown supports compression, it allows you to store more text in limited number of characters

Sample Plain Text ( **322 characters** )
```
In URIs a hashmark # introduces the optional fragment near the end of the URL. The generic RFC 3986 syntax for URIs also allows an optional query part introduced by a question mark ?. In URIs with a query and a fragment, the fragment follows the query. Query parts depend on the URI scheme and are evaluated by the server.
```
Convert to Base2e15 ( **114 characters** )
```
蜵웦孴쮨廳擽땧䅧橔䑚쌳唜峇땢榃堻嗐歱揘芊쁷䌷䬕䆪㽍蜞芻䂜뗊俅뀾塙륡곻摡壱䉌捃玺뫂쑽릆샱糓䀡윷㚂䰒㾎렷䝿닸孔쯝禑揩㦊莛蔍嬚쥎䕾涩屇灞䣽浚껲净꼏掸煜㳌낣췹哈潶㘁唺캮㳳萯德왔뒉䜠澎㴺데瀊킊炛㴕渄味䈥폺뙉臋艺몪爱닄焍薍䩨感휧夻프쨭㿊줘㐀
```

## HashDown Tadpole Code
[Tadpole Code](https://github.com/rinick/tadpolecode) convert text to unicode combining characters, which is saves all your visual space by combining everything into "single" character.

Sample Plain Text
```
In URIs a hashmark # introduces the optional fragment near the end of the URL. The generic RFC 3986 syntax for URIs also allows an optional query part introduced by a question mark ?. In URIs with a query and a fragment, the fragment follows the query. Query parts depend on the URI scheme and are evaluated by the server.
```
Convert to Tadpole Code: 
`/̷̴̷̴̶̴̶̷̴̷̸̶̸̸̶̶̷̷̴̶̶̴̸̷̵̶̶̵̶̶̷̷̵̶̸̵̵̶̴̶̷̸̷̴̵̵̷̸̴̶̴̶̷̶̸̴̴̴̶̵̵̶̴̴̴̸̷̶̵̷̷̸̶̷̷̸̵̶̸̷̵̴̶̵̵̶̶̴̸̷̴̶̵̵̶̴̶̵̵̴̶̷̷̷̸̸̴̸̷̶̴̷̸̶̶̷̶̷̷̵̸̸̵̵̴̷̶̷̶̶̷̶̶̴̵̵̵̵̴̶̵̵̷̴̷̴̷̶̵̶̵̶̧̢̨̧̧̧̧̧̢̡̨̡̨̡̢̡̨̨̨̡̨̨̧̡̢̧̢̢̡̡̢̡̢̧̡̢̡̧̢̡̡̧̡̨̨̢̧̨̡̡̨̧̨̡̧̨̨̡̢̡̨̧̨̧̨̨̢̧̨̢̨̧̧̨̡̡̨̛̛̛̛̛̛̛̛̛̛̛̛̛̛̛̛̛̛̛̛̛̛̛̛̛̛̛̛̛̛̛︢︡︡︣︡︡︡︡︡︡︢︠︢︠︡︠︢︠︢︠︣︢︢︠︡︡︣︢︢︡︡︢︢︣︡︡︢︠︠︠︠︢︠︢︣︠︣︣︢︠︣︠︢︡︣︢︠︠︠︡︠︠︠︠︢︣︢︠︣︡︠︣︡︢︡︠︡︡︣︣︣︡︡︢︡︢︢︣︣︢︠︠︢︠︢︣︢︣︢︡︢︡︠︠︣︢̕͘̕͘͘̕̕̕͘̕͘͘̕̕̕̕͘͘͘͘͘̕̕̕̕͘͘̕͘̕͘͘͘̕͘͘̕͘͘͘͘̕͘͘͘̕͘͘̕͘͘͘͘̕̕̕̕̕ `  ( It's actually **426** characters!! )

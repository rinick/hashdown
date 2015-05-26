import "package:test/test.dart";
import '../lib/hashdown.dart';

void main() {
  String testStr = 'Hashdown is awesome';
  String testShadowStr = 'Hashdown is {super }awesome';
  String testStrLong =
      '''Dart is an open-source Web programming language developed by Google.
It was unveiled at the GOTO conference in Aarhus, Denmark, October 10–12, 2011.
In order to run in mainstream browsers, Dart relies on a source-to-source compiler to JavaScript.
According to the project site, Dart was "designed to be easy to write development tools for, well-suited to modern app development, and capable of high-performance implementations."

Dart is a class-based, single-inheritance, object-oriented language with C-style syntax.
It supports interfaces, abstract classes, reified generics, and optional typing.
Static type annotations do not affect the runtime semantics of the code. Instead, the type annotations can provide documentation for tools like static checkers and dynamic runtime checks.''';

  String testStrLongUnicode = '''天地玄黄宇宙洪荒日月盈昃辰宿列张寒来暑往秋收冬藏闰余成岁律吕调阳
云腾致雨露结为霜金生丽水玉出昆冈剑号巨阙珠称夜光果珍李柰菜重芥姜
海咸河淡鳞潜羽翔龙师火帝鸟官人皇始制文字乃服衣裳推位让国有虞陶唐
吊民伐罪周发殷汤坐朝问道垂拱平章爱育黎首臣伏戎羌遐迩一体率宾归王
鸣凤在竹白驹食场化被草木赖及万方盖此身发四大五常恭惟鞠养岂敢毁伤
女慕贞洁男效才良知过必改得能莫忘罔谈彼短靡恃己长信使可覆器欲难量
墨悲丝染诗赞羔羊景行维贤克念作圣德建名立形端表正空谷传声虚堂习听
祸因恶积福缘善庆尺璧非宝寸阴是竞资父事君曰严与敬孝当竭力忠则尽命
临深履薄夙兴温凊似兰斯馨如松之盛川流不息渊澄取映容止若思言辞安定
笃初诚美慎终宜令荣业所基籍甚无竟学优登仕摄职从政存以甘棠去而益咏
乐殊贵贱礼别尊卑上和下睦夫唱妇随外受傅训入奉母仪诸姑伯叔犹子比儿
孔怀兄弟同气连枝交友投分切磨箴规仁慈隐恻造次弗离节义廉退颠沛匪亏
性静情逸心动神疲守真志满逐物意移坚持雅操好爵自縻都邑华夏东西二京
背邙面洛浮渭据泾宫殿盘郁楼观飞惊图写禽兽画彩仙灵丙舍旁启甲帐对楹
肆筵设席鼓瑟吹笙升阶纳陛弁转疑星右通广内左达承明既集坟典亦聚群英
杜稿钟隶漆书壁经府罗将相路侠槐卿户封八县家给千兵高冠陪辇驱毂振缨
世禄侈富车驾肥轻策功茂实勒碑刻铭磻溪伊尹佐时阿衡奄宅曲阜微旦孰营
桓公匡合济弱扶倾绮回汉惠说感武丁俊乂密勿多士实宁晋楚更霸赵魏困横
假途灭虢践土会盟何遵约法韩弊烦刑起翦颇牧用军最精宣威沙漠驰誉丹青
九州禹迹百郡秦并岳宗泰岱禅主云亭雁门紫塞鸡田赤城昆池碣石钜野洞庭
旷远绵邈岩岫杳冥治本于农务兹稼穑俶载南亩我艺黍稷税熟贡新劝赏黜陟
孟轲敦素史鱼秉直庶几中庸劳谦谨敕聆音察理鉴貌辨色贻厥嘉猷勉其祗植
省躬讥诫宠增抗极殆辱近耻林皋幸即两疏见机解组谁逼索居闲处沉默寂寥
求古寻论散虑逍遥欣奏累遣戚谢欢招渠荷的历园莽抽条枇杷晚翠梧桐蚤凋
陈根委翳落叶飘摇游鹍独运凌摩绛霄耽读玩市寓目囊箱易輶攸畏属耳垣墙
具膳餐饭适口充肠饱饫烹宰饥厌糟糠亲戚故旧老少异粮妾御绩纺侍巾帷房
纨扇圆洁银烛炜煌昼眠夕寐蓝笋象床弦歌酒宴接杯举觞矫手顿足悦豫且康
嫡后嗣续祭祀烝尝稽颡再拜悚惧恐惶笺牒简要顾答审详骸垢想浴执热愿凉
驴骡犊特骇跃超骧诛斩贼盗捕获叛亡布射僚丸嵇琴阮啸恬笔伦纸钧巧任钓
释纷利俗并皆佳妙毛施淑姿工颦妍笑年矢每催曦晖朗曜璇玑悬斡晦魄环照
指薪修祜永绥吉劭矩步引领俯仰廊庙束带矜庄徘徊瞻眺孤陋寡闻愚蒙等诮
谓语助者焉哉乎也''';

  test("Hashdown Link", () {
    HashdownOptions opt = new HashdownOptions()..compress = false;
    String encode1 = Hashdown.encodeString(testStr, opt);
    String decode1 = Hashdown.decode(encode1).text;
    expect(decode1, testStr);

    String encode2 = Hashdown.encodeString(testStrLong, opt);
    String decode2 = Hashdown.decode(encode2).text;
    expect(decode2, testStrLong);

    String encode3 = Hashdown.encodeString(testStrLongUnicode, opt);
    String decode3 = Hashdown.decode(encode3).text;
    expect(decode3, testStrLongUnicode);
  });
  
  test("Hashdown Tadpole", () {
    HashdownOptions opt = new HashdownOptions()
      ..codec = Hashdown.TADPOLE
      ..compress = false;
    String encode1 = Hashdown.encodeString(testStr, opt);
    String decode1 = Hashdown.decode(encode1).text;
    expect(decode1, testStr);

    String encode2 = Hashdown.encodeString(testStrLong, opt);
    String decode2 = Hashdown.decode(encode2).text;
    expect(decode2, testStrLong);

    String encode3 = Hashdown.encodeString(testStrLongUnicode, opt);
    String decode3 = Hashdown.decode(encode3).text;
    expect(decode3, testStrLongUnicode);
  });
  
  test("Hashdown Base2e15", () {
    HashdownOptions opt = new HashdownOptions()
      ..codec = Hashdown.BASE2E15
      ..compress = false;
    String encode1 = Hashdown.encodeString(testStr, opt);
    String decode1 = Hashdown.decode(encode1).text;
    expect(decode1, testStr);

    String encode2 = Hashdown.encodeString(testStrLong, opt);
    String decode2 = Hashdown.decode(encode2).text;
    expect(decode2, testStrLong);

    String encode3 = Hashdown.encodeString(testStrLongUnicode, opt);
    String decode3 = Hashdown.decode(encode3).text;
    expect(decode3, testStrLongUnicode);
  });
  test("Hashdown Shadow", () {
    HashdownOptions opt = new HashdownOptions()
      ..codec = Hashdown.SHADOW
      ..compress = false;
    String encode1 = Hashdown.encodeString(testStr, opt);
    String decode1 = Hashdown.decode(encode1).text;
    expect(decode1, testStr);

    String encode2 = Hashdown.encodeString(testStrLong, opt);
    String decode2 = Hashdown.decode(encode2).text;
    expect(decode2, testStrLong);

    String encode3 = Hashdown.encodeString(testStrLongUnicode, opt);
    String decode3 = Hashdown.decode(encode3).text;
    expect(decode3, testStrLongUnicode);
    
    String encode4 = Hashdown.encodeString(testShadowStr, opt);
    String decode4 = Hashdown.decode(encode4).text;
    expect(decode4, testShadowStr);
    
    opt.markdown = true;
    String encode5 = Hashdown.encodeString(testShadowStr, opt);
    String decode5 = Hashdown.decode(encode5).text;
    expect(decode5, testShadowStr);
  });
  test("Salt4 Protection", () {
    HashdownOptions opt = new HashdownOptions()
      ..protect = Hashdown.PROTECT_SALT4
      ..compress = false;
    String encode1 = Hashdown.encodeString(testStr, opt);
    String decode1 = Hashdown.decode(encode1).text;
    expect(decode1, testStr);

    String encode2 = Hashdown.encodeString(testStrLong, opt);
    String decode2 = Hashdown.decode(encode2).text;
    expect(decode2, testStrLong);

    String encode3 = Hashdown.encodeString(testStrLongUnicode, opt);
    String decode3 = Hashdown.decode(encode3).text;
    expect(decode3, testStrLongUnicode);
  });
  
  test("No Salt", () {
    HashdownOptions opt = new HashdownOptions()
      ..protect = Hashdown.PROTECT_RAW
      ..compress = false;
    String encode1 = Hashdown.encodeString(testStr, opt);
    String decode1 = Hashdown.decode(encode1).text;
    expect(decode1, testStr);

    String encode2 = Hashdown.encodeString(testStrLong, opt);
    String decode2 = Hashdown.decode(encode2).text;
    expect(decode2, testStrLong);

    String encode3 = Hashdown.encodeString(testStrLongUnicode, opt);
    String decode3 = Hashdown.decode(encode3).text;
    expect(decode3, testStrLongUnicode);
  });
  
  test("Password Protection", () {
    HashdownOptions opt = new HashdownOptions()
      ..protect = Hashdown.PROTECT_PASSWORD
      ..compress = false
      ..password = 'hashdown';
    String encode1 = Hashdown.encodeString(testStr, opt);
    String decode1 = Hashdown.decode(encode1, 'hashdown').text;
    String decode1_2 = Hashdown.decode(encode1).text;
    String decode1_3 = Hashdown.decode(encode1, 'hashdown-').text;
    expect(decode1, testStr);
    expect(decode1_2, null);
    expect(decode1_3, null);

    String encode2 = Hashdown.encodeString(testStrLong, opt);
    String decode2 = Hashdown.decode(encode2, 'hashdown').text;
    expect(decode2, testStrLong);

    String encode3 = Hashdown.encodeString(testStrLongUnicode, opt);
    String decode3 = Hashdown.decode(encode3, 'hashdown').text;
    expect(decode3, testStrLongUnicode);
  });
  
  test("Markdown", () {
    HashdownOptions opt = new HashdownOptions()
      ..markdown = true
      ..compress = false;
    String encode1 = Hashdown.encodeString(testStr, opt);
    HashdownResult result1 = Hashdown.decode(encode1);
    expect(result1.text, testStr);
    expect(result1.useMarkdown, true);

    String encode2 = Hashdown.encodeString(testStrLong, opt);
    HashdownResult result2 = Hashdown.decode(encode2);
    expect(result2.text, testStrLong);
    expect(result2.useMarkdown, true);

    String encode3 = Hashdown.encodeString(testStrLongUnicode, opt);
    HashdownResult result3 = Hashdown.decode(encode3);
    expect(result3.text, testStrLongUnicode);
    expect(result3.useMarkdown, true);
  });
  
  test("Compression", () {
    HashdownOptions opt = new HashdownOptions();
    String encode1 = Hashdown.encodeString(testStr, opt);
    String decode1 = Hashdown.decode(encode1).text;
    expect(decode1, testStr);

    String encode2 = Hashdown.encodeString(testStrLong, opt);
    String decode2 = Hashdown.decode(encode2).text;
    expect(decode2, testStrLong);

    String encode3 = Hashdown.encodeString(testStrLongUnicode, opt);
    String decode3 = Hashdown.decode(encode3).text;
    expect(decode3, testStrLongUnicode);
  });
}

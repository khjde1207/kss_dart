import 'package:flutter/material.dart';
import 'package:kss_dart/kss_dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var listTestText = [
    "회사 동료 분들과 다녀왔는데 분위기도 좋고 음식도 맛있었어요 다만, 강남 토끼정이 강남 쉑쉑버거 골목길로 쭉 올라가야 하는데 다들 쉑쉑버거의 유혹에 넘어갈 뻔 했답니다 강남역 맛집 토끼정의 외부 모습.",
    "미리 예약을 할 수 있는 시스템으로 합리적인 가격에 여러 종류의 생선, 그리고 다양한 부위를 즐길 수 있기 때문이다. 계절에 따라 모둠회의 종류는 조금씩 달라지지만 자주 올려주는 참돔 마스까와는 특히 맛이 매우 좋다. 일반 모둠회도 좋지만 좀 더 특별한 맛을 즐기고 싶다면 특수 부위 모둠회를 추천한다 제철 생선 5~6가지 구성에 평소 접하지 못했던 부위까지 색다르게 즐길 수 있다.",
    "그가 말했다. '거기는 가지 마세요. 위험하니까요. 알겠죠?' 그러자 그가 말했다. 알겠어요.",
    "NoSQL이라고 하는 말은 No 'English'라고 하는 말과 마찬가지다. 세상에는 영어 말고도 수많은 언어가 존재한다. MongoDB에서 사용하는 쿼리 언어와 CouchDB에서 사용하는 쿼리 언어는 서로 전혀 다르다. 그럼에도 이 두 쿼리 언어는 같은 NoSQL 카테고리에 속한다. 어쨌거나 SQL이 아니기 때문이다. 또한 NoSQL이 No RDBMS를 의미하지는 않는다. BerkleyDB같은 예외가 있기 때문이다. 그리고 No RDBMS가 NoSQL인 것도 아니다. SQL호환 레이어를 제공하는 KV-store라는 예외가 역시 존재한다. 물론 KV-store의 특징상 range query를 where절에 넣을 수 없으므로 완전한 SQL은 못 되고 SQL의 부분집합 정도를 제공한다.",
  ];

  List<String> datas = [];
  @override
  void initState() {
    var kss = Kss();
    listTestText.forEach((e) {
      datas.add(kss.splitSentences(e).join("\n"));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("example kss_dart"),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            ...listTestText
                .asMap()
                .map((k, e) {
                  return MapEntry(
                      k,
                      Card(
                          child: Column(
                        children: [
                          Text("원본 : "),
                          Text(e),
                          Divider(),
                          Text("kss 문장 분리 : "),
                          Text(
                            datas[k],
                          ),
                        ],
                      )));
                })
                .values
                .toList()
          ],
        ),
      ),
    );
  }
}

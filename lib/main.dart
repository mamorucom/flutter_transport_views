// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

// void main() {
//   runApp(
//     MaterialApp(
//       home: MyHomePage(),
//     ),
//   );
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   String _result;

//   @override
//   void initState() {
//     super.initState();
//     _result = "遷移先に移動";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Home Page（遷移元）'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               _result,
//               style: Theme.of(context).textTheme.headline5,
//             ),
//             RaisedButton(
//               child: Text('Go to Edit Page'),
//               onPressed: () async {
//                 var result = await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         // 引数に遷移元から遷移先へ渡す値を設定
//                         EditPage(receive: 'Hello! from HomePage.'),
//                   ),
//                 );
//                 print(result);
//                 setState(() {
//                   _result = result;
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             _result = "遷移先に移動";
//           });
//         },
//         tooltip: 'Increment',
//         child: Icon(
//           Icons.refresh,
//         ),
//       ),
//     );
//   }
// }

// class EditPage extends StatelessWidget {
//   final receive;
//   const EditPage({Key key, this.receive}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () {
//         // 第2引数に渡す値を設定
//         Navigator.pop(context, 'Thank you! from 戻るアイコン');
//         return Future.value(false);
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Edit Page（遷移先）'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 receive,
//                 style: Theme.of(context).textTheme.headline5,
//               ),
//               RaisedButton(
//                 child: Text('Return'),
//                 onPressed: () =>
//                     Navigator.of(context).pop('Thank you! from 戻るボタン'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ResultProvider>(
          create: (context) => ResultProvider(),
        ),
      ],
      child: MaterialApp(
        home: MyHomePage(),
      ),
    ),
  );
}

class ResultProvider extends ChangeNotifier {
  String _result;

  ResultProvider() {
    initValue();
  }

  // 初期化
  void initValue() {
    this._result = "遷移先に移動";
  }

  void refresh() {
    initValue();
    notifyListeners(); // Providerを介してConsumer配下のWidgetがリビルドされる
  }

  void updateText(String str) {
    _result = str;
  }

  void notify() {
    notifyListeners(); // Providerを介してConsumer配下のWidgetがリビルドされる
  }
}

// 遷移元ページ
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // テキスト表示
    Widget _renderText(ResultProvider model) {
      // print('text:${model._result}');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              model._result, // ResultProviderのプロパティ
              style: Theme.of(context).textTheme.headline5,
            ),
            ElevatedButton(
              child: Text('Go to Edit Page'),
              onPressed: () async {
                model.updateText('Hello! from HomePage.');
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        // 引数に遷移元から遷移先へ渡す値を設定
                        EditPage(),
                  ),
                );
                // print(result);
                model.notify(); // ResultProviderのメソッド
              },
            ),
          ],
        ),
      );
    }

    // サンプル１：Scaffold全体をリビルド
    // return Consumer<ResultProvider>(builder: (context, model, _) {
    //   return Scaffold(
    //     appBar: appBar(),
    //     body: _renderText(model),
    //     floatingActionButton: FloatingActionButton(
    //       onPressed: () {
    //         model.refresh();
    //       },
    //       child: Icon(
    //         Icons.refresh,
    //       ),
    //     ),
    //   );
    // });

    // サンプル２：appBar以外をリビルド
    return Scaffold(
      appBar: appBar(),
      body: Consumer<ResultProvider>(builder: (context, model, _) {
        return _renderText(model);
      }),
      floatingActionButton:
          Consumer<ResultProvider>(builder: (context, model, _) {
        return FloatingActionButton(
          onPressed: () {
            model.refresh(); // ResultProviderのメソッド
          },
          child: Icon(
            Icons.refresh,
          ),
        );
      }),
    );
  }

  appBar() {
    print('appBar実行');
    return AppBar(
      title: Text('My Home Page（遷移元）'),
    );
  }
}

// 遷移先ページ
class EditPage extends StatelessWidget {
  final receive;
  const EditPage({Key key, this.receive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ResultProvider>(
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () {
            model.updateText('Thank you! from 戻るアイコン'); // ResultProviderのメソッド
            Navigator.pop(context);
            return Future.value(false);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('Edit Page（遷移先）'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model._result,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  ElevatedButton(
                      child: Text('Return'),
                      onPressed: () {
                        model.updateText(
                            'Thank you! from 戻るボタン'); // ResultProviderのメソッド
                        Navigator.pop(context);
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

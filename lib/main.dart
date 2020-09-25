import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyHomePage(),
    ),
  );
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Home Page（遷移元）'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '遷移先に移動',
              style: Theme.of(context).textTheme.headline5,
            ),
            RaisedButton(
              child: Text('Go to Edit Page'),
              onPressed: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditPage(receive: 'Hello from HomePage!'),
                  ),
                );
                print(result);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EditPage extends StatelessWidget {
  final receive;
  const EditPage({Key key, this.receive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, 'Thank you from 戻るアイコン');
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
                receive,
                style: Theme.of(context).textTheme.headline5,
              ),
              RaisedButton(
                child: Text('Return'),
                onPressed: () =>
                    Navigator.of(context).pop('Thank you from 戻るボタン'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

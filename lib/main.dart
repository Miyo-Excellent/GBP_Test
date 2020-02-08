import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gbp_test/src/pages/Home.dart';
import 'package:gbp_test/src/pages/User.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (BuildContext context) => Home(),
        "user": (BuildContext context) => User(),
      },
    );
  }
}

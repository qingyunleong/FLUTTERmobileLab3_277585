import 'package:flutter/material.dart';
import 'package:lab2/view/splashpage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          brightness: Brightness.light,
          fontFamily:'Georgia',
          textTheme: const TextTheme(
            headline6: TextStyle(fontSize:20.0),
            bodyText1: TextStyle(fontSize:12.0, fontFamily:'Hind',color:Colors.black),
          )
        ),
        darkTheme: ThemeData.dark(),
        title: 'Qy Tutor',
        home: const Scaffold(
          body: SplashPage(),
        ));
  }
}

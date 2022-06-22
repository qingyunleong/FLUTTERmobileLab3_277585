import 'package:flutter/material.dart';

class Favourite extends StatefulWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  _Favourite createState() => _Favourite();
}

class _Favourite extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Favourite"));
  }
}
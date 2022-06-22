import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lab2/model/config.dart';
import 'package:lab2/model/user.dart';
import 'package:lab2/view/afterSplashPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (content) => AfterSplash())));
    //checkAndLogin();
  }

  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
          image: AssetImage('assets/images/logo1.png'),
        ))),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Welcome",
                style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
              CircularProgressIndicator(),
              Text(
                "Version 0.1",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              )
            ],
          ),
        )
      ],
    );
  }

  // checkAndLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String email = (prefs.getString('email')) ?? '';
  //   String password = (prefs.getString('pass')) ?? '';
  //   late User user;
  //   if (email.length > 1 && password.length > 1) {
  //     http.post(Uri.parse(Config.server + "/mobile_lab3/php/login_user.php"),
  //         body: {"email": email, "password": password}).then((response) {
  //       if (response.statusCode == 200 && response.body != "failed") {
  //         final jsonResponse = json.decode(response.body);
  //         user = User.fromJson(jsonResponse);
  //         Timer(
  //             const Duration(seconds: 3),
  //             () => Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (content) => AfterSplash())));
  //       } else {
  //         user = User(
  //             id: "na",
  //             name: "na",
  //             email: "na",
  //             phone: "na",
  //             address: "na",
  //             regdate: "na",
  //             otp: "na");
  //         Timer(
  //             const Duration(seconds: 3),
  //             () => Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (content) => AfterSplash())));
  //       }
  //     }).timeout(const Duration(seconds: 5));
  //   } else {
  //     user = User(
  //         id: "na",
  //         name: "na",
  //         email: "na",
  //         phone: "na",
  //         address: "na",
  //         regdate: "na",
  //         otp: "na");
  //     Timer(
  //         const Duration(seconds: 3),
  //         () => Navigator.pushReplacement(context,
  //             MaterialPageRoute(builder: (content) => AfterSplash())));
  //   }
  // }
}

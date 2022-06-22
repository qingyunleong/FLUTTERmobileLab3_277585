import 'package:flutter/material.dart';
import 'package:lab2/view/loginpage.dart';
import 'package:lab2/view/registerpage.dart';

class AfterSplash extends StatefulWidget {
  const AfterSplash({super.key});
  @override
  State<AfterSplash> createState() => _AfterSplash();
}

class _AfterSplash extends State<AfterSplash> {
  double screenHeight = 0.0, screenWidth = 0.0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover))),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 190, 222, 230),
                  onPrimary: Colors.black,
                  elevation: 5,
                  shadowColor: Colors.black,
                  fixedSize: Size(screenWidth / 1.3, screenHeight / 12),
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const LoginPage()))
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 190, 222, 230),
                  onPrimary: Colors.black,
                  elevation: 5,
                  shadowColor: Colors.black,
                  fixedSize: Size(screenWidth / 1.3, screenHeight / 12),
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const RegisterPage()))
              },
              child: const Text('Register'),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ],
    );
  }
}
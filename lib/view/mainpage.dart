import 'package:flutter/material.dart';
import 'package:lab2/model/user.dart';
import 'package:lab2/view/favourite.dart';
import 'package:lab2/view/subjects.dart';
import 'package:lab2/view/profile.dart';
import 'package:lab2/view/subscribe.dart';
import 'package:lab2/view/tutors.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainPage extends StatefulWidget {
  final User user;
  const MainPage({Key? key, required this.user}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Profile";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      Subjects(user: widget.user),
      Tutor(user: widget.user),
      subscribe(),
      Favourite(),
      Profile(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logot.png',
              fit: BoxFit.contain,
              height: 60,
            ),
          ],
        ),
        backgroundColor: Colors.blueGrey,
      ),

      body: tabchildren[_currentIndex], //mention!!!!!

      bottomNavigationBar: SalomonBottomBar(
        unselectedItemColor: Colors.blueGrey,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          SalomonBottomBarItem(
            selectedColor: Colors.redAccent,
            title: const Text("Subjects"),
            icon: const Icon(Icons.subject_outlined),
          ),
          SalomonBottomBarItem(
            selectedColor: Colors.lightBlue,
            title: const Text("Tutor"),
            icon: const Icon(Icons.school),
          ),
          SalomonBottomBarItem(
            selectedColor: Colors.deepPurple,
            title: const Text("Subscribe"),
            icon: const Icon(Icons.subscriptions),
          ),
          SalomonBottomBarItem(
            selectedColor: Colors.amber,
            title: const Text("Favourite"),
            icon: const Icon(Icons.star),
          ),
          SalomonBottomBarItem(
            selectedColor: Colors.green,
            title: const Text("Profile"),
            icon: const Icon(Icons.person),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        maintitle = "Subjects";
      }
      if (_currentIndex == 1) {
        maintitle = "Tutors";
      }
      if (_currentIndex == 2) {
        maintitle = "Subscribe";
      }
      if (_currentIndex == 3) {
        maintitle = "Favourite";
      }
      if (_currentIndex == 4) {
        maintitle = "Profille";
      }
    });
  }
}

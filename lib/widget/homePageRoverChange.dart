import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/rover.dart';
import 'homePage.dart';

class homePageReturn extends StatelessWidget {
  final List<Rover> rovers;
  const homePageReturn({Key? key, required this.rovers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Builder(builder: (BuildContext context) {
      return CupertinoPageScaffold(
        child: CupertinoTabScaffold(
          tabBuilder: (context, i) => homePage(rover: rovers[i]),
          tabBar: CupertinoTabBar(
            activeColor: Colors.orangeAccent,
            items: rovers
                .map((e) => BottomNavigationBarItem(
                icon: const Icon(Icons.biotech_rounded, color: Colors.orangeAccent,), label: e.name,))
                .toList(),
          ),
        ),
      );
    }));
  }
}
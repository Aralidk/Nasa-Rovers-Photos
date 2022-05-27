import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nasa/apps/gallery/widget/gallery.dart';

import '../../models/rover.dart';

class GalleryPage extends StatelessWidget {
  final List<Rover> rovers;
  const GalleryPage({Key? key, required this.rovers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Builder(builder: (BuildContext context) {
      return CupertinoPageScaffold(
        child: CupertinoTabScaffold(
          tabBuilder: (context, i) => Gallery(rover: rovers[i]),
          tabBar: CupertinoTabBar(
            items: rovers
                .map((e) => BottomNavigationBarItem(
                    icon: const Icon(Icons.router), label: e.name))
                .toList(),
          ),
        ),
      );
    }));
  }
}

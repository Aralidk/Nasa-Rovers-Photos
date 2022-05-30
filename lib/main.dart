import 'package:flutter/material.dart';
import 'widget/homePageRoverChange.dart';
import 'models/rover.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return homePageReturn(
      rovers: [
        Curiosity(),
        Spirit(),
        Opportunity(),
      ],
    );
  }
}
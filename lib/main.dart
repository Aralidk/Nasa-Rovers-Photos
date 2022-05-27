import 'package:flutter/material.dart';
import 'apps/gallery/gallery_page.dart';
import 'models/rover.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GalleryPage(
      rovers: [
        Curiosity(),
        Spirit(),
        Opportunity(),
      ],
    );
  }
}
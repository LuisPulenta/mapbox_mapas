import 'package:flutter/material.dart';
import 'package:mapbox_mapas/screens/fullscreenmap.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapas',
      home: Scaffold(
        body: Fullscreenmap(),
      ),
    );
  }
}

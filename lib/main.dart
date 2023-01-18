import 'package:flutter/material.dart';
import 'package:voyageslider/slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voyage Slider',
      home: Rotating3DSlider(),
    );
  }
}

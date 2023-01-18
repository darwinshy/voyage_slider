import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voyageslider/images.dart';

class BackdropImageFilter extends StatelessWidget {
  const BackdropImageFilter({Key? key, required this.pageController, required this.animationController}) : super(key: key);

  final PageController pageController;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    int currentPage = Provider.of<double>(context).toInt();

    return Positioned.fill(
      child: AnimatedBuilder(
        animation: pageController,
        builder: (context, child) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: (IMAGES[currentPage] as Image).image, fit: BoxFit.cover),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
        ),
      ),
    );
  }
}

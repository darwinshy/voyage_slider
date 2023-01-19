import 'package:flutter/material.dart';

class LeftArrowButton extends StatelessWidget {
  const LeftArrowButton({Key? key, required this.pageController}) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Positioned(
      top: height * 0.5,
      right: width * 0.2,
      child: IconButton(
        iconSize: 72,
        icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onPressed: () {
          pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
        },
      ),
    );
  }
}

class RightArrowButton extends StatelessWidget {
  const RightArrowButton({Key? key, required this.pageController}) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Positioned(
      top: height * 0.5,
      left: width * 0.2,
      child: IconButton(
        iconSize: 72,
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () {
          pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
        },
      ),
    );
  }
}

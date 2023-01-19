import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voyageslider/constant.dart';

class TitleContainer extends StatefulWidget {
  const TitleContainer({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<TitleContainer> createState() => _ImageTitleContainerState();
}

class _ImageTitleContainerState extends State<TitleContainer> with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation? animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pageController.page == null) {
      return const SizedBox();
    }

    double width = MediaQuery.of(context).size.width;
    int currentPage = Provider.of<double>(context).round();

    double value = (widget.pageController.page! % 1).abs();

    if (value > 0.5) {
      value = 1 - value;
    }

    double transitionValue = 1 - (value * 2);

    return AnimatedBuilder(
      animation: animationController!,
      builder: (context, child) => Positioned(
        bottom: transitionValue * 100,
        left: width / 2 - 212.25,
        child: Opacity(opacity: transitionValue, child: child),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.all(100),
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  images[currentPage]['title'],
                  style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
                ),
                Text(
                  images[currentPage]['subtitle'],
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

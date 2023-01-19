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

  GlobalKey _titleKey = GlobalKey();
  GlobalKey _subtitleKey = GlobalKey();

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
    double height = MediaQuery.of(context).size.height;

    int currentPage = Provider.of<double>(context).round();

    double value = (widget.pageController.page! % 1).abs();

    if (value > 0.5) {
      value = 1 - value;
    }

    double transitionValue = (1 - (value * 2));
    double clampedValue = transitionValue.clamp(0, 1);

    return AnimatedBuilder(
      animation: animationController!,
      builder: (context, child) => Stack(
        children: [
          AnimatedPositioned(
            key: _titleKey,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            bottom: clampedValue * 300 + clampedValue * 20,
            left: width / 2 - width / 10,
            child: Opacity(
              opacity: transitionValue,
              child: Text(
                images[currentPage]['title'],
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          AnimatedPositioned(
            key: _subtitleKey,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            bottom: clampedValue * 330 - clampedValue * 40,
            left: width / 2 - width / 10,
            child: Opacity(
              opacity: transitionValue,
              child: Text(
                images[currentPage]['subtitle'],
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }
}

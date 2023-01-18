import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voyageslider/button.dart';
import 'package:voyageslider/filter.dart';
import 'package:voyageslider/constant.dart';

class Rotating3DSlider extends StatefulWidget {
  const Rotating3DSlider({super.key});

  @override
  State<Rotating3DSlider> createState() => _Rotating3DSliderState();
}

class _Rotating3DSliderState extends State<Rotating3DSlider> with TickerProviderStateMixin {
  double currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.3, keepPage: true, initialPage: images.length ~/ 2);
  final PageController _titleController = PageController(viewportFraction: 0.3, keepPage: true, initialPage: images.length ~/ 2);

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _pageController.addListener(() => setState(() => currentPage = _pageController.page!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Provider.value(
            value: currentPage,
            child: BackdropImageFilter(pageController: _pageController, animationController: _animationController),
          ),
          Provider.value(
            value: currentPage,
            child: SliderBuilder(pageController: _pageController, animationController: _animationController),
          ),
          Provider.value(
            value: currentPage,
            child: ImageTitleContainer(titleController: _titleController, pageController: _pageController),
          ),
          RightArrowButton(pageController: _pageController, titleController: _titleController),
          LeftArrowButton(pageController: _pageController, titleController: _titleController),
        ],
      ),
    );
  }
}

class ImageTitleContainer extends StatefulWidget {
  const ImageTitleContainer({super.key, required this.titleController, required this.pageController});

  final PageController titleController;
  final PageController pageController;

  @override
  State<ImageTitleContainer> createState() => _ImageTitleContainerState();
}

class _ImageTitleContainerState extends State<ImageTitleContainer> with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation? animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController!);

    animationController!.forward();
  }

  @override
  Widget build(BuildContext context) {
    int currentPage = Provider.of<double>(context).toInt();

    return AnimatedBuilder(
      animation: animationController!,
      builder: (context, child) {
        log(animationController!.value.toString());
        return Transform(
          transform: Matrix4.translationValues((100 * (1 - animation!.value).toDouble()), 0.0, 0.0),
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.all(100),
        child: Align(
          alignment: Alignment.bottomCenter,
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

class SliderBuilder extends StatelessWidget {
  const SliderBuilder({Key? key, required this.pageController, required this.animationController}) : super(key: key);

  final PageController pageController;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(100),
      child: PageView.builder(
        pageSnapping: true,
        scrollDirection: Axis.horizontal,
        controller: pageController,
        itemCount: images.length,
        itemBuilder: (context, index) => PageItem(index: index, animationController: animationController),
      ),
    );
  }
}

class PageItem extends StatelessWidget {
  const PageItem({Key? key, required this.index, required this.animationController}) : super(key: key);

  final int index;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    double currentPage = Provider.of<double>(context);

    double diff = currentPage - index;

    Matrix4 transform = Matrix4.identity()
      ..scale(1 - diff.abs() / 4)
      ..setEntry(3, 2, 0.001)
      ..translate(0.0, 0.0, diff.abs())
      ..rotateY(-diff * 0.8);

    double opacity = (1 - diff.abs()).clamp(0.2, 1.0);

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) => Opacity(
        opacity: opacity,
        child: Transform(transform: transform, alignment: Alignment.center, child: ImageBox(index: index)),
      ),
    );
  }
}

class ImageBox extends StatelessWidget {
  const ImageBox({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(fit: BoxFit.cover, image: (images[index]['image'] as Image).image),
      ),
    );
  }
}

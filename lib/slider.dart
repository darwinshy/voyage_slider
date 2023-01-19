import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voyageslider/components/button.dart';
import 'package:voyageslider/components/page_item.dart';
import 'package:voyageslider/components/title.dart';
import 'package:voyageslider/components/filter_bg.dart';
import 'package:voyageslider/constant.dart';

class Rotating3DSlider extends StatefulWidget {
  const Rotating3DSlider({super.key});

  @override
  State<Rotating3DSlider> createState() => _Rotating3DSliderState();
}

class _Rotating3DSliderState extends State<Rotating3DSlider> with TickerProviderStateMixin {
  double currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.3, keepPage: true, initialPage: images.length ~/ 2);

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
            child: TitleContainer(pageController: _pageController),
          ),
          RightArrowButton(pageController: _pageController),
          LeftArrowButton(pageController: _pageController),
        ],
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

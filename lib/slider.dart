import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voyageslider/filter.dart';
import 'package:voyageslider/images.dart';

class Rotating3DSlider extends StatefulWidget {
  const Rotating3DSlider({super.key});

  @override
  State<Rotating3DSlider> createState() => _Rotating3DSliderState();
}

class _Rotating3DSliderState extends State<Rotating3DSlider> with TickerProviderStateMixin {
  double currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.3, keepPage: true, initialPage: 1);
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));

    _pageController.addListener(() => setState(() => currentPage = _pageController.page!));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
          Positioned(
            top: height * 0.5,
            left: width * 0.2,
            child: IconButton(
              iconSize: 72,
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn),
            ),
          ),
          Positioned(
            top: height * 0.5,
            right: width * 0.2,
            child: IconButton(
              iconSize: 72,
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn),
            ),
          ),
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
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: pageController,
        itemCount: IMAGES.length,
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
        child: Transform(
          transform: transform,
          alignment: Alignment.center,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(fit: BoxFit.cover, image: (IMAGES[index] as Image).image),
            ),
          ),
        ),
      ),
    );
  }
}

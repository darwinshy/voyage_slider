import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voyageslider/constant.dart';

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

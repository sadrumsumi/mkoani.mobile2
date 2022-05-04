import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: ChangingImage(
        animation: animation,
      ),
    );
  }

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 30));
    animation = Tween<double>(begin: 0, end: 3).animate(controller);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ChangingImage extends AnimatedWidget {
  final List<String> _images = [
    'images/fetured/fetured_1.jpg',
    'images/fetured/fetured_2.jpg',
    'images/fetured/fetured_3.jpg',
    'images/fetured/fetured_4.jpg'
  ];

  final Animation<double> animation;
  ChangingImage({Key? key, required this.animation})
      : super(listenable: animation, key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(_images[animation.value.toInt()]),
      fit: BoxFit.cover,
    );
  }
}

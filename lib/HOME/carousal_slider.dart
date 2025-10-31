import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
class caroual_slider extends StatelessWidget {
  const caroual_slider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        Image.asset(
          "assets/image/sli1.webp",
          fit: BoxFit.cover,
        ),
        Image.asset(
          "assets/image/sli.webp",
          fit: BoxFit.cover,
        ),
        Image.asset(
          "assets/image/sli2.webp",
          fit: BoxFit.cover,
        ),
        Image.asset(
          "assets/image/1.png",
          fit: BoxFit.cover,
        ),
        Image.asset(
          "assets/image/sli.jpg",
          fit: BoxFit.cover,
        ),Image.asset(
          "assets/image/sli1.jpg",
          fit: BoxFit.cover,
        ),
      ],
      options: CarouselOptions(
        viewportFraction: .9,
        aspectRatio: 16 / 9,
        enlargeCenterPage: true,
        height: 150,
        autoPlay: true,
        enableInfiniteScroll: true,
      ),
    );
  }
}

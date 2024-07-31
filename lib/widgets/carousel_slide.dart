import 'dart:typed_data';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:convert';

class CarouselSlide extends StatefulWidget {
  final double? height;

  const CarouselSlide({Key? key, required this.height}) : super(key: key);

  @override
  State<CarouselSlide> createState() => _CarouselSlideState();
}

class _CarouselSlideState extends State<CarouselSlide> {
  int activeIndex = 0;
  final controller = CarouselController();
  final SystemApi systemApi = SystemApi();
  List<Uint8List> carouselImages = [];

  @override
  void initState() {
    super.initState();
    fetchCarousels();
  }

  Future<void> fetchCarousels() async {
    try {
      List<Carousel> fetchedCarousels = await systemApi.getCarousels();
      // Lọc những carousel có status = 1
      List<Uint8List> images = fetchedCarousels
          .where((carousel) => carousel.status == 1)
          .map((carousel) => base64Decode(carousel.image))
          .toList();
      setState(() {
        carouselImages = images;
      });
    } catch (e) {
      // Xử lý lỗi
      print('Failed to load carousels: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (carouselImages.isNotEmpty)
          CarouselSlider.builder(
            carouselController: controller,
            itemCount: carouselImages.length,
            itemBuilder: (context, index, realIndex) {
              final image = carouselImages[index];
              return buildImage(image, index);
            },
            options: CarouselOptions(
              height: widget.height ?? 200.0,
              autoPlay: true,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              enlargeCenterPage: true,
              onPageChanged: (index, reason) =>
                  setState(() => activeIndex = index),
            ),
          ),
        const SizedBox(height: 10),
        if (carouselImages.isNotEmpty) buildIndicator()
      ],
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        onDotClicked: animateToSlide,
        effect: ExpandingDotsEffect(
            dotHeight: 5, dotWidth: 5, activeDotColor: primaryColors),
        activeIndex: activeIndex,
        count: carouselImages.length,
      );

  void animateToSlide(int index) => controller.animateToPage(index);

  Widget buildImage(Uint8List image, int index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.memory(
            image,
            fit: BoxFit.cover,
          ),
        ),
      );
}

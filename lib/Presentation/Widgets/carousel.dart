import 'package:mbm_elearning/Data/get_cus_ads.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final List imgList = [];

final List<Widget> imageSliders = imgList
    .map(
      (item) => InkWell(
        onTap: () {
          launch(item[1]);
        },
        child: Image.network(
          item[0],
          fit: BoxFit.fill,
          width: 300,
          height: 100,
        ),
      ),
    )
    .toList();

class CarouselAds extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselAds> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCusAdsDataRequest(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 0,
          );
        } else if (snapshot.data == null) {
          return const SizedBox(
            width: 0,
          );
        } else if (snapshot.data[0]['showstatus']) {
          for (var i in snapshot.data) {
            imgList.add([i['image'], i['url']]);
          }
          if (imgList.isNotEmpty) {
            return SizedBox(
              height: 100,
              width: double.infinity,
              child: CarouselSlider(
                items: imageSliders,
                carouselController: _controller,
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                ),
              ),
            );
          } else {
            return const SizedBox(
              width: 0,
            );
          }
        } else {
          return const SizedBox(
            width: 0,
          );
        }
      },
    );
  }
}

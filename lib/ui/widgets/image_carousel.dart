import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:realiteye/utils/utils.dart';

class ImageCarousel extends StatefulWidget {
  final List<dynamic> imgList;

  ImageCarousel(this.imgList);

  @override
  State<StatefulWidget> createState() {
    return _ImageCarouselState();
  }
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            CarouselSlider(
              items: buildImageSliders(widget.imgList),
              options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  //height: 400,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imgList.map((url) {
                int index = widget.imgList.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
          ]
      ),
    );
  }
}

List<Widget> buildImageSliders(List<dynamic> imgList) {
  return imgList.map((item) => Container(
    child: Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Image.network(item, fit: BoxFit.cover, width: 1000.0,
                loadingBuilder: onImageLoad,
                errorBuilder: onImageError,
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  // child: Text(
                  //   'No. ${imgList.indexOf(item)} image',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 20.0,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ),
              ),
            ],
          )
      ),
    ),
  )).toList();
}
import 'dart:ui';

import 'package:flutter/material.dart';

class HomeFilterCard extends StatelessWidget {
  final double width, height;
  final String imageAssetUri;
  final double blurX, blurY, opacity;
  final String text;
  final Function() onTap;

  HomeFilterCard(this.imageAssetUri, this.text, { this.width = 200, this.height = 120,
    this.blurX = 0.5, this.blurY = 0.5, this.opacity = 0.7, this.onTap });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageAssetUri),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurX, sigmaY: blurY),
          child: Container(
            color: Colors.black.withOpacity(opacity),
            child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(text,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
            ),
          ),
        ),
      )
    );
  }
}

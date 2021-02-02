import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CauseImgPreview extends StatelessWidget {
  final VoidCallback onTap;
  final File file;
  final String imgURL;
  final double height;
  final double width;

  CauseImgPreview(
      {this.onTap, this.file, this.imgURL, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        child: file == null
            ? CachedNetworkImage(
                imageUrl: imgURL == null ? "" : imgURL,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.medium)
            : Image.file(file,
                fit: BoxFit.contain, filterQuality: FilterQuality.medium),
      ),
    );
  }
}

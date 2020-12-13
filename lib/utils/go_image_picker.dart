import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class GoImagePicker {
  final BuildContext context;
  final double ratioX;
  final double ratioY;

  GoImagePicker({
    this.context,
    this.ratioX,
    this.ratioY,
  });

  final ImagePicker _imagePicker = ImagePicker();
  final MultiImagePicker _multiImagePicker = MultiImagePicker();

  Future<File> retrieveImageFromLibrary({double ratioX, double ratioY}) async {
    imageCache.clear();
    File croppedImageFile;
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
    File img = File(pickedFile.path);
    if (img != null) {
      croppedImageFile = await cropImage(img: img, ratioX: ratioX, ratioY: ratioY);
    }
    return croppedImageFile;
  }

  Future<File> retrieveImageFromCamera({double ratioX, double ratioY}) async {
    imageCache.clear();
    File croppedImageFile;
    final pickedFile = await _imagePicker.getImage(source: ImageSource.camera);
    File img = File(pickedFile.path);
    if (img != null) {
      croppedImageFile = await cropImage(
        img: img,
        ratioX: ratioX,
        ratioY: ratioY,
      );
    }
    return croppedImageFile;
  }

  Future<List<dynamic>> retrieveMultipleImages() async {
    imageCache.clear();
    List<Asset> images = List<Asset>();
    images = await MultiImagePicker.pickImages(
      maxImages: 3,
      enableCamera: true,
      selectedAssets: images,
    );
    images.forEach((image) {
      print(image.name);
    });
    return images;
  }

  Future<File> cropImage({File img, double ratioX, double ratioY}) async {
    File croppedImageFile;
    croppedImageFile = await ImageCropper.cropImage(
      sourcePath: img.path,
      aspectRatio: CropAspectRatio(
        ratioX: ratioX,
        ratioY: ratioY,
      ),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
      compressFormat: ImageCompressFormat.png,
      compressQuality: 50,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.white,
      ),
    );
    return croppedImageFile;
  }
}

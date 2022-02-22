import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class ImageService {
  Future<Object>showImage(img, place) async {
    var images = json.decode(img);
    List butter = [];

    for (final i in images) {
      final ByteData imageData =
          await NetworkAssetBundle(Uri.parse(SERVER_IP + "image/${place}/${i}"))
              .load("");
      final Uint8List bytes = imageData.buffer.asUint8List();
      butter.add(Image.memory(bytes));
    }
    return butter;
  }
}

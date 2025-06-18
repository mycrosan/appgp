import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:GPPremium/models/responseMessage.dart';


import '../main.dart';

class ImageService {
  Future<Object> showImage(img, place) async {
    var images = json.decode(img);
    List butter = [];

    for (final i in images) {
      try {
        final ByteData imageData = await NetworkAssetBundle(
                Uri.parse(SERVER_IP + "image/${place}/${i}"))
            .load("")
            .timeout(const Duration(seconds: 60));
        final Uint8List bytes = imageData.buffer.asUint8List();
        butter.add(Image.memory(bytes));
      } on TimeoutException catch (e) {
        print(e);
        return responseMessage.fromJson({"status": false, "timestamp": "",
          "message": "O servidor não respondeu, tente novamente!",
          "error": e.message,
          "debugMessage": "debug",
          "subErrors": null});
      } on SocketException catch (e) {
        print(e);
        return responseMessage.fromJson({"status": false, "timestamp": "",
          "message": "O servidor não respondeu, tente novamente!",
          "error": e.message,
          "debugMessage": "debug",
          "subErrors": null});
      }
    }
    return butter;
  }
}

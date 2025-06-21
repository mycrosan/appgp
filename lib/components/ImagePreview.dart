/**
 * Exibir imagem apos tirar fotos e exibir imagem ao detalhar
 * Parametro: string adicionar, ou qualquer outro para outras regioes
 */
import 'dart:io';

import 'package:flutter/material.dart';

Widget showImage(imageFileList, String place) {
    if (imageFileList.length > 0) {
      return Container(
        child: Container(
          height: 450.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageFileList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Container(
                  margin: const EdgeInsets.all(3.0),
                  child: InteractiveViewer(
                      clipBehavior: Clip.none,
                      child: AspectRatio(
                          aspectRatio: 0.75,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: place == "adicionar" ? new Image.file(
                                  File(imageFileList[index].path)) : imageFileList[index]))));
            },
          ),
        ),
      );
    }
  }


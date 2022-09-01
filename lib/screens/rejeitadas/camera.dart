import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {

  File _image;

  Future getImage() async{
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      _image = image as File;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Camera"),
      ),
      body: Center(
        child: _image == null ?  Text ("foto") : Image.file(_image)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'incrementar',
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}

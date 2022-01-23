import 'package:GPPremium/models/carcaca.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'camera.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Asset> _images = List<Asset>();
  final _formkey = GlobalKey<FormState>();

  MaskedTextController textEditingControllerfotos;

  Carcaca carcaca;

  /*List<Fotos> fotosList = [];
  Fotos fotosSelected;*/


  //String _error = 'Nenhum Error Encontrado';
  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(_images.length, (index) {
        Asset asset = _images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    if (!await Permission.camera.request().isGranted) {
      setState(() {
        //_error = "Permissão não garantida!";
      });
      return;
    }

    List<Asset> resultList = List<Asset>();
    String error = 'Nenhum Error Encontrado';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: false,
        selectedAssets: _images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Galeria",
          allViewTitle: "Todos as Fotos",
          useDetailsView: false,
          selectCircleStrokeColor: "#ffffff",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _images = resultList;
      //_error = error;,

    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.black,
          title: const Text('Camera e Galeria'),
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 32,
            ),
            //Center(
            //  child: Text(
            //'LOG: $_error',
            //style: TextStyle(fontSize: 18),
            //)),
            //const SizedBox(
            //height: 32,
            //),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: loadAssets,
                    icon: Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.green,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Camera()));
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      size: 40,
                      color: Colors.blue,
                    ))
              ],
            ),
            Padding(padding: EdgeInsets.all(18)),
            Expanded(
              child: buildGridView(),
            ),
            RaisedButton(
              child: Text("Salvar"),
              color: Colors.blue,
              textColor: Colors.white,
              highlightColor: Colors.black,
              onPressed: () {},
            ),
            SizedBox(height: 10),
            //
            //RaisedButton(
            //child: Text("Galeria"),
            //onPressed: loadAssets,
            //),
          ],
        ),
      ),
    );
  }
}

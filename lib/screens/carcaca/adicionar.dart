import 'dart:convert';

import 'package:GPPremium/models/carcaca.dart';
import 'package:GPPremium/models/medida.dart';
import 'package:GPPremium/models/modelo.dart';
import 'package:GPPremium/models/pais.dart';
import 'package:GPPremium/models/responseMessageSimple.dart';
import 'package:GPPremium/service/carcacaapi.dart';
import 'package:GPPremium/service/medidaapi.dart';
import 'package:GPPremium/service/modeloapi.dart';

import 'package:GPPremium/service/paisapi.dart';
import 'package:GPPremium/service/uploadapi.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'ListaCarcacas.dart';

class AdicionarCarcacaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AdicionarCarcacaPageState();
  }
}

class AdicionarCarcacaPageState extends State<AdicionarCarcacaPage> {
  final _formkey = GlobalKey<FormState>();

  MaskedTextController textEditingControllerEtiqueta;
  MaskedTextController textEditingControllerDot;
  TextEditingController textEditingControllerModelo;
  TextEditingController textEditingControllerMarca;
  TextEditingController textEditingControllerMedida;
  Carcaca carcaca;

  //Modelo
  List<Modelo> modeloList = [];
  Modelo modeloSelected;

  //Medida
  List<Medida> medidaList = [];
  Medida medidaSelected;

  //Pais
  List<Pais> paisList = [];
  Pais paisSelected;

  @override
  void initState() {
    super.initState();
    textEditingControllerEtiqueta = MaskedTextController(mask: '000000');
    textEditingControllerDot = MaskedTextController(mask: '0000');
    textEditingControllerModelo = TextEditingController();
    textEditingControllerMarca = TextEditingController();
    textEditingControllerMedida = TextEditingController();
    carcaca = new Carcaca();

    ModeloApi().getAll().then((List<Modelo> value) {
      setState(() {
        modeloList = value;
      });
    });

    MedidaApi().getAll().then((List<Medida> value) {
      setState(() {
        medidaList = value;
      });
    });

    PaisApi().getAll().then((List<Pais> value) {
      setState(() {
        paisList = value;
      });
    });
  }

  File _image;

  Future getImage() async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 25);

    setState(() {
      _image = pickedFile;
    });

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Carcaça'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: _construirFormulario(context),
        ),
      ),
    );
  }

  Widget _construirFormulario(context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            controller: textEditingControllerEtiqueta,
            decoration: InputDecoration(
              labelText: "Etiqueta",
            ),
            validator: (value) =>
                value.length == 0 ? 'Não pode ser nulo' : null,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (String newValue) {
              setState(() {
                carcaca.numeroEtiqueta = newValue;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.all(10),
          ),
          TextFormField(
            controller: textEditingControllerDot,
            decoration: InputDecoration(
              labelText: "Dot",
            ),
            validator: (value) =>
                value.length == 0 ? 'Não pode ser nulo' : null,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (String newValue) {
              setState(() {
                carcaca.dot = newValue;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.all(10),
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "Modelo",
            ),
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            value: modeloSelected,
            isExpanded: true,
            onChanged: (Modelo modelo) {
              setState(() {
                modeloSelected = modelo;
                carcaca.modelo = modeloSelected;
              });
            },
            items: modeloList.map((Modelo modelo) {
              return DropdownMenuItem(
                value: modelo,
                child: Text(modelo.descricao),
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "Medida",
            ),
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            value: medidaSelected,
            isExpanded: true,
            onChanged: (Medida medida) {
              setState(() {
                medidaSelected = medida;
                carcaca.medida = medidaSelected;
              });
            },
            items: medidaList.map((Medida medida) {
              return DropdownMenuItem(
                value: medida,
                child: Text(medida.descricao),
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "País",
            ),
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            value: paisSelected,
            isExpanded: true,
            onChanged: (Pais pais) {
              setState(() {
                paisSelected = pais;
                carcaca.pais = paisSelected;
              });
            },
            items: paisList.map((Pais pais) {
              return DropdownMenuItem(
                value: pais,
                child: Text(pais.descricao),
              );
            }).toList(),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Container(
            child: _image == null
                ? Text("Pré Visualização da foto..")
                : Image.file(_image),
          ),
          // botões camera
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: getImage,
                tooltip: 'incrementar',
                child: Icon(Icons.camera_alt),
              ),
              /*
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MyApp()));
                },
                child: Text("Camera e Galeria"),
                color: Colors.blue,
                textColor: Colors.white,
                highlightColor: Colors.black,
              )
              //IconButton(
              //onPressed: () {
              //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => cameraApp ()));
              //},
              //icon: Icon(Icons.photo_camera_outlined),
              //),
              //Padding(
              //padding: EdgeInsets.all(2),
              //),
              //IconButton(
              //onPressed: () {},
              // icon: Icon(Icons.add_photo_alternate_outlined),
              // ),
            */
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8),
          ),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/home");
                },
              )),
              Padding(padding: EdgeInsets.all(5)),
              Expanded(
                  child: ElevatedButton(
                child: Text("Salvar"),
                onPressed: () async {

                  Map<String, String> body = {
                    'title': 'carcacaImage',
                  };

                  responseMessageSimple imageResponse = await UploadApi().addImage(body, _image.path);

                  print(imageResponse.content[0]);
                  carcaca.fotos = imageResponse.content[0];

                  if (_formkey.currentState.validate()) {
                    var response = await CarcacaApi().create(carcaca);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListaCarcaca(),
                      ),
                    );
                  }
                },
              )),
            ],
          )
        ],
      ),
    );
  }
}

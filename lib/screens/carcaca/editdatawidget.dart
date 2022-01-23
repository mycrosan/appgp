import 'dart:typed_data';

import 'package:GPPremium/models/carcaca.dart';
import 'package:GPPremium/models/medida.dart';
import 'package:GPPremium/models/modelo.dart';
import 'package:GPPremium/models/pais.dart';
import 'package:GPPremium/service/carcacaapi.dart';
import 'package:GPPremium/service/medidaapi.dart';
import 'package:GPPremium/service/modeloapi.dart';
import 'package:GPPremium/service/paisapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import 'ListaCarcacas.dart';

class EditarCarcacaPage extends StatefulWidget {
  int id;
  Carcaca carcacaEdit;

  EditarCarcacaPage({Key key, this.carcacaEdit, producao}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditarCarcacaPageState();
  }
}

class EditarCarcacaPageState extends State<EditarCarcacaPage> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController textEditingControllerEtiqueta;
  TextEditingController textEditingControllerDot;
  Carcaca carcaca;
  Image _image;
  bool image_ok = false;

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
    textEditingControllerEtiqueta = new TextEditingController();
    textEditingControllerDot = new TextEditingController();
    carcaca = new Carcaca();
    // image = showImage( widget.carcacaEdit.fotos);

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

    setState(() {
      carcaca.id = widget.carcacaEdit.id;
      textEditingControllerEtiqueta.text = widget.carcacaEdit.numeroEtiqueta;
      carcaca.numeroEtiqueta = widget.carcacaEdit.numeroEtiqueta;
      textEditingControllerDot.text = widget.carcacaEdit.dot;
      carcaca.dot = widget.carcacaEdit.dot;
      carcaca.modelo = widget.carcacaEdit.modelo;
      carcaca.medida = widget.carcacaEdit.medida;
      carcaca.pais = widget.carcacaEdit.pais;
      carcaca.fotos = widget.carcacaEdit.fotos;
      modeloSelected = carcaca.modelo;
      medidaSelected = carcaca.medida;
      paisSelected = carcaca.pais;
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  void dispose() {
    // textEditingControllerEtiqueta.dispose();
    // textEditingControllerDot.dispose();
    super.dispose();
  }

  showImage(img) async {
      final ByteData imageData = await NetworkAssetBundle(
              Uri.parse(SERVER_IP + "carcaca/image/${img}"))
          .load("");
      final Uint8List bytes = imageData.buffer.asUint8List();
      // Image image = Image.memory(bytes);
      // return bytes;
      image_ok = true;
      return Image.memory(bytes);
  }

  @override
  Widget build(BuildContext context) {
    var carcacaApi = new CarcacaApi();

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Carcaça'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
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
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
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
                    // initialValue: (snapshot.data !=null) ? snapshot.data.dot : null,
                    controller: textEditingControllerDot,
                    decoration: InputDecoration(
                      labelText: "Dot",
                    ),
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
                    // hint: Text("Selecione um modelo"),
                    decoration: InputDecoration(
                      labelText: "Modelo",
                    ),
                    validator: (value) =>
                        value == null ? 'Não pode ser nulo' : null,
                    value: modeloSelected,
                    isExpanded: true,
                    onChanged: (modelo) {
                      setState(() {
                        modeloSelected = modelo;
                        carcaca.modelo = modeloSelected;
                      });
                    },
                    items: modeloList.map((modelo) {
                      return DropdownMenuItem(
                        value: modelo,
                        child: Text(modelo.descricao),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField(
                    // hint: Text("Selecione um medida"),
                    decoration: InputDecoration(
                      labelText: "Medida",
                    ),
                    validator: (value) =>
                        value == null ? 'Não pode ser nulo' : null,
                    value: medidaSelected,
                    isExpanded: true,
                    onChanged: (medida) {
                      setState(() {
                        medidaSelected = medida;
                        carcaca.medida = medidaSelected;
                      });
                    },
                    items: medidaList.map((medida) {
                      return DropdownMenuItem(
                        value: medida,
                        child: Text(medida.descricao),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField(
                    // hint: Text("Selecione um pais"),
                    decoration: InputDecoration(
                      labelText: "País",
                    ),
                    validator: (value) =>
                        value == null ? 'Não pode ser nulo' : null,
                    value: paisSelected,
                    isExpanded: true,
                    onChanged: (pais) {
                      setState(() {
                        paisSelected = pais;
                        carcaca.pais = paisSelected;
                      });
                    },
                    items: paisList.map((pais) {
                      return DropdownMenuItem(
                        value: pais,
                        child: Text(pais.descricao),
                      );
                    }).toList(),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Container(
                    child: FutureBuilder(
                        future: showImage(carcaca.fotos),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                                    child: snapshot.data,
                                  );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),

                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        child: Text("Cancelar"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListaCarcaca(),
                            ),
                          );
                        },
                      )),
                      Padding(padding: EdgeInsets.all(5)),
                      Expanded(
                          child: ElevatedButton(
                        child: Text("Atualizar"),
                        onPressed: () async {
                          var carcacaApi = new CarcacaApi();
                          var response = await carcacaApi.update(carcaca);
                          print(response);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListaCarcaca(),
                            ),
                          );
                        },
                      )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

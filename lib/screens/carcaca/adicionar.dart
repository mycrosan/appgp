import 'dart:convert';
import 'package:GPPremium/components/ImagePreview.dart';
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
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../models/responseMessage.dart';
import 'ListaCarcacas.dart';

class AdicionarCarcacaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AdicionarCarcacaPageState();
  }
}

class AdicionarCarcacaPageState extends State<AdicionarCarcacaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carcaça'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 70.0),
          child: _construirFormulario(context),
        ),
      ),
    );
  }

  final _formkey = GlobalKey<FormState>();

  XFile _imageFile1;
  List _imageFileList = [];

  bool isVideo = false;

  set _imageFile(XFile value) {
    _imageFileList = value == null ? null : [value];
  }

  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();

  String _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

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

  // XFile _imageFile;
  dynamic _pickImageError;

  Future getImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 25,
      );
      setState(() {
        _imageFileList.add(pickedFile);
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  // Widget _handlePreview() {
  //   if (false) {
  //     // return _previewVideo();
  //   } else {
  //     return _previewImages();
  //   }
  // }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        // await _playVideo(response.file);
      } else {
        isVideo = false;
        setState(() {
          _imageFile = response.file;
          _imageFileList = response.files;
        });
      }
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
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
          Center(child: showImage(_imageFileList, "adicionar")),
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: getImage,
                  tooltip: 'incrementar',
                  child: Icon(Icons.camera_alt),
                ),
              ],
            ),
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
                child: RoundedLoadingButton(
                  color: Colors.black,
                  successIcon: Icons.check,
                  failedIcon: Icons.cottage,
                  child: Text('Salvar!', style: TextStyle(color: Colors.white)),
                  controller: _btnController1,
                  onPressed: () async {
                    if (_formkey.currentState.validate() && _imageFileList.length > 0) {

                      Map<String, String> body = {
                        'title': 'carcaca',
                      };

                      responseMessageSimple imageResponse =
                          await UploadApi().addImage(body, _imageFileList);

                      carcaca.fotos = json.encode(imageResponse.content);

                      var response = await CarcacaApi().create(carcaca);

                      if (response is Carcaca && response != null) {

                        _btnController1.success();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListaCarcaca(),
                          ),
                        );

                      } else {
                        responseMessage value =
                        response != null ? response : null;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Atenção!"),
                              content: Text(value.debugMessage),
                              actions: [
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ListaCarcaca(),
                                      ),
                                    );
                                    // _btnController1.reset();
                                    // Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      _btnController1.reset();
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30),
              ),
            ],
          )
        ],
      ),
    );
  }
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);

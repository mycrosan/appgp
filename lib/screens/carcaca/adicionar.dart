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
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
  final _formkey = GlobalKey<FormState>();

  XFile _imageFile1;
  List _imageFileList = [];

  bool isVideo = false;

  set _imageFile(XFile value) {
    _imageFileList = value == null ? null : [value];
  }

  final RoundedLoadingButtonController _btnController1 = RoundedLoadingButtonController();

  String _retrieveDataError;
  final ImagePicker _picker = ImagePicker();

  MaskedTextController textEditingControllerEtiqueta;
  MaskedTextController textEditingControllerDot;
  TextEditingController textEditingControllerModelo;
  TextEditingController textEditingControllerMarca;
  TextEditingController textEditingControllerMedida;
  Carcaca carcaca;

  List<Modelo> modeloList = [];
  Modelo modeloSelected;

  List<Medida> medidaList = [];
  Medida medidaSelected;

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
        _retrieveDataError = e.toString();
      });
    }
  }

  Future<void> _scanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#FF6666', 'Cancelar', true, ScanMode.BARCODE,
      );
    } catch (e) {
      print('Erro ao escanear: $e');
      return;
    }

    if (!mounted || barcodeScanRes == '-1') return;

    final codigoFormatado = barcodeScanRes.padLeft(6, '0');

    setState(() {
      textEditingControllerEtiqueta.text = codigoFormatado;
      carcaca.numeroEtiqueta = codigoFormatado;
    });
  }

  Widget _construirFormulario(context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: textEditingControllerEtiqueta,
                  decoration: InputDecoration(labelText: "Etiqueta"),
                  validator: (value) => value.length == 0 ? 'Não pode ser nulo' : null,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (String newValue) {
                    setState(() {
                      carcaca.numeroEtiqueta = newValue;
                    });
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.qr_code_scanner),
                onPressed: _scanBarcode,
              ),
            ],
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: textEditingControllerDot,
            decoration: InputDecoration(labelText: "Dot"),
            validator: (value) => value.length == 0 ? 'Não pode ser nulo' : null,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (String newValue) {
              setState(() {
                carcaca.dot = newValue;
              });
            },
          ),
          SizedBox(height: 10),
          DropdownButtonFormField(
            decoration: InputDecoration(labelText: "Modelo"),
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
          SizedBox(height: 10),
          DropdownButtonFormField(
            decoration: InputDecoration(labelText: "Medida"),
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
          SizedBox(height: 10),
          DropdownButtonFormField(
            decoration: InputDecoration(labelText: "País"),
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
          SizedBox(height: 10),
          Center(child: showImage(_imageFileList, "adicionar")),
          Padding(
            padding: EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: getImage,
                tooltip: 'Adicionar Imagem',
                child: Icon(Icons.camera_alt),
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/home");
                  },
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: RoundedLoadingButton(
                  color: Colors.black,
                  successIcon: Icons.check,
                  failedIcon: Icons.close,
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ListaCarcaca()),
                        );
                      } else {
                        responseMessage value = response ?? responseMessage();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Atenção!"),
                              content: Text(value.debugMessage ?? "Erro ao salvar"),
                              actions: [
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.pop(context);
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
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carcaça')),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 70.0),
          child: _construirFormulario(context),
        ),
      ),
    );
  }
}

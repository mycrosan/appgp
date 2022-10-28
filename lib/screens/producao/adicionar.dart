import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:GPPremium/models/carcaca.dart';
import 'package:GPPremium/models/matriz.dart';
import 'package:GPPremium/models/medida.dart';
import 'package:GPPremium/models/modelo.dart';
import 'package:GPPremium/models/pais.dart';
import 'package:GPPremium/models/producao.dart';
import 'package:GPPremium/models/regra.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:GPPremium/screens/producao/printWidget.dart';
import 'package:GPPremium/service/carcacaapi.dart';
import 'package:GPPremium/service/matrizapi.dart';
import 'package:GPPremium/service/producaoapi.dart';
import 'package:GPPremium/service/regraapi.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../components/ImagePreview.dart';
import '../../components/OrderData.dart';
import '../../models/responseMessageSimple.dart';
import '../../service/uploadapi.dart';
import 'ListaProducao.dart';

class AdicionarProducaoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AdicionarProducaoPageState();
  }
}

class AdicionarProducaoPageState extends State<AdicionarProducaoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produção'),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 70.0),
            child: _construirFormulario(context)),
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

  void _doSomething(RoundedLoadingButtonController controller) async {
    Timer(Duration(seconds: 10), () {
      controller.success();
    });
  }

  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();

  String _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  TextEditingController textEditingControllerCarcaca;
  MaskedTextController textEditingControllerPneuRaspado;
  TextEditingController textEditingControllerDados;
  TextEditingController textEditingControllerRegra;

  Medida medidaCarcaca;
  Modelo modeloCarcaca;
  Pais paisCarcaca;
  bool mostrarCarcacaSelecionada = false;

  TextEditingController camelBackASerUsado;
  TextEditingController antiquebra1;
  TextEditingController antiquebra2;
  TextEditingController antiquebra3;
  TextEditingController espessuraemnto;
  TextEditingController tempo;

  Producao producao;

  bool idRegra = false;

  String inputMedidaPneuRapspado;

  //Pneu
  List<Carcaca> carcacaList = [];
  Carcaca carcacaSelected;

  //Regra
  List<Matriz> matrizList = [];
  Matriz matrizSelected;

  //Regra
  List<Regra> regraList = [];
  Regra regraSelected;

  @override
  void initState() {
    super.initState();
    textEditingControllerCarcaca = MaskedTextController(mask: '000000');
    textEditingControllerPneuRaspado = MaskedTextController(mask: '0.000');
    textEditingControllerDados = TextEditingController();
    textEditingControllerRegra = TextEditingController();
    producao = Producao();

    camelBackASerUsado = TextEditingController();
    antiquebra1 = TextEditingController();
    antiquebra2 = TextEditingController();
    antiquebra3 = TextEditingController();
    espessuraemnto = TextEditingController();
    tempo = TextEditingController();

    CarcacaApi().getAll().then((List<Carcaca> value) {
      setState(() {
        carcacaList = value;
        alfabetSortList(carcacaList);
      });
    });

    MatrizApi().getAll().then((List<Matriz> value) {
      setState(() {
        matrizList = value;
        alfabetSortList(matrizList);
      });
    });

    RegraApi().getAll().then((List<Regra> value) {
      setState(() {
        regraList = value;
      });
    });
    // _btnController1.stateStream.listen((value) {
    //   print(value);
    //
    // });
  }

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
    var producaoApi = new ProducaoApi();
    return Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            controller: textEditingControllerCarcaca,
            decoration: InputDecoration(
              labelText: "Carcaça",
            ),
            validator: (value) =>
                value.length == 0 ? 'Não pode ser nulo' : null,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (String newValue) async {
              setState(() {
                producao.carcaca = null;
                medidaCarcaca = null;
                modeloCarcaca = null;
                paisCarcaca = null;
                mostrarCarcacaSelecionada = false;
              });
              if (newValue.length >= 6) {
                var response = await CarcacaApi().consultaCarcaca(newValue);
                if (response is Carcaca && response != null) {
                  setState(() {
                    producao.carcaca = response;
                    medidaCarcaca = response.medida;
                    modeloCarcaca = response.modelo;
                    paisCarcaca = response.pais;
                    mostrarCarcacaSelecionada = true;
                  });
                } else {
                  responseMessage value = response;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(value.message),
                        content: Text(value.debugMessage),
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
              }
            },
          ),
          Container(
            child: mostrarCarcacaSelecionada
                ? Card(
                    child: ListTile(
                      title: Text('Etiqueta: ' +
                          producao.carcaca.numeroEtiqueta.toString()),
                      subtitle: Text('Medida: ' +
                          medidaCarcaca.descricao +
                          ' DOT: ' +
                          producao.carcaca.dot +
                          ' Modelo: ' +
                          modeloCarcaca.descricao +
                          ' Pais: ' +
                          paisCarcaca.descricao),
                    ),
                  )
                : Text('Sem carcaça'),
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "Matriz",
            ),
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            value: matrizSelected,
            isExpanded: true,
            onChanged: (Matriz matriz) {
              // var regra = regraList.firstWhere((regra) => regra.id == matriz.id);
              setState(() {
                matrizSelected = matriz;
              });
            },
            items: matrizList.map((Matriz matriz) {
              return DropdownMenuItem(
                value: matriz,
                child: Text(matriz.descricao),
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          TextFormField(
            controller: textEditingControllerPneuRaspado,
            decoration: InputDecoration(
              labelText: "Medida pneu raspado",
            ),
            validator: (value) =>
                value.length == 0 ? 'Não pode ser nulo' : null,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (String newValue) async {
              if (newValue.length >= 5) {
                if (_formkey.currentState.validate()) {
                  regraSelected = null;
                  var response = await RegraApi().consultaRegra(
                      matrizSelected,
                      medidaCarcaca,
                      modeloCarcaca,
                      paisCarcaca,
                      double.parse(newValue));
                  if (response is Regra && response != null) {
                    setState(() {
                      regraSelected = response;
                      producao.medidaPneuRaspado = double.parse(newValue);
                      producao.regra = regraSelected;
                    });
                  } else {
                    responseMessage value = response;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(value.message),
                          content: Text(value.debugMessage),
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
                }
              }
              setState(() {
                inputMedidaPneuRapspado = newValue;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          Container(
            child: (regraSelected != null)
                ? _exibirRegra(regraSelected)
                : Text("Sem regra"),
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
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
                    child:
                        Text('Salvar!', style: TextStyle(color: Colors.white)),
                    controller: _btnController1,
                    onPressed: () async {
                      if (_formkey.currentState.validate()) {
                        Map<String, String> body = {
                          'title': 'producao',
                        };
                        responseMessageSimple imageResponse =
                            await UploadApi().addImage(body, _imageFileList);

                        print(imageResponse.content[0]);
                        producao.fotos = json.encode(imageResponse.content);

                        var response = await producaoApi.create(producao);

                        if (response is Producao && response != null) {
                          _btnController1.success();

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Imprimir?"),
                                content:
                                    Text("Quer ir para tela de impressão?"),
                                actions: [
                                  ElevatedButton(
                                    child: Text("Sim"),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PrintPage(
                                                    producaoPrint: producao,
                                                  )));
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text("Não"),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ListaProducao(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
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
                                          builder: (context) => ListaProducao(),
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
                      }
                    }),
              ),
            ],
          )
        ],
      ),
    );
  }
}

Widget _exibirRegra(context) {
  //todo não funciona, montar isso reativo

  return Card(
    child: ListTile(
      title: Text(
        'Matriz: ' + context.matriz.descricao,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      subtitle: Wrap(
        children: [
          Text.rich(TextSpan(
              text: 'Medida: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.medida.descricao,
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
          Padding(
            padding: EdgeInsets.all(3),
          ),
          Text.rich(TextSpan(
              text: 'Marca: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.modelo.marca.descricao,
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
          Padding(
            padding: EdgeInsets.all(3),
          ),
          Text.rich(TextSpan(
              text: 'Modelo: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.modelo.descricao,
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
          Padding(
            padding: EdgeInsets.all(3),
          ),
          Text.rich(TextSpan(
              text: 'País: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.pais.descricao,
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
          Padding(
            padding: EdgeInsets.all(3),
          ),
          Text.rich(TextSpan(
              text: 'Camelback: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.camelback.descricao,
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
          Text.rich(TextSpan(
              text: 'COD: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.id.toString(),
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
          Padding(
            padding: EdgeInsets.all(3),
          ),
          Text.rich(TextSpan(
              text: 'Min: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.tamanhoMin.toString(),
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
          Padding(
            padding: EdgeInsets.all(3),
          ),
          Text.rich(TextSpan(
              text: 'Máx: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.tamanhoMax.toString(),
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
        ],
      ),
    ),
  );

  return Container(
    child: (context.regraSelected != null)
        ? Text("ID:" +
            context.id.toString() +
            "\n"
                "Medida: " +
            context.regraSelected.medida.descricao +
            "\n"
                "Camelback: " +
            context.regraSelected.camelback.toString() +
            "\n"
                "Espessuramento: " +
            context.regraSelected.espessuramento +
            "\n"
                "Tempo: " +
            context.regraSelected.tempo +
            "\n"
                "Matriz: " +
            context.regraSelected.matriz.descricao +
            "\n"
                "Antiquebra: " +
            context.regraSelected.antiquebra1 +
            "\n"
                "Min: " +
            context.regraSelected.tamanhoMin.toString() +
            "\n"
                "Max: " +
            context.regraSelected.tamanhoMax.toString() +
            "\n")
        : null,
  );
}

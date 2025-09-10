import 'dart:async';
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../components/ImagePreview.dart';
import '../../components/snackBar.dart';
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
  //PRINT SERVICE
  Future<void> printEtiqueta(NetworkPrinter printer, Producao producao) async {
    // Print image
    // final ByteData data = await rootBundle.load('assets/images/banner.png');
    // final Uint8List bytes = data.buffer.asUint8List();
    // final Image image = decodeImage(bytes);
    // printer.image(image);
    printer.row([
      PosColumn(text: 'Cod. da etiqueta', width: 5),
      PosColumn(
          text: producao.carcaca.numeroEtiqueta,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size3,
            width: PosTextSize.size3,
            bold: true,
          ),
          width: 7),
    ]);
    printer.hr(ch: '-');
    printer.text('Matriz', styles: PosStyles(align: PosAlign.center));
    printer.text(producao.regra.matriz.descricao,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
          bold: true,
        ),
        linesAfter: 1);

    printer.hr(ch: '-');
    printer.text('Camelback', styles: PosStyles(align: PosAlign.left));
    printer.text(producao.regra.camelback.descricao,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size4,
          width: PosTextSize.size4,
          bold: true,
        ),
        linesAfter: 1);

    printer.hr(ch: '-');
    printer.text('Anti quebra 1', styles: PosStyles(align: PosAlign.left));
    printer.text(producao.regra.antiquebra1.descricao,
        styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
          bold: true,
        ),
        linesAfter: 1);

    printer.hr(ch: '-');
    printer.text('Anti quebra 2', styles: PosStyles(align: PosAlign.left));
    printer.text(producao.regra.antiquebra2.descricao,
        styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
          bold: true,
        ),
        linesAfter: 1);

    printer.hr(ch: '-');
    printer.text('Anti quebra 3', styles: PosStyles(align: PosAlign.left));
    printer.text(producao.regra.antiquebra3.descricao,
        styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
          bold: true,
        ),
        linesAfter: 1);

    printer.hr(ch: '-');
    printer.text('Espessuramento', styles: PosStyles(align: PosAlign.left));
    printer.text(producao.regra.espessuramento.descricao,
        styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
          bold: true,
        ),
        linesAfter: 1);

    printer.hr(ch: '-');
    printer.text('Tempo', styles: PosStyles(align: PosAlign.left));
    printer.text(producao.regra.tempo,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size8,
          width: PosTextSize.size8,
          bold: true,
        ),
        linesAfter: 1);
    printer.hr(ch: '-');
    printer.text('Modelo', styles: PosStyles(align: PosAlign.left));
    printer.text(producao.carcaca.modelo.descricao,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
          bold: true,
        ),
        linesAfter: 1);

    printer.cut();
  }

  void configAndPrint(
      String printerIp, BuildContext ctx, Producao producao) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    final PosPrintResult res = await printer.connect(printerIp, port: 9100);
    if (res == PosPrintResult.success) {
      await printEtiqueta(printer, producao);
      printer.disconnect();
    }
    ScaffoldMessenger.of(context).showSnackBar(
        successMessage(context, "Resultado da impressão: " + res.msg));
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
      });
    });

    MatrizApi().getAll().then((List<Matriz> value) {
      setState(() {
        matrizList = value;
      });
    });

    RegraApi().getAll().then((List<Regra> value) {
      setState(() {
        regraList = value;
      });
    });
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
      } else {
        isVideo = false;
        setState(() {
          _imageFileList = response.files;
        });
      }
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  Text _getRetrieveErrorWidget() {
    final Text result = Text(_retrieveDataError);
    _retrieveDataError = null;
    return result;
    return null;
  }

  // NOVO MÉTODO: Leitura do código de barras
  Future<void> scanBarcode() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.BARCODE);
      if (!mounted) return;
      if (barcodeScanRes != '-1') {
        // Completa com zeros à esquerda até 6 dígitos
        String codigoComZeros = barcodeScanRes.padLeft(6, '0');
        // Atualiza o campo e dispara a busca
        textEditingControllerCarcaca.text = codigoComZeros;
        var response = await CarcacaApi().consultaCarcaca(codigoComZeros);
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
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao ler código de barras.')));
    }
  }

  Future<void> _consultaCarcaca(String codigo) async {
    setState(() {
      producao.carcaca = null;
      medidaCarcaca = null;
      modeloCarcaca = null;
      paisCarcaca = null;
      mostrarCarcacaSelecionada = false;
    });
    if (codigo.length >= 6) {
      var response = await CarcacaApi().consultaCarcaca(codigo);
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
  }

  Widget _construirFormulario(context) {
    var producaoApi = new ProducaoApi();
    return Form(
      key: _formkey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: textEditingControllerCarcaca,
                  decoration: InputDecoration(
                    labelText: "Carcaça",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.qr_code_scanner),
                      onPressed: () async {
                        await scanBarcode();
                      },
                    ),
                  ),
                  validator: (value) =>
                      value.length == 0 ? 'Não pode ser nulo' : null,
                  keyboardType: TextInputType.number,
                  onChanged: (String newValue) async {
                    setState(() {
                      producao.carcaca = null;
                      medidaCarcaca = null;
                      modeloCarcaca = null;
                      paisCarcaca = null;
                      mostrarCarcacaSelecionada = false;
                    });

                    if (newValue.length == 6) {
                      var response =
                          await CarcacaApi().consultaCarcaca(newValue);
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
              ),
            ],
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
          DropdownSearch<Matriz>(
            mode: Mode.BOTTOM_SHEET,
            showSearchBox: true,
            isFilteredOnline: false,
            dropdownBuilder: (context, selectedItem) {
              return Text(
                selectedItem?.descricao ?? "Selecione",
                style: const TextStyle(fontSize: 16),
              );
            },
            popupItemBuilder: (context, item, isSelected) {
              return ListTile(
                title: Text(item.descricao),
              );
            },
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            items: matrizList,
            selectedItem: matrizSelected,
            itemAsString: (Matriz m) => m.descricao,
            onChanged: (Matriz matriz) {
              setState(() {
                matrizSelected = matriz;
              });
            },
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

                        producao.fotos = json.encode(imageResponse.content);

                        var response = await ProducaoApi().create(producao);

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
                                      _btnController1.reset();
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
                                  ElevatedButton(
                                    child: Text("Imprimir direto"),
                                    onPressed: () {
                                      this.configAndPrint(
                                          '192.168.0.31', context, producao);
                                      Navigator.pop(context);
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
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        _btnController1
                            .reset(); // <- ESSA LINHA FAZ O BOTÃO VOLTAR
                      }
                    }),
              ),
            ],
          )
        ],
      ),
    );
  }

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
}

Widget _exibirRegra(Regra context) {
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
          Padding(padding: EdgeInsets.all(3)),
          Text.rich(TextSpan(
              text: 'Marca: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.modelo.marca.descricao,
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
          Padding(padding: EdgeInsets.all(3)),
          Text.rich(TextSpan(
              text: 'Modelo: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.modelo.descricao,
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
          Padding(padding: EdgeInsets.all(3)),
          Text.rich(TextSpan(
              text: 'País: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.pais.descricao,
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
          Padding(padding: EdgeInsets.all(3)),
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
          Padding(padding: EdgeInsets.all(3)),
          Text.rich(TextSpan(
              text: 'Min: ',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: context.tamanhoMin.toString(),
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ])),
          Padding(padding: EdgeInsets.all(3)),
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
}

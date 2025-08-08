import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:GPPremium/models/producao.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../components/dateFormatPtBr.dart';
import '../../models/cobertura.dart';
import '../../models/responseMessage.dart';
import '../../models/responseMessageSimple.dart';
import '../../service/coberturaapi.dart';
import '../../service/get_image.dart';
import '../../service/uploadapi.dart';

class ListaCobertura extends StatefulWidget {
  @override
  _ConsultaProducaoEtiquetaPageState createState() =>
      _ConsultaProducaoEtiquetaPageState();
}

class _ConsultaProducaoEtiquetaPageState extends State<ListaCobertura> {
  final _etiquetaController = TextEditingController();
  Producao _producao;
  bool _carregando = false;
  String _erro = '';
  final ImagePicker _picker = ImagePicker();
  List _imageFileList = [];
  String _retrieveDataError;
  final RoundedLoadingButtonController _btnController1 =
  RoundedLoadingButtonController();

  final _formkey = GlobalKey<FormState>();
  Cobertura cobertura = Cobertura();

  Future<void> _scanBarcode() async {
    String etiqueta = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancelar', true, ScanMode.BARCODE);

    if (etiqueta != '-1') {
      etiqueta = etiqueta.padLeft(6, '0').substring(0, 6);
      _etiquetaController.text = etiqueta;
      await _buscarProducao(etiqueta);
    }
  }

  Future getImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 25,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFileList.add(pickedFile);
        });
      }
    } catch (e) {
      setState(() {
        _retrieveDataError = e.toString();
      });
    }
  }

  Future<void> _buscarProducao(String etiqueta) async {
    if (etiqueta == null || etiqueta.trim().isEmpty || etiqueta.length != 6) {
      setState(() {
        _erro = 'Informe uma etiqueta com exatamente 6 dígitos.';
      });
      return;
    }

    setState(() {
      _carregando = true;
      _erro = '';
      _producao = null;
      cobertura = Cobertura(); // limpa cobertura
    });

    try {
      var apiCobertura = CoberturaApi();
      var resultado =
      await apiCobertura.getByEtiqueta(etiqueta.padLeft(6, '0'));

      if (resultado is Cobertura && resultado.producao != null) {
        setState(() {
          cobertura = resultado;
          _producao = resultado.producao;
        });
      } else if (resultado is Producao) {
        setState(() {
          cobertura = Cobertura();
          _producao = resultado;
        });
      } else {
        setState(() {
          _erro =
          'Nenhuma cobertura ou produção encontrada para a etiqueta informada';
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _erro = 'Erro ao buscar por etiqueta: $e';
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  Widget _buildImagensCoberturaSalva(bool coberturaJaExiste) {
    if (cobertura.fotos == null || cobertura.fotos.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 16),
      height: 200.0,
      child: FutureBuilder(
        future: ImageService().showImage(cobertura.fotos, "cobertura"),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data.length > 0) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext ctxt, int index) {
                final imageWidget = snapshot.data[index];

                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              backgroundColor: Colors.black,
                              insetPadding: EdgeInsets.all(10),
                              child: InteractiveViewer(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: imageWidget,
                                ),
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 140,
                            height: 180,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: 140,
                                height: 180,
                                child: imageWidget,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!coberturaJaExiste) // só mostra remover se for nova
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () async {
                            bool confirmed = await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Remover imagem'),
                                content: Text('Deseja realmente remover esta imagem?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar')),
                                  TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Remover')),
                                ],
                              ),
                            );

                            if (confirmed == true) {
                              List<String> listaFotos = List<String>.from(json.decode(cobertura.fotos));
                              setState(() {
                                listaFotos.removeAt(index);
                              });
                              cobertura.fotos = json.encode(listaFotos);
                              await CoberturaApi().update(cobertura);
                            }
                          },
                          child: Icon(Icons.cancel, color: Colors.red),
                        ),
                      ),
                  ],
                );
              },
            );
          } else {
            return Center(child: Text("Nenhuma imagem encontrada."));
          }
        },
      ),
    );
  }

  Widget _buildCardProducao() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'ETIQUETA',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            SizedBox(height: 12),
            Center(
              child: Text(
                _producao.carcaca.numeroEtiqueta ?? '-',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(height: 28, thickness: 1),
            Text('MEDIDA: ${_producao.carcaca.medida?.descricao ?? '-'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(
                'FABRICADO EM: ${formatarDataHoraBrasil(_producao.dtCreate) ?? '-'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('RESPONSÁVEL: ${_producao.criadoPor.nome ?? '---'}',
                style: TextStyle(fontSize: 16)),
            Divider(height: 28, thickness: 1),
            Text('CAMELBACK',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              _producao.regra.camelback?.descricao ?? '-',
              style: TextStyle(fontSize: 18),
            ),
            Divider(height: 28, thickness: 1),
            Text('ESPESSURAMENTO',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              _producao.regra.espessuramento?.descricao ?? '-',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _etiquetaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool coberturaJaExiste = cobertura != null && cobertura.id != null;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text("Cobertura")),
            Expanded(
              child: Container(
                height: 30.0,
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _etiquetaController,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          hintText: 'Etiqueta',
                          contentPadding: EdgeInsets.all(12.0),
                        ),
                        keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        onChanged: (value) async {
                          if (value.length >= 6) {
                            String codigoFormatado = value.padLeft(6, '0');
                            FocusScope.of(context).unfocus();
                            await _buscarProducao(codigoFormatado);
                          } else {
                            setState(() {
                              _producao = null;
                              cobertura = Cobertura();
                              _erro = '';
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.qr_code_scanner,
                            size: 20, color: Colors.black),
                        onPressed: _scanBarcode,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            _carregando
                ? Center(child: CircularProgressIndicator())
                : _erro.isNotEmpty
                ? Text(_erro, style: TextStyle(color: Colors.red))
                : _producao != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardProducao(),
                _buildImagensCoberturaSalva(coberturaJaExiste),
              ],
            )
                : SizedBox(),
            SizedBox(height: 16),
            if (_imageFileList.isNotEmpty)
              Container(
                height: 200.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imageFileList.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(6.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(File(_imageFileList[index].path)),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _imageFileList.removeAt(index);
                              });
                            },
                            child: Icon(Icons.cancel, color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: coberturaJaExiste
          ? null
          : Stack(
        children: [
          Positioned(
            bottom: 16,
            left: 46,
            child: FloatingActionButton(
              heroTag: 'camera',
              backgroundColor: Colors.blue,
              onPressed: getImage,
              tooltip: 'Adicionar Imagem',
              child: Icon(Icons.camera_alt),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'salvar',
              backgroundColor: Colors.black,
              child: Icon(Icons.save),
              onPressed: () async {
                if (_imageFileList.isNotEmpty && _producao != null) {
                  _btnController1.start();
                  try {
                    Map<String, String> body = {'title': 'cobertura'};
                    responseMessageSimple imageResponse =
                    await UploadApi().addImage(body, _imageFileList);

                    List<String> fotosExistentes = [];
                    if (cobertura.fotos != null &&
                        cobertura.fotos.isNotEmpty) {
                      fotosExistentes =
                      List<String>.from(json.decode(cobertura.fotos));
                    }

                    List<String> fotosNovas =
                    List<String>.from(imageResponse.content);

                    List<String> fotosAtualizadas = [
                      ...fotosExistentes,
                      ...fotosNovas
                    ];

                    cobertura.fotos = json.encode(fotosAtualizadas);
                    cobertura.producao = Producao(id: _producao.id);

                    var response =
                    await CoberturaApi().create(cobertura);

                    if (response is Cobertura && response.id != null) {
                      _btnController1.success();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Cobertura salva com sucesso!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      await Future.delayed(Duration(seconds: 1));
                      Navigator.of(context)
                          .popUntil((route) => route.isFirst);
                    } else if (response is responseMessage) {
                      _btnController1.reset();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Erro ao salvar"),
                            content: Text(response.debugMessage ??
                                "Erro inesperado ao salvar"),
                            actions: [
                              TextButton(
                                child: Text("OK"),
                                onPressed: () =>
                                    Navigator.pop(context),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      _btnController1.reset();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Erro inesperado ao salvar cobertura."),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    _btnController1.reset();
                    print('Erro durante o salvamento da cobertura: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Erro interno ao salvar."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  _btnController1.reset();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Adicione imagens e selecione uma produção.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

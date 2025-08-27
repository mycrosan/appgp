import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:GPPremium/models/producao.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../components/dateFormatPtBr.dart';
import '../../models/cobertura.dart';
import '../../models/cola.dart';
import '../../models/responseMessage.dart';
import '../../models/responseMessageSimple.dart';
import '../../models/usuario.dart';
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
  String _mensagemBackend = '';
  final ImagePicker _picker = ImagePicker();
  List _imageFileList = [];
  String _retrieveDataError;
  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();
  bool _colaValida = false;
  Usuario _usuario;
  Cola _cola;
  Cobertura cobertura = Cobertura();

  // ------------------------- BUSCA PRODUÇÃO -------------------------
  Future<void> _scanBarcode() async {
    String etiqueta = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancelar', true, ScanMode.BARCODE);
    if (etiqueta != '-1') {
      etiqueta = etiqueta.padLeft(6, '0').substring(0, 6);
      _etiquetaController.text = etiqueta;
      await _buscarProducao(etiqueta);
    }
  }

  Future<void> _buscarProducao(String etiqueta) async {
    if (etiqueta.trim().isEmpty || etiqueta.length != 6) {
      setState(() {
        _erro = 'Informe uma etiqueta com exatamente 6 dígitos.';
        _mensagemBackend = '';
      });
      return;
    }

    setState(() {
      _carregando = true;
      _erro = '';
      _mensagemBackend = '';
      _producao = null;
      cobertura = Cobertura();
      _colaValida = false;
      _usuario = Usuario();
      _imageFileList.clear();
    });

    try {
      var apiCobertura = CoberturaApi();
      var resultado =
          await apiCobertura.getByEtiqueta(etiqueta.padLeft(6, '0'));

      if (resultado is Map &&
          resultado.containsKey('statusCode') &&
          resultado['statusCode'] >= 400) {
        setState(() {
          _erro =
              resultado['message'] ?? 'Erro desconhecido ao buscar etiqueta.';
        });
        return;
      }

      if (resultado.isNotEmpty) {
        final producaoMap = resultado['producao'];
        final coberturaMap = resultado['cobertura'];
        final mensagem = resultado['mensagem'] ?? '';
        final colaValida = resultado['colaValida'] ?? false;
        final usuarioMap = resultado['usuario'];
        final colaMap = resultado['cola'];

        setState(() {
          _colaValida = colaValida;
          _mensagemBackend = mensagem;

          if (usuarioMap != null) _usuario = Usuario.fromJson(usuarioMap);
          if (producaoMap != null) _producao = Producao.fromJson(producaoMap);
          if (coberturaMap != null)
            cobertura = Cobertura.fromJson(coberturaMap);
          if (colaMap != null) _cola = Cola.fromJson(colaMap);
        });
      } else {
        setState(() {
          _erro = 'Nenhuma produção encontrada para a etiqueta.';
        });
      }
    } catch (e) {
      setState(() {
        _erro = 'Erro ao buscar por etiqueta: $e';
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  // ------------------------- CAPTURA DE IMAGEM -------------------------
  Future<void> getImage() async {
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

  // ------------------------- CARD PRODUÇÃO -------------------------
  Widget _buildCardProducao() {
    if (_producao == null) return SizedBox.shrink();

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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
            Text('RESPONSÁVEL: ${_usuario.nome ?? '---'}',
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
            Divider(height: 28, thickness: 1),
            if (_mensagemBackend.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _mensagemBackend,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: (_mensagemBackend.toLowerCase().contains('inválida'))
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

// ------------------------- EXIBIÇÃO DE IMAGENS SALVAS -------------------------
  Widget _buildImagensCoberturaSalva() {
    if (cobertura.fotos == null || cobertura.fotos.isEmpty || cobertura.fotos == '[]') {
      return SizedBox.shrink();
    }

    return FutureBuilder(
      future: ImageService().showImage(cobertura.fotos, "cobertura"),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Erro ao carregar imagens');
        } else if (!snapshot.hasData || snapshot.data.isEmpty) {
          return SizedBox.shrink();
        } else if (snapshot.data is responseMessage) {
          return Text(snapshot.data.message ?? "Erro desconhecido");
        } else {
          List<Image> imagens = [];
          for (var item in snapshot.data) {
            if (item is Image) {
              imagens.add(item);
            }
          }

          if (imagens.isEmpty) return SizedBox.shrink();

          return Container(
            height: 200.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imagens.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        insetPadding: EdgeInsets.all(10),
                        backgroundColor: Colors.transparent,
                        child: InteractiveViewer(
                          child: imagens[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(6.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: imagens[index],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }





  // ------------------------- BUILD -------------------------
  @override
  Widget build(BuildContext context) {
    bool coberturaJaExiste = cobertura.id != null &&
        cobertura.fotos != null &&
        cobertura.fotos.isNotEmpty &&
        cobertura.fotos != '[]';

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
                              _mensagemBackend = '';
                              _imageFileList.clear();
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
                              if (coberturaJaExiste)
                                _buildImagensCoberturaSalva(),
                              if (!coberturaJaExiste &&
                                  _imageFileList.isNotEmpty)
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
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.file(File(
                                                  _imageFileList[index].path)),
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _imageFileList
                                                      .removeAt(index);
                                                });
                                              },
                                              child: Icon(Icons.cancel,
                                                  color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                            ],
                          )
                        : SizedBox(),
          ],
        ),
      ),
      floatingActionButton: (_colaValida && !coberturaJaExiste)
          ? Stack(
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

                          if (_cola == null || _cola.id == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("Nenhuma cola válida encontrada."),
                                backgroundColor: Colors.red,
                              ),
                            );
                            _btnController1.reset();
                            return;
                          }

                          cobertura.fotos = json.encode(fotosAtualizadas);
                          cobertura.cola = Cola(id: _cola.id);

                          var resp = await CoberturaApi().create(cobertura);

                          if (resp is Cobertura && resp.id != null) {
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
                          } else if (resp is responseMessage) {
                            _btnController1.reset();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Erro ao salvar"),
                                  content: Text(resp.debugMessage ??
                                      "Erro inesperado ao salvar"),
                                  actions: [
                                    TextButton(
                                      child: Text("OK"),
                                      onPressed: () => Navigator.pop(context),
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
            )
          : null,
    );
  }

  @override
  void dispose() {
    _etiquetaController.dispose();
    super.dispose();
  }
}

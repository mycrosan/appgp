import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:GPPremium/models/producao.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/ImagePreview.dart';
import '../../components/dateFormatPtBr.dart';
import '../../models/carcaca.dart';
import '../../service/producaoapi.dart';

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
      setState(() {
        _imageFileList.add(pickedFile);
      });
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
    });

    try {
      var api = ProducaoApi();
      var filtro = Producao();
      filtro.carcaca = Carcaca();
      filtro.carcaca.numeroEtiqueta = etiqueta.padLeft(6, '0');

      var resultado = await api.consultaProducao(filtro);
      if (resultado is List && resultado.length > 0) {
        setState(() {
          _producao = resultado[0];
        });
      } else {
        setState(() {
          _erro = 'Produção não encontrada.';
        });
      }
    } catch (e) {
      setState(() {
        _erro = 'Erro ao buscar produção: $e';
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta Cobertura'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _etiquetaController,
                      decoration: InputDecoration(
                        labelText: 'Nº Etiqueta',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.qr_code_scanner),
                          onPressed: _scanBarcode,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      onFieldSubmitted: (value) {
                        final etiqueta = value.padLeft(6, '0').substring(0, 6);
                        _etiquetaController.text = etiqueta;
                        _buscarProducao(etiqueta);
                      },
                    ),
                    SizedBox(height: 16),
                    _carregando
                        ? Center(child: CircularProgressIndicator())
                        : _erro.isNotEmpty
                        ? Text(_erro, style: TextStyle(color: Colors.red))
                        : _producao != null
                        ? _buildCardProducao()
                        : SizedBox(),
                    SizedBox(height: 16),
                    Center(child: showImage(_imageFileList, "adicionar")),
                    SizedBox(height: 80), // espaço pro FAB
                  ],
                ),
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: getImage,
        tooltip: 'Adicionar Imagem',
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}

// Widget para exibir imagens horizontalmente com rolagem
Widget showImage(imageFileList, String place) {
  if (imageFileList.length > 0) {
    return Container(
      height: 450.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageFileList.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            child: InteractiveViewer(
              clipBehavior: Clip.none,
              child: AspectRatio(
                aspectRatio: 0.75,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: place == "adicionar"
                      ? Image.file(File(imageFileList[index].path))
                      : imageFileList[index],
                ),
              ),
            ),
          );
        },
      ),
    );
  } else {
    return SizedBox(); // Não exibe nada se não houver imagem
  }
}

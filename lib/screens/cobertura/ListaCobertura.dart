import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:GPPremium/models/producao.dart';
import '../../components/dateFormatPtBr.dart';
import '../../models/carcaca.dart';
import '../../service/producaoapi.dart';

class ListaCobertura extends StatefulWidget {
  @override
  _ConsultaProducaoEtiquetaPageState createState() => _ConsultaProducaoEtiquetaPageState();
}

class _ConsultaProducaoEtiquetaPageState extends State<ListaCobertura> {
  final _etiquetaController = TextEditingController();
  Producao _producao;
  bool _carregando = false;
  String _erro = '';

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
      filtro.carcaca = Carcaca(); // <-- importante
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Etiqueta: ${_producao.carcaca.numeroEtiqueta ?? '-'}'),
            SizedBox(height: 8),
            Text('Modelo: ${_producao.carcaca.modelo?.descricao ?? '-'}'),
            Text('Marca: ${_producao.carcaca.modelo?.marca?.descricao ?? '-'}'),
            Text('Medida: ${_producao.carcaca.medida?.descricao ?? '-'}'),
            Text('País: ${_producao.carcaca.pais?.descricao ?? '-'}'),
            Text('Fabricado em: ${formatarDataHoraBrasil(_producao.dtCreate) ?? '-'}'),
            SizedBox(height: 8),
            Text('Responsável: ${_producao.criadoPor.nome ?? '---'}'),
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
        title: Text('Consulta Produção'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
                ? CircularProgressIndicator()
                : _erro.isNotEmpty
                ? Text(_erro, style: TextStyle(color: Colors.red))
                : _producao != null
                ? _buildCardProducao()
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

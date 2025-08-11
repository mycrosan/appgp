import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../../models/producao.dart';
import '../../models/cola.dart';
import '../../service/producaoapi.dart';
import '../../service/colaapi.dart';
import '../../components/dateFormatPtBr.dart';

class ListaColaPage extends StatefulWidget {
  @override
  State<ListaColaPage> createState() => _ListaColaPageState();
}

class _ListaColaPageState extends State<ListaColaPage> {
  final _etiquetaController = TextEditingController();
  List<Cola> _itensCola = [];
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _carregarCola();
    // Atualiza a lista automaticamente a cada minuto
    _timer = Timer.periodic(Duration(minutes: 1), (_) async {
      await _carregarCola();
    });
  }

  @override
  void dispose() {
    _etiquetaController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String _formatarEtiqueta(String etiqueta) {
    etiqueta = etiqueta.trim();
    if (etiqueta.length > 6) {
      etiqueta = etiqueta.substring(0, 6);
    }
    return etiqueta.padLeft(6, '0');
  }

  Future<void> _scanBarcode() async {
    try {
      String etiqueta = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancelar', true, ScanMode.BARCODE,
      );
      if (etiqueta != '-1' && etiqueta.isNotEmpty) {
        await _adicionarCola(_formatarEtiqueta(etiqueta));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao ler código de barras')),
      );
    }
  }

  Future<void> _adicionarCola(String etiqueta) async {
    if (etiqueta.isEmpty || etiqueta.length != 6) return;

    // Busca cola já cadastrada para essa etiqueta
    var colaExistente = await ColaApi().getByEtiqueta(etiqueta);

    if (colaExistente is Cola) {
      // Atualiza dataInicio para o horário atual
      colaExistente.dataInicio = DateTime.now();

      // Atualiza a cola no backend
      await ColaApi().update(colaExistente);

      await _carregarCola();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cola atualizada com sucesso!')),
      );
    } else {
      // Não existe cola, busca a produção para criar nova cola
      var producao = await ColaApi().getByEtiqueta(etiqueta);
      if (producao is Producao) {
        Cola nova = Cola(producao: producao);
        await ColaApi().create(nova);
        await _carregarCola();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Etiqueta adicionada com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Etiqueta não encontrada na produção')),
        );
      }
    }
  }


  Future<void> _carregarCola() async {
    var lista = await ColaApi().getAll();
    if (lista is List<Cola>) {
      setState(() {
        _itensCola = lista;
      });
    }
  }

  Color _corStatus(DateTime inicio) {
    final minutos = DateTime.now().difference(inicio).inMinutes;
    if (minutos < 20) return Colors.red.shade300;
    if (minutos <= 120) return Colors.green.shade400;
    return Colors.grey.shade400; // vencido
  }

  String _textoStatus(DateTime inicio) {
    final minutos = DateTime.now().difference(inicio).inMinutes;
    if (minutos < 20) return "Aguardando";
    if (minutos <= 120) return "Pronto";
    return "Vencido";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text("Processo de Cola")),
            Expanded(
              child: Container(
                height: 30,
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
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        onFieldSubmitted: (value) async {
                          if (value.isNotEmpty) {
                            await _adicionarCola(_formatarEtiqueta(value));
                            _etiquetaController.clear();
                          }
                        },
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.qr_code_scanner, size: 20, color: Colors.black),
                      onPressed: _scanBarcode,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _carregarCola,
        child: ListView.builder(
          itemCount: _itensCola.length,
          itemBuilder: (context, index) {
            final item = _itensCola[index];
            return Card(
              key: ValueKey(item.id),
              color: _corStatus(item.dataInicio),
              child: ListTile(
                title: Text(item.producao.carcaca.numeroEtiqueta ?? ''),
                subtitle: Text(
                  "Início: ${formatarDataHoraBrasil(item.dataInicio)}\n"
                      "Status: ${_textoStatus(item.dataInicio)}",
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

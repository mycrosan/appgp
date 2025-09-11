import 'package:intl/intl.dart';
import 'package:GPPremium/models/producao.dart';
import 'package:GPPremium/service/producaoapi.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:ionicons/ionicons.dart';

import '../../components/ImagePreview.dart';
import '../../components/snackBar.dart';
import '../../models/responseMessage.dart';
import '../../service/get_image.dart';
import 'printWidget.dart';

class DetalhesProducaoPage extends StatefulWidget {
  final Producao producao;

  const DetalhesProducaoPage({Key key, this.producao}) : super(key: key);

  @override
  State<DetalhesProducaoPage> createState() => _DetalhesProducaoPageState();
}

class _DetalhesProducaoPageState extends State<DetalhesProducaoPage> {
  // ======== Funções de impressão (não alterei muito) ========
  Future<void> printEtiqueta(NetworkPrinter printer) async {
    // Print image
    // final ByteData data = await rootBundle.load('assets/images/banner.png');
    // final Uint8List bytes = data.buffer.asUint8List();
    // final Image image = decodeImage(bytes);
    // printer.image(image);
    printer.row([
      PosColumn(text: 'Cod. da etiqueta', width: 5),
      PosColumn(text: this.widget.producao.carcaca.numeroEtiqueta, styles: PosStyles(
        align: PosAlign.right,
        height: PosTextSize.size3,
        width: PosTextSize.size3,
        bold: true,
      ), width: 7),
    ]);
    printer.hr(ch: '-');
    printer.text('Matriz', styles: PosStyles(align: PosAlign.center));
    printer.text(this.widget.producao.regra.matriz.descricao,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
          bold: true,
        ),
        linesAfter: 1);

    printer.hr(ch: '-');
    printer.text('Camelback', styles: PosStyles(align: PosAlign.left));
    printer.text(this.widget.producao.regra.camelback.descricao,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size4,
          width: PosTextSize.size4,
          bold: true,
        ),
        linesAfter: 1);

    printer.hr(ch: '-');
    printer.text('Anti quebra 1', styles: PosStyles(align: PosAlign.left));
    printer.text(this.widget.producao.regra.antiquebra1.descricao,
        styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
          bold: true,
        ),
        linesAfter: 1);

    printer.hr(ch: '-');
    printer.text('Anti quebra 2', styles: PosStyles(align: PosAlign.left));
    printer.text(this.widget.producao.regra.antiquebra2.descricao,
        styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
          bold: true,
        ),
        linesAfter: 1);

    printer.hr(ch: '-');
    printer.text('Anti quebra 3', styles: PosStyles(align: PosAlign.left));
    printer.text(this.widget.producao.regra.antiquebra3.descricao,
        styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
          bold: true,
        ),
        linesAfter: 1);

    printer.hr(ch: '-');
    printer.text('Espessuramento', styles: PosStyles(align: PosAlign.left));
    printer.text(this.widget.producao.regra.espessuramento.descricao,
        styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
          bold: true,
        ),
        linesAfter: 1);

    printer.hr(ch: '-');
    printer.text('Tempo', styles: PosStyles(align: PosAlign.left));
    printer.text(this.widget.producao.regra.tempo,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size8,
          width: PosTextSize.size8,
          bold: true,
        ),
        linesAfter: 1);
    printer.hr(ch: '-');
    printer.text('Modelo', styles: PosStyles(align: PosAlign.left));
    printer.text(this.widget.producao.carcaca.modelo.descricao,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
          bold: true,
        ),
        linesAfter: 1);

    printer.cut();
  }

  void configAndPrint(String printerIp, BuildContext ctx) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res = await printer.connect(printerIp, port: 9100);

    if (res == PosPrintResult.success) {
      await printEtiqueta(printer);
      printer.disconnect();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      successMessage(context, "Resultado da impressão: ${res.msg}"),
    );
  }

  // ======== Widgets reutilizáveis ========
  Widget _buildFieldOneLine(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              valor,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldTwoLines(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            valor,
            style: const TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // ======== Tela principal ========
  @override
  Widget build(BuildContext context) {
    final producaoApi = ProducaoApi();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Produção'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Ionicons.print, color: Colors.orangeAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrintPage(producaoPrint: widget.producao),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Ionicons.print_outline, color: Colors.greenAccent),
            onPressed: () => configAndPrint('192.168.0.31', context),
          ),
        ],
      ),
      body: FutureBuilder<Producao>(
        future: producaoApi.getById(widget.producao.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Nenhum dado encontrado"));
          }

          final producao = snapshot.data;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Etiqueta ${producao.carcaca.numeroEtiqueta}",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildFieldTwoLines("DOT", producao.carcaca.dot ?? "NI"),
                        _buildFieldTwoLines(
                            "Medida Pneu Raspado",
                            producao.medidaPneuRaspado?.toStringAsFixed(3) ?? "NI"),
                        const Divider(height: 30),
                        _buildFieldOneLine("Medida", producao.carcaca.medida?.descricao ?? "NI"),
                        _buildFieldOneLine("Modelo", producao.carcaca.modelo?.descricao ?? "NI"),
                        _buildFieldOneLine("Marca", producao.carcaca.modelo?.marca?.descricao ?? "NI"),
                        _buildFieldOneLine("Matriz", producao.regra?.matriz?.descricao ?? "NI"),
                        _buildFieldOneLine("Tamanho Mínimo", producao.regra?.tamanhoMin?.toString() ?? "NI"),
                        _buildFieldOneLine("Tamanho Máximo", producao.regra?.tamanhoMax?.toString() ?? "NI"),
                        _buildFieldOneLine("Anti quebra 1", producao.regra?.antiquebra1?.descricao ?? "NI"),
                        _buildFieldOneLine("Anti quebra 2", producao.regra?.antiquebra2?.descricao ?? "NI"),
                        _buildFieldOneLine("Anti quebra 3", producao.regra?.antiquebra3?.descricao ?? "NI"),
                        _buildFieldOneLine("Espessuramento", producao.regra?.espessuramento?.descricao ?? "NI"),
                        _buildFieldOneLine("Tempo", producao.regra?.tempo?.toString() ?? "NI"),
                        _buildFieldOneLine("Camelback", producao.regra?.camelback?.descricao ?? "NI"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                  future: ImageService().showImage(producao.fotos, "producao"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data is responseMessage) {
                        return const Text("Falha ao carregar imagem!");
                      }
                      return showImage(snapshot.data, "detalhar");
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

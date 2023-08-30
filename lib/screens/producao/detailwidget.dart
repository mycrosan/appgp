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
  Producao producao;

  DetalhesProducaoPage({Key key, this.producao}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetalhesProducaoPageState();
  }
}




class DetalhesProducaoPageState extends State<DetalhesProducaoPage> {

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
    printer.text(this.widget.producao.regra.antiquebra3.descricao,
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
    // TODO Don't forget to choose printer's paper size
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res = await printer.connect(printerIp, port: 9100);

    if (res == PosPrintResult.success) {
      await printEtiqueta(printer);
      printer.disconnect();
    }

    ScaffoldMessenger.of(context).showSnackBar(
        successMessage(context,
            "Resultado da impressão: " + res.msg));

  }


  @override
  Widget build(BuildContext context) {
    var producaoApi = new ProducaoApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhe Produção'),
        actions: [
          IconButton(
            icon: Icon(
              Ionicons.print,
              color: Colors.orangeAccent,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PrintPage(
                            producaoPrint:
                            this.widget.producao,
                          )));
              // do something
            },
          ),
          IconButton(
            icon: Icon(
              Ionicons.print_outline,
              color: Colors.greenAccent,
            ),
            onPressed: () {
             this.configAndPrint('192.168.0.31', context);
              // do something
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: producaoApi.getById(widget.producao.id),
          builder: (context, AsyncSnapshot<Producao> snapshot) {
            if (snapshot.hasData) {
              return Column(children: [
                Card(
                    child: ListTile(
                    title: Text('Etiqueta: ' +
                    snapshot.data.carcaca.numeroEtiqueta +
                    " Dot: " +
                    snapshot.data.carcaca.dot + "\n"
                        "Medida Pneu Raspado: " +
                        snapshot.data.medidaPneuRaspado.toStringAsFixed(3)),
                subtitle: Text('Medida: ' +
                    snapshot.data.carcaca.medida.descricao +
                    'Modelo: ' +
                    snapshot.data.carcaca.modelo.descricao +
                    "\n"
                        'Marca: ' +
                    snapshot.data.carcaca.modelo.marca.descricao +
                    "\n"
                        'Matriz: ' +
                    snapshot.data.regra.matriz.descricao +
                    "\n"
                        'Tamanho mínimo: ' +
                    snapshot.data.regra.tamanhoMin.toString() +
                    "\n"
                        'Tamanho máximo: ' +
                    snapshot.data.regra.tamanhoMax.toString() +
                    "\n"
                        'Anti quebra 1: ' +
                    ((snapshot.data.regra.antiquebra1 != null)
                        ? snapshot.data.regra.antiquebra1.descricao
                        : "SI") +
                    "\n"
                        'Anti quebra 2: ' +
                    ((snapshot.data.regra.antiquebra2 != null)
                        ? snapshot.data.regra.antiquebra2.descricao
                        : "SI") +
                    "\n"
                        'Anti quebra 3: ' +
                    ((snapshot.data.regra.antiquebra3 != null)
                        ? snapshot.data.regra.antiquebra3.descricao
                        : "SI") +
                    "\n"
                        'Espessuramento: ' +
                    ((snapshot.data.regra.espessuramento != null) ? snapshot.data
                        .regra.espessuramento.descricao : "SI") +
                        "\n"
                            'Tempo: ' +
                        snapshot.data.regra.tempo.toString() +
                        "\n"
                            'Camelback: ' +
                        snapshot.data.regra.camelback.descricao),
                    ),
                ),
                Padding(padding: EdgeInsets.all(5)),
                Expanded(
                  child: FutureBuilder(
                      future: new ImageService()
                          .showImage(snapshot.data.fotos, "producao"),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data is responseMessage) {
                            return Text("Falha ao carregar imagem!");
                          }
                          return showImage(snapshot.data, "detalhar");
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                ),
              ]);

              // return RichText(
              //   text: TextSpan(
              //     style: DefaultTextStyle.of(context).style,
              //     children: <TextSpan>[
              //       TextSpan(text: 'Etiqueta: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              //       TextSpan(text: snapshot.data.carcaca.numeroEtiqueta.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              //       TextSpan(text: '\n\n'),
              //       TextSpan(text: 'DOT: ', style: TextStyle(fontWeight: FontWeight.bold)),
              //       TextSpan(text: snapshot.data.carcaca.dot.toString()),
              //       TextSpan(text: '\n'),
              //       TextSpan(text: 'Medida: ', style: TextStyle(fontWeight: FontWeight.bold)),
              //       TextSpan(text: snapshot.data.carcaca.medida.descricao.toString()),
              //       TextSpan(text: '\n'),
              //       TextSpan(text: 'Modelo: ', style: TextStyle(fontWeight: FontWeight.bold)),
              //       TextSpan(text: snapshot.data.carcaca.modelo.descricao.toString()),
              //       TextSpan(text: '\n'),
              //       TextSpan(text: 'Marca: ', style: TextStyle(fontWeight: FontWeight.bold)),
              //       TextSpan(text: snapshot.data.carcaca.modelo.descricao.toString()),
              //       TextSpan(text: '\n\n'),
              //       TextSpan(text: 'Regra: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              //       TextSpan(text: snapshot.data.regra.id.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              //       TextSpan(text: '\n\n'),
              //       TextSpan(text: 'Matriz: ', style: TextStyle(fontWeight: FontWeight.bold)),
              //       TextSpan(text: snapshot.data.regra.matriz.descricao),
              //       TextSpan(text: '\n'),
              //       TextSpan(text: 'Tamanho Mínimo: ', style: TextStyle(fontWeight: FontWeight.bold)),
              //       TextSpan(text: snapshot.data.regra.tamanhoMin.toString()),
              //       TextSpan(text: '\n'),
              //       TextSpan(text: 'Tamanho Máximo: ', style: TextStyle(fontWeight: FontWeight.bold)),
              //       TextSpan(text: snapshot.data.regra.tamanhoMax.toString()),
              //       TextSpan(text: '\n'),
              //       TextSpan(text: 'Anti quebra 1: ', style: TextStyle(fontWeight: FontWeight.bold)),
              //       TextSpan(text: snapshot.data.regra.antiquebra1.descricao),
              //       TextSpan(text: '\n'),
              //       TextSpan(text: 'Anti quebra 2: ', style: TextStyle(fontWeight: FontWeight.bold)),
              //       (snapshot.data.regra.antiquebra2 != null) ? TextSpan(text: snapshot.data.regra.antiquebra2.descricao) : TextSpan(text: "NI"),
              //       TextSpan(text: '\n'),
              //       TextSpan(text: 'Anti quebra 3: ', style: TextStyle(fontWeight: FontWeight.bold)),
              //       (snapshot.data.regra.antiquebra3 != null) ? TextSpan(text: snapshot.data.regra.antiquebra3.descricao) : TextSpan(text: "NI"),
              //       TextSpan(text: '\n'),
              //       TextSpan(text: 'Espessuramento: ', style: TextStyle(fontWeight: FontWeight.bold)),
              //       (snapshot.data.regra.espessuramento != null) ? TextSpan(text: snapshot.data.regra.espessuramento.descricao) : TextSpan(text: "NI"),
              //       TextSpan(text: '\n'),
              //       TextSpan(text: 'Tempo: ', style: TextStyle(fontWeight: FontWeight.bold)),
              //       TextSpan(text: snapshot.data.regra.tempo),
              //       TextSpan(text: '\n'),
              //       TextSpan(text: 'Camelback: ', style: TextStyle(fontWeight: FontWeight.bold)),
              //       TextSpan(text: snapshot.data.regra.camelback.descricao),
              //       TextSpan(text: '\n'),
              //     ],
              //   ),
              // );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

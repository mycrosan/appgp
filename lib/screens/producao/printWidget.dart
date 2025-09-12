import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/producao.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintPage extends StatefulWidget {
  final Producao producaoPrint;

  const PrintPage({Key? key, required this.producaoPrint}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PrintPageState();
  }
}

const PdfColor green = PdfColor.fromInt(0xff9ce5d0);
const PdfColor lightGreen = PdfColor.fromInt(0xffcdf1e7);
const double sep = 120.0;

class PrintPageState extends State<PrintPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Imprimir"),
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(format),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    // pdf.addPage(pw.Page(
    //     pageFormat: PdfPageFormat.a4,
    //     build: (pw.Context contex) {
    //       return pw.FullPage(
    //         ignoreMargins: true,
    //         child: pw.Image(image,fit: pw.BoxFit.fill),
    //       );
    //       //pw.Container(
    //
    //
    //       //child:
    //       //pw.Image(image,fit:pw.BoxFit.fill));
    //     }));

    final doc = pw.Document(title: 'ETIQUETA', author: 'GP');

    final profileImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/banner.png')).buffer.asUint8List(),
    );

    final pageTheme = await _myPageTheme(format);

    doc.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (pw.Context context) => [
          pw.Partitions(
            children: [
              pw.Partition(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Container(
                      padding: const pw.EdgeInsets.only(top: 0),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: <pw.Widget>[
                          pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: <pw.Widget>[
                                pw.Container(
                                    width: 400.0,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(width: 3),
                                    ),
                                    child: pw.Column(children: [
                                      pw.Text('Matriz',
                                          textScaleFactor: 1,
                                          style: pw.Theme.of(context)
                                              .defaultTextStyle
                                              .copyWith(
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                      // pw.Padding(padding: const pw.EdgeInsets.only(top: 0)),
                                      pw.Text(
                                          widget.producaoPrint.regra?.matriz?.descricao ?? '',
                                          textScaleFactor: 2,
                                          style: pw.Theme.of(context)
                                              .defaultTextStyle
                                              .copyWith(
                                                fontWeight: pw.FontWeight.bold,
                                              ))
                                    ])),
                                pw.Container(
                                  width: 100.0,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(width: 3),
                                  ),
                                  child: pw.Column(children: [
                                    pw.Text('Nº. da etiqueta',
                                        textScaleFactor: 1,
                                        style: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                                fontWeight:
                                                    pw.FontWeight.bold)),
                                    // pw.Padding(padding: const pw.EdgeInsets.only(top: 0)),
                                    pw.Text(
                                        widget.producaoPrint.carcaca?.numeroEtiqueta?.toString() ?? '',
                                        textScaleFactor: 2,
                                        style: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                              fontWeight: pw.FontWeight.bold,
                                            ))
                                  ]),
                                  // pw.Padding(
                                  //     padding: const pw.EdgeInsets.only(top: 20)),
                                )
                              ]),
                          // Medida Marca e Modelo da Carcaça
                          pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: <pw.Widget>[
                                pw.Container(
                                    width: 200.0,
                                    height: 40.0,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(width: 3),
                                    ),
                                    child: pw.Column(children: [
                                      pw.Text('Medida da carcaça',
                                          textScaleFactor: 1,
                                          style: pw.Theme.of(context)
                                              .defaultTextStyle
                                              .copyWith(
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                      // pw.Padding(padding: const pw.EdgeInsets.only(top: 0)),
                                      pw.Text(
                                          widget.producaoPrint.carcaca?.medida?.descricao ?? '',
                                          textScaleFactor: 1.3,
                                          style: pw.Theme.of(context)
                                              .defaultTextStyle
                                              .copyWith(
                                                fontWeight: pw.FontWeight.bold,
                                              ))
                                    ])),
                                pw.Container(
                                  width: 300.0,
                                  height: 40.0,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(width: 3),
                                  ),
                                  child: pw.Column(children: [
                                    pw.Text('Marca e modelo da carcaça',
                                        textScaleFactor: 1,
                                        style: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                                fontWeight:
                                                    pw.FontWeight.bold)),
                                    // pw.Padding(padding: const pw.EdgeInsets.only(top: 0)),
                                    pw.Text(
                                        (widget.producaoPrint.carcaca?.modelo?.marca?.descricao ?? '') +
                                            " " +
                                            (widget.producaoPrint.carcaca?.modelo?.descricao ?? ''),
                                        textScaleFactor: 0.8,
                                        style: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                              fontWeight: pw.FontWeight.bold,
                                            ))
                                  ]),
                                  // pw.Padding(
                                  //     padding: const pw.EdgeInsets.only(top: 20)),
                                )
                              ]),
//Regra | Tamanho min | Tamanho Max | Camelback
                          pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: <pw.Widget>[
                                pw.Container(
                                    width: 100.0,
                                    height: 50.0,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(width: 3),
                                    ),
                                    child: pw.Column(children: [
                                      pw.Text('Regra',
                                          textScaleFactor: 1,
                                          style: pw.Theme.of(context)
                                              .defaultTextStyle
                                              .copyWith(
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                      // pw.Padding(padding: const pw.EdgeInsets.only(top: 0)),
                                      pw.Text(
                                          widget.producaoPrint.regra?.id?.toString() ?? '',
                                          textScaleFactor: 1.5,
                                          style: pw.Theme.of(context)
                                              .defaultTextStyle
                                              .copyWith(
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                    ])),
                                pw.Container(
                                  width: 100.0,
                                  height: 50.0,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(width: 3),
                                  ),
                                  child: pw.Column(children: [
                                    pw.Text('Tamanho Min',
                                        textScaleFactor: 1,
                                        style: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                                fontWeight:
                                                    pw.FontWeight.bold)),
                                    // pw.Padding(padding: const pw.EdgeInsets.only(top: 0)),
                                    pw.Text(
                                        widget.producaoPrint.regra?.tamanhoMin?.toString() ?? '',
                                        textScaleFactor: 1.5,
                                        style: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                              fontWeight: pw.FontWeight.bold,
                                            ))
                                  ]),
                                  // pw.Padding(
                                  //     padding: const pw.EdgeInsets.only(top: 20)),
                                ),
                                pw.Container(
                                  width: 100.0,
                                  height: 50.0,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(width: 3),
                                  ),
                                  child: pw.Column(children: [
                                    pw.Text('Tamanho Máx',
                                        textScaleFactor: 1,
                                        style: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                                fontWeight:
                                                    pw.FontWeight.bold)),
                                    // pw.Padding(padding: const pw.EdgeInsets.only(top: 0)),
                                    pw.Text(
                                        widget.producaoPrint.regra?.tamanhoMax?.toString() ?? '',
                                        textScaleFactor: 1.5,
                                        style: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                              fontWeight: pw.FontWeight.bold,
                                            ))
                                  ]),
                                  // pw.Padding(
                                  //     padding: const pw.EdgeInsets.only(top: 20)),
                                ),
                                pw.Container(
                                  width: 200.0,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(width: 3),
                                  ),
                                  child: pw.Column(children: [
                                    pw.Text('Camelback',
                                        textScaleFactor: 1,
                                        style: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                                fontWeight:
                                                    pw.FontWeight.bold)),
                                    // pw.Padding(padding: const pw.EdgeInsets.only(top: 0)),
                                    pw.Text(
                                        widget.producaoPrint.regra?.camelback?.descricao ?? '',
                                        textScaleFactor: 2,
                                        style: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                              fontWeight: pw.FontWeight.bold,
                                            ))
                                  ]),
                                  // pw.Padding(
                                  //     padding: const pw.EdgeInsets.only(top: 20)),
                                )
                              ]),
                          pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: <pw.Widget>[
                                pw.Container(
                                    width: 100.0,
                                    height: 81.0,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(width: 3),
                                    ),
                                    child: pw.Column(children: [
                                      pw.Text('Anti quebra 1',
                                          textScaleFactor: 1,
                                          style: pw.Theme.of(context)
                                              .defaultTextStyle
                                              .copyWith(
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                      // pw.Padding(padding: const pw.EdgeInsets.only(top: 0)),
                                      pw.Text(
                                          widget.producaoPrint.regra?.antiquebra1?.descricao ?? '',
                                          textScaleFactor: 1.5,
                                          textAlign: pw.TextAlign.center,
                                          style: pw.Theme.of(context)
                                              .defaultTextStyle
                                              .copyWith(
                                                fontWeight: pw.FontWeight.bold,
                                              ))
                                    ])),
                                pw.Container(
                                  width: 100.0,
                                  height: 81.0,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(width: 3),
                                  ),
                                  child: pw.Column(children: [
                                    pw.Text('Anti quebra 2',
                                        textScaleFactor: 1,
                                        textAlign: pw.TextAlign.center,
                                        style: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                                fontWeight:
                                                    pw.FontWeight.bold)),
                                    // pw.Padding(padding: const pw.EdgeInsets.only(top: 0)),
                                    widget.producaoPrint.regra?.antiquebra2 !=
                                            null
                                        ? pw.Text(
                                            widget.producaoPrint.regra?.antiquebra2?.descricao ?? '',
                                            textScaleFactor: 1.5,
                                            textAlign: pw.TextAlign.center,
                                            style: pw.Theme.of(context)
                                                .defaultTextStyle
                                                .copyWith(
                                                  fontWeight: pw.FontWeight.bold,
                                                ))
                                        : pw.Text("NÃO",
                                            textScaleFactor: 2,
                                            textAlign: pw.TextAlign.center,
                                            style: pw.Theme.of(context)
                                                .defaultTextStyle
                                                .copyWith(
                                                    fontWeight:
                                                        pw.FontWeight.bold))
                                  ]),
                                  // pw.Padding(
                                  //     padding: const pw.EdgeInsets.only(top: 20)),
                                ),
                                pw.Container(
                                  width: 100.0,
                                  height: 81.0,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(width: 3),
                                  ),
                                  child: pw.Column(children: [
                                    pw.Text('Anti quebra 3',
                                        textScaleFactor: 1,
                                        textAlign: pw.TextAlign.center,
                                        style: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                                fontWeight:
                                                    pw.FontWeight.bold)),
                                    // pw.Padding(padding: const pw.EdgeInsets.only(top: 0)),
                                    widget.producaoPrint.regra?.antiquebra3 !=
                                            null
                                        ? pw.Text(
                                            widget.producaoPrint.regra?.antiquebra3?.descricao ?? '',
                                            textScaleFactor: 1.5,
                                            textAlign: pw.TextAlign.center,
                                            style: pw.Theme.of(context)
                                                .defaultTextStyle
                                                .copyWith(
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ))
                                        : pw.Text("NÃO",
                                            textScaleFactor: 2,
                                            style: pw.Theme.of(context)
                                                .defaultTextStyle
                                                .copyWith(
                                                    fontWeight:
                                                        pw.FontWeight.bold))
                                  ]),
                                  // pw.Padding(
                                  //     padding: const pw.EdgeInsets.only(top: 20)),
                                ),

                                pw.Container(
                                  width: 100.0,
                                  height: 81.0,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(width: 3),
                                  ),
                                  child: pw.Column(children: [
                                    pw.Text('Espessuramento',
                                        textScaleFactor: 1,
                                        style: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                                fontWeight:
                                                    pw.FontWeight.bold)),
                                    // pw.Padding(padding: const pw.EdgeInsets.only(top: 0)),
                                    widget.producaoPrint.regra?.espessuramento !=
                                            null
                                        ? pw.Text(
                                            widget.producaoPrint.regra?.espessuramento?.descricao ?? '',
                                            textScaleFactor: 1.5,
                                            textAlign: pw.TextAlign.center,
                                            style: pw.Theme.of(context)
                                                .defaultTextStyle
                                                .copyWith(
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ))
                                        : pw.Text("NÃO",
                                            textScaleFactor: 2,
                                            textAlign: pw.TextAlign.center,
                                            style: pw.Theme.of(context)
                                                .defaultTextStyle
                                                .copyWith(
                                                    fontWeight:
                                                        pw.FontWeight.bold))
                                  ]),
                                ),
                                pw.Container(
                                  width: 100.0,
                                  height: 81.0,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(width: 3),
                                  ),
                                  child: pw.Column(children: [
                                    pw.Text('Tempo',
                                        textScaleFactor: 1,
                                        style: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                                fontWeight:
                                                    pw.FontWeight.bold)),
                                    // pw.Padding(padding: const pw.EdgeInsets.only(top: 0)),
                                    pw.Text(
                                        widget.producaoPrint.regra?.tempo?.toString() ?? '',
                                        textScaleFactor: 3.5,
                                        style: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                              fontWeight: pw.FontWeight.bold,
                                            ))
                                  ]),
                                ),

                                // pw.Positioned(
                                //   child: pw.Text("Ola"),
                                //   left: 0,
                                //   top: 0,
                                // ),
                              ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return doc.save();
  }

  Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
    // final bgShape = await rootBundle.loadString('assets/images/resume.svg');

    format = format.applyMargin(
        left: 1.0 * PdfPageFormat.cm,
        top: 1.0 * PdfPageFormat.cm,
        right: 1.0 * PdfPageFormat.cm,
        bottom: 1.0 * PdfPageFormat.cm);

    return pw.PageTheme(
      pageFormat: format,
      theme: pw.ThemeData.withFont(
        base: await PdfGoogleFonts.openSansRegular(),
        bold: await PdfGoogleFonts.openSansBold(),
        icons: await PdfGoogleFonts.materialIcons(),
      ),
      buildBackground: (pw.Context context) {
        return pw.FullPage(
          ignoreMargins: false,
          child: pw.Stack(
            children: [
              // pw.Positioned(
              //   child: pw.Text("Ola"),
              //   left: 0,
              //   top: 0,
              // ),
              // pw.Positioned(
              //   child: pw.Transform.rotate(
              //       angle: pi, child: pw.SvgImage(svg: bgShape)),
              //   right: 0,
              //   bottom: 0,
              // ),
            ],
          ),
        );
      },
    );
  }
}

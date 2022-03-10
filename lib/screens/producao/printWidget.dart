import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/producao.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintPage extends StatefulWidget {
  Producao producaoPrint;

  PrintPage({Key key, this.producaoPrint}) : super(key: key);

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

    final doc = pw.Document(title: 'ETIQUETA', author: 'SANDY');

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
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: <pw.Widget>[
                                pw.Container(
                                    width: 400.0,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(width: 3),
                                    ),
                                    child: pw.Column(children: [
                                      pw.Text('MATRIZ',
                                          textScaleFactor: 1,
                                          style: pw.Theme.of(context)
                                              .defaultTextStyle
                                              .copyWith(
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                      // pw.Padding(padding: const pw.EdgeInsets.only(top: 0)),
                                      pw.Text(
                                          widget.producaoPrint.regra.matriz
                                              .descricao,
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
                                    pw.Text('ETIQUETA',
                                        textScaleFactor: 1,
                                        style: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                                fontWeight:
                                                    pw.FontWeight.bold)),
                                    // pw.Padding(padding: const pw.EdgeInsets.only(top: 0)),
                                    pw.Text(
                                        widget.producaoPrint.carcaca.id
                                            .toString(),
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
    final bgShape = await rootBundle.loadString('assets/images/resume.svg');

    format = format.applyMargin(
        left: 2.0 * PdfPageFormat.cm,
        top: 2.0 * PdfPageFormat.cm,
        right: 2.0 * PdfPageFormat.cm,
        bottom: 2.0 * PdfPageFormat.cm);

    return pw.PageTheme(
      pageFormat: format,
      theme: pw.ThemeData.withFont(
        base: await PdfGoogleFonts.openSansRegular(),
        bold: await PdfGoogleFonts.openSansBold(),
        icons: await PdfGoogleFonts.materialIcons(),
      ),
      buildBackground: (pw.Context context) {
        return pw.FullPage(
          ignoreMargins: true,
          child: pw.Stack(
            children: [
              pw.Positioned(
                // child: pw.SvgImage(svg: bgShape),
                left: 0,
                top: 0,
              ),
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

class _Block extends pw.StatelessWidget {
  _Block({
    this.title,
    this.icon,
  });

  final String title;

  final pw.IconData icon;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Container(
                  width: 6,
                  height: 6,
                  margin: const pw.EdgeInsets.only(top: 0, left: 2, right: 5),
                  decoration: const pw.BoxDecoration(
                    color: green,
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.Text(title,
                    style: pw.Theme.of(context)
                        .defaultTextStyle
                        .copyWith(fontWeight: pw.FontWeight.bold)),
                pw.Spacer(),
                if (icon != null) pw.Icon(icon, color: lightGreen, size: 18),
              ]),
          pw.Container(
            decoration: const pw.BoxDecoration(
                border: pw.Border(left: pw.BorderSide(color: green, width: 2))),
            padding: const pw.EdgeInsets.only(left: 10, top: 5, bottom: 5),
            margin: const pw.EdgeInsets.only(left: 5),
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Lorem(length: 20),
                ]),
          ),
        ]);
  }
}

class _Category extends pw.StatelessWidget {
  _Category({this.title});

  final String title;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        color: lightGreen,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      margin: const pw.EdgeInsets.only(bottom: 10, top: 20),
      padding: const pw.EdgeInsets.fromLTRB(10, 4, 10, 4),
      child: pw.Text(
        title,
        textScaleFactor: 1.5,
      ),
    );
  }
}

class _Percent extends pw.StatelessWidget {
  _Percent({
    this.size,
    this.value,
    this.title,
    this.fontSize = 1.2,
    this.color = green,
    this.backgroundColor = PdfColors.grey300,
    this.strokeWidth = 5,
  });

  final double size;

  final double value;

  final pw.Widget title;

  final double fontSize;

  final PdfColor color;

  final PdfColor backgroundColor;

  final double strokeWidth;

  @override
  pw.Widget build(pw.Context context) {
    final widgets = <pw.Widget>[
      pw.Container(
        width: size,
        height: size,
        child: pw.Stack(
          alignment: pw.Alignment.center,
          fit: pw.StackFit.expand,
          children: <pw.Widget>[
            pw.Center(
              child: pw.Text(
                '${(value * 100).round().toInt()}%',
                textScaleFactor: fontSize,
              ),
            ),
            pw.CircularProgressIndicator(
              value: value,
              backgroundColor: backgroundColor,
              color: color,
              strokeWidth: strokeWidth,
            ),
          ],
        ),
      )
    ];

    widgets.add(title);

    return pw.Column(children: widgets);
  }
}

class _UrlText extends pw.StatelessWidget {
  _UrlText(this.text, this.url);

  final String text;
  final String url;

  @override
  pw.Widget build(pw.Context context) {
    return pw.UrlLink(
      destination: url,
      child: pw.Text(text,
          style: const pw.TextStyle(
            decoration: pw.TextDecoration.underline,
            color: PdfColors.blue,
          )),
    );
  }
}

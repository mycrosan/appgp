import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:android_bluetooth_printer/android_bluetooth_printer.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/carcaca.dart';
import '../../models/producao.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintPage extends StatefulWidget {
  Producao producaoPrint;

  PrintPage({Key key, this.producaoPrint}) : super(key: key);

  @override
  _PrintPageState createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothPrint> _devices = [];
  String _devicesMsg = "";
  bool _connected = false;
  BluetoothDevice _device;
  String tips = 'no device connect';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    bool isConnected = await bluetoothPrint.isConnected;

    bluetoothPrint.state.listen((state) {
      print('cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
          });
          break;
        default:
          break;
      }
    });

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('IMPRESSÃO BLUETOOTH'),
        ),
        body: Column(
          children: [
            Expanded(
              child: PdfPreview(
                build: (format) => _generatePdf(format, "ola"),
              ),
            ),
            RefreshIndicator(
              onRefresh: () =>
                  bluetoothPrint.startScan(timeout: Duration(seconds: 4)),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Text(tips),
                        ),
                      ],
                    ),
                    Divider(),
                    StreamBuilder<List<BluetoothDevice>>(
                      stream: bluetoothPrint.scanResults,
                      initialData: [],
                      builder: (c, snapshot) => Column(
                        children: snapshot.data
                            .map((d) => ListTile(
                                  title: Text(d.name ?? ''),
                                  subtitle: Text(d.address),
                                  onTap: () async {
                                    setState(() {
                                      _device = d;
                                    });
                                  },
                                  trailing: _device != null &&
                                          _device.address == d.address
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        )
                                      : null,
                                ))
                            .toList(),
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              OutlinedButton(
                                child: Text('connect'),
                                onPressed: _connected
                                    ? null
                                    : () async {
                                        if (_device != null &&
                                            _device.address != null) {
                                          await bluetoothPrint.connect(_device);
                                        } else {
                                          setState(() {
                                            tips = 'please select device';
                                          });
                                          print('please select device');
                                        }
                                      },
                              ),
                              SizedBox(width: 10.0),
                              OutlinedButton(
                                child: Text('disconnect'),
                                onPressed: _connected
                                    ? () async {
                                        await bluetoothPrint.disconnect();
                                      }
                                    : null,
                              ),
                            ],
                          ),
                          OutlinedButton(
                            child: Text('Android Print'),
                            onPressed: () async {
                              final pdf = pw.Document();

                              pdf.addPage(pw.Page(
                                  pageFormat: PdfPageFormat.a4,
                                  build: (pw.Context context) {
                                    return pw.Center(
                                      child: pw.Text("Hello World"),
                                    ); // Center
                                  }));
                              pdf.save(); // Page
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: StreamBuilder<bool>(
          stream: bluetoothPrint.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data) {
              return FloatingActionButton(
                child: Icon(Icons.stop),
                onPressed: () => bluetoothPrint.stopScan(),
                backgroundColor: Colors.red,
              );
            } else {
              return FloatingActionButton(
                  child: Icon(Icons.search),
                  onPressed: () =>
                      bluetoothPrint.startScan(timeout: Duration(seconds: 4)));
            }
          },
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Text(title, style: pw.TextStyle(font: font)),
                ),
              ),
              pw.SizedBox(height: 10)
              // pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}

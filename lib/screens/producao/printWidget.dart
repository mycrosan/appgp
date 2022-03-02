import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/carcaca.dart';
import '../../models/producao.dart';

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
        body: RefreshIndicator(
          onRefresh: () =>
              bluetoothPrint.startScan(timeout: Duration(seconds: 4)),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                        child: Text('print receipt(esc)'),
                        onPressed: _connected
                            ? () async {
                                Map<String, dynamic> config = Map();

                                // config['width'] = 40; // 标签宽度，单位mm
                                config['height'] = 40; // 标签高度，单位mm
                                // config['gap'] = 2; // 标签

                                List<LineText> list = [];

                                list.add(LineText(
                                  y: 0,
                                  type: LineText.TYPE_TEXT,
                                  content: 'A Title',
                                  size: 100,
                                  weight: 5,
                                  align: LineText.ALIGN_CENTER,
                                ));

                                list.add(LineText(
                                  y: 30,
                                  type: LineText.TYPE_TEXT,
                                  content: 'this is conent left',
                                  align: LineText.ALIGN_LEFT,
                                ));

                                list.add(LineText(
                                  y: 60,
                                  type: LineText.TYPE_TEXT,
                                  content: 'this is conent right',
                                  align: LineText.ALIGN_RIGHT,
                                ));

                                // ByteData data = await rootBundle
                                //     .load("assets/images/banner.png");
                                //
                                // List<int> imageBytes = data.buffer.asUint8List(
                                //     data.offsetInBytes, data.lengthInBytes);
                                //
                                // String base64Image = base64Encode(imageBytes);
                                // list.add(LineText(
                                //     type: LineText.TYPE_IMAGE,
                                //     content: base64Image,
                                //     align: LineText.ALIGN_CENTER,
                                //     linefeed: 1));

                                await bluetoothPrint.printReceipt(config, list);
                              }
                            : null,
                      ),
                      OutlinedButton(
                        child: Text('Imprimir label(tsc)'),
                        onPressed: _connected
                            ? () async {
                                Map<String, dynamic> config = Map();
                                // config['width'] = 40; // 标签宽度，单位mm
                                config['height'] = 40; // 标签高度，单位mm
                                // config['gap'] = 1; // 标签间隔，单位mm

                                // x、y坐标位置，单位dpi，1mm=8dpi
                                List<LineText> list = [];

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    x: 0,
                                    y: 10,
                                    weight: 10,
                                    content: 'Matriz: ' + widget.producaoPrint.regra.matriz.descricao ,
                                    size: 60,
                                    linefeed: 10));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    x: 0,
                                    y: 40,
                                    content: 'Dot: ' +
                                        widget.producaoPrint.carcaca.dot));

                                list.add(LineText(
                                    type: LineText.TYPE_QRCODE,
                                    x: 0,
                                    y: 70,
                                    content: 'http://pneusgppremium.com.br'));

                                list.add(LineText(
                                    type: LineText.TYPE_BARCODE,
                                    x: 0,
                                    y: 190,
                                    content: 'SANDY'));

                                List<LineText> list1 = [];
                                // ByteData data = await rootBundle.load("assets/images/guide3.png");
                                // List<int> imageBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
                                // String base64Image = base64Encode(imageBytes);
                                // list1.add(LineText(type: LineText.TYPE_IMAGE, x:10, y:10, content: base64Image,));

                                await bluetoothPrint.printLabel(config, list);
                                await bluetoothPrint.printLabel(config, list1);
                              }
                            : null,
                      ),
                      OutlinedButton(
                        child: Text('print selftest'),
                        onPressed: _connected
                            ? () async {
                                await bluetoothPrint.printTest();
                              }
                            : null,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
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
}

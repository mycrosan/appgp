import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BarcodeScannerPageState();
  }
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;
  bool _scanned = false;

  @override
  void dispose() {
    if (controller != null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller.pauseCamera();
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner'),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: (QRViewController c) {
          this.controller = c;
          c.scannedDataStream.listen((scanData) {
            if (!_scanned) {
              _scanned = true;
              controller.pauseCamera();
              Navigator.pop(context, scanData.code);
            }
          });
        },
      ),
    );
  }
}

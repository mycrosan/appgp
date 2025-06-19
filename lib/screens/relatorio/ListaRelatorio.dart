import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ListaRelatorio extends StatefulWidget {
  @override
  _ListaRelatorioState createState() => _ListaRelatorioState();
}

class _ListaRelatorioState extends State<ListaRelatorio> {
  bool isDownloading = false;

  Future<void> downloadExcel() async {
    setState(() {
      isDownloading = true;
    });

    try {
      var url = Uri.parse('http://192.168.0.109:8080/api/download');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String filePath = '${appDocDir.path}/Rel_Producao.xlsx';

        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        await OpenFile.open(filePath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download concluído: $filePath')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao baixar o arquivo (Status: ${response.statusCode})')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer download: $e')),
      );
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download de Arquivo Excel'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: isDownloading ? null : downloadExcel,
          child: isDownloading
              ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
              : Text('Download Excel'),
        ),
      ),
    );
  }
}

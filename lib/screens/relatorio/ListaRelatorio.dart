
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ListaRelatorio extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaRelatorioState();
  }
}

class ListaRelatorioState extends State<ListaRelatorio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download de Arquivo Excel'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {

          },
          child: Text('Download Excel'),
        ),
      ),
    );
  }
}





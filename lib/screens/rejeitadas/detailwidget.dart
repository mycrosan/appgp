import 'package:GPPremium/models/responseMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/ImagePreview.dart';
import '../../models/rejeitadas.dart';
import '../../service/get_image.dart';
import '../../service/rejeitadasapi.dart';

class DetalhesRejeitadasPage extends StatefulWidget {
  int id;

  DetalhesRejeitadasPage({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetalhesRejeitadasPageState();
  }
}

class DetalhesRejeitadasPageState extends State<DetalhesRejeitadasPage> {
  @override
  Widget build(BuildContext context) {
    var rejeitadaApi = new RejeitadasApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhe Carcaça'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: rejeitadaApi.getById(widget.id),
          builder: (context, AsyncSnapshot<Rejeitadas> snapshot) {
            if (snapshot.hasData) {
              return Column(children: [
                // Card(
                //   child: ListTile(
                //     title: Text('Etiqueta: ' +
                //         snapshot.data.numeroEtiqueta +
                //         " id: " +
                //         snapshot.data.id.toString()),
                //     subtitle: Text('Medida: ' +
                //         snapshot.data.medida.descricao +
                //         "\n"
                //             'DOT: ' +
                //         snapshot.data.dot +
                //         "\n"
                //             'Modelo: ' +
                //         snapshot.data.modelo.descricao),
                //   ),
                // ),
              ]);

              // return Column(
              //   children: [
              //     Text("Etiqueta"),
              //     Text(snapshot.data.numeroEtiqueta.toString()),
              //     Padding(
              //       padding: EdgeInsets.all(5),
              //     ),
              //     Text("DOT"),
              //     Text(snapshot.data.dot.toString()),
              //     Padding(
              //       padding: EdgeInsets.all(5),
              //     ),
              //     Text("Medida"),
              //     Text(snapshot.data.medida.descricao.toString()),
              //     Padding(
              //       padding: EdgeInsets.all(5),
              //     ),
              //     Text("Modelo"),
              //     Text(snapshot.data.modelo.descricao.toString()),
              //     Padding(
              //       padding: EdgeInsets.all(5),
              //     ),
              //     Text("Marca"),
              //     Text(snapshot.data.modelo.marca.descricao),
              //     Padding(
              //       padding: EdgeInsets.all(5),
              //     ),
              //     Text("País"),
              //     Text(snapshot.data.pais.descricao),
              //     Padding(
              //       padding: EdgeInsets.all(5),
              //     ),
              //   ],
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

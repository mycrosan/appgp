import 'package:GPPremium/models/carcaca.dart';
import 'package:GPPremium/service/carcacaapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../service/get_image.dart';

class DetalhesCarcacaPage extends StatefulWidget {
  int id;

  DetalhesCarcacaPage({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetalhesCarcacaPageState();
  }
}

class DetalhesCarcacaPageState extends State<DetalhesCarcacaPage> {
  @override
  Widget build(BuildContext context) {
    var carcacaApi = new CarcacaApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhe Carcaça'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: carcacaApi.getById(widget.id),
          builder: (context, AsyncSnapshot<Carcaca> snapshot) {
            if (snapshot.hasData) {
              return Column(children: [
                Card(
                  child: ListTile(
                    title: Text('Etiqueta: ' +
                        snapshot.data.numeroEtiqueta +
                        " id: " +
                        snapshot.data.id.toString()),
                    subtitle: Text('Medida: ' +
                        snapshot.data.medida.descricao +
                        "\n"
                            'DOT: ' +
                        snapshot.data.dot +
                        "\n"
                            'Modelo: ' +
                        snapshot.data.modelo.descricao),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                      future: new ImageService().showImage(snapshot.data.fotos),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return snapshot.data[index];
                              },
                            ),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                ),
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

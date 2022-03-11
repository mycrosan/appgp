import 'package:GPPremium/models/producao.dart';
import 'package:GPPremium/service/producaoapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    var producaoApi = new ProducaoApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhe Produção'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
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
                    snapshot.data.carcaca.dot),
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

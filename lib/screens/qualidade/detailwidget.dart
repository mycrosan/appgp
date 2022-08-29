import 'package:GPPremium/models/responseMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/ImagePreview.dart';
import '../../models/qualidade.dart';
import '../../service/Qualidadeapi.dart';
import '../../service/get_image.dart';

class DetalhesQualidadePage extends StatefulWidget {
  Qualidade qualidade;

  DetalhesQualidadePage({Key key, this.qualidade}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetalhesQualidadePageState();
  }
}

class DetalhesQualidadePageState extends State<DetalhesQualidadePage> {
  @override
  Widget build(BuildContext context) {
    var qualidadeApi = new QualidadeApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhe Qualidade'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: qualidadeApi.getById(widget.qualidade.id),
          builder: (context, AsyncSnapshot<Qualidade> snapshot) {
            if (snapshot.hasData) {
              return Column(children: [
                Card(
                  child: ListTile(
                    title: Text('Etiqueta: ' +
                        snapshot.data.producao.carcaca.numeroEtiqueta +
                        " Dot: " +
                        snapshot.data.producao.carcaca.dot + "\n"
                        "Medida Pneu Raspado: " +
                        snapshot.data.producao.medidaPneuRaspado.toStringAsFixed(3)),
                    subtitle: Text('Medida: ' +
                        snapshot.data.producao.carcaca.medida.descricao +
                        ' Modelo: ' +
                        snapshot.data.producao.carcaca.modelo.descricao +
                        "\n"
                            'Marca: ' +
                        snapshot.data.producao.carcaca.modelo.marca.descricao +
                        "\n"
                            'Situação: ' +
                        snapshot.data.tipo_observacao.tipoClassificacao.descricao +
                        "\n"
                            'Classificação: ' +
                        snapshot.data.tipo_observacao.descricao +
                        "\n"
                            // 'Tamanho máximo: ' +
                        // snapshot.data.producao.regra.tamanhoMax.toString() +
                        // "\n"
                        //     'Anti quebra 1: ' +
                        // ((snapshot.data.producao.regra.antiquebra1 != null)
                        //     ? snapshot.data.producao.regra.antiquebra1.descricao
                        //     : "SI") +
                        // "\n"
                        //     'Anti quebra 2: ' +
                        // ((snapshot.data.producao.regra.antiquebra2 != null)
                        //     ? snapshot.data.producao.regra.antiquebra2.descricao
                        //     : "SI") +
                        // "\n"
                        //     'Anti quebra 3: ' +
                        // ((snapshot.data.producao.regra.antiquebra3 != null)
                        //     ? snapshot.data.producao.regra.antiquebra3.descricao
                        //     : "SI") +
                        // "\n"
                        //     'Espessuramento: ' +
                        // ((snapshot.data.producao.regra.espessuramento != null) ? snapshot.data
                        //     .producao.regra.espessuramento.descricao : "SI") +
                        // "\n"
                        //     'Tempo: ' +
                        // snapshot.data.producao.regra.tempo.toString() +
                      ),
                  ),
                ),
                Container(
                  child: FutureBuilder(
                      future: ImageService()
                          .showImage(snapshot.data.fotos, "qualidade"),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data is responseMessage) {
                            return Text("Falha ao carregar imagem!");
                          }
                          return showImage(snapshot.data, "detalhar");
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

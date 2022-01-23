import 'package:GPPremium/models/producao.dart';
import 'package:GPPremium/service/producaoapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetalhesProducaoPage extends StatefulWidget {
  int id;

  DetalhesProducaoPage({Key key, this.id}) : super(key: key);

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
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: producaoApi.getById(widget.id),
          builder: (context, AsyncSnapshot<Producao> snapshot) {
            if (snapshot.hasData) {
              return RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(text: 'Etiqueta: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    TextSpan(text: snapshot.data.carcaca.numeroEtiqueta.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    TextSpan(text: '\n\n'),
                    TextSpan(text: 'DOT: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: snapshot.data.carcaca.dot.toString()),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Medida: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: snapshot.data.carcaca.medida.descricao.toString()),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Modelo: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: snapshot.data.carcaca.modelo.descricao.toString()),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Marca: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: snapshot.data.carcaca.modelo.descricao.toString()),
                    TextSpan(text: '\n\n'),
                    TextSpan(text: 'Regra: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    TextSpan(text: snapshot.data.regra.id.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    TextSpan(text: '\n\n'),
                    TextSpan(text: 'Matriz: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: snapshot.data.regra.matriz.descricao),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Tamanho Mínimo: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: snapshot.data.regra.tamanhoMin.toString()),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Tamanho Máximo: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: snapshot.data.regra.tamanhoMax.toString()),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Anti quebra 1: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: snapshot.data.regra.antiquebra1.descricao),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Anti quebra 2: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    (snapshot.data.regra.antiquebra2 != null) ? TextSpan(text: snapshot.data.regra.antiquebra2.descricao) : TextSpan(text: "NI"),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Anti quebra 3: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    (snapshot.data.regra.antiquebra3 != null) ? TextSpan(text: snapshot.data.regra.antiquebra3.descricao) : TextSpan(text: "NI"),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Espessuramento: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    (snapshot.data.regra.espessuramento != null) ? TextSpan(text: snapshot.data.regra.espessuramento.descricao) : TextSpan(text: "NI"),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Tempo: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: snapshot.data.regra.tempo),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Camelback: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: snapshot.data.regra.camelback.descricao),
                    TextSpan(text: '\n'),
                  ],
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

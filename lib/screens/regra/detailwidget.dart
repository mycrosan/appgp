import 'package:GPPremium/models/regra.dart';
import 'package:GPPremium/service/regraapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetalhesRegraPage extends StatefulWidget {

  int id;
  DetalhesRegraPage({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetalhesRegraPageState();
  }
}

class DetalhesRegraPageState extends State<DetalhesRegraPage> {
  @override
  Widget build(BuildContext context) {
    var regraApi = new RegraApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhe Regra'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: regraApi.getById(widget.id),
          builder: (context, AsyncSnapshot<Regra> snapshot) {
            if (snapshot.hasData) {
              return RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(text: 'Regra: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    TextSpan(text: snapshot.data.id.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    TextSpan(text: '\n\n'),
                    TextSpan(text: 'Matriz: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: snapshot.data.matriz.descricao),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Tamanho Mínimo: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: snapshot.data.tamanhoMin.toStringAsFixed(3)),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Tamanho Máximo: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: snapshot.data.tamanhoMax.toStringAsFixed(3)),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Anti quebra 1: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: snapshot.data.antiquebra1.descricao),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Anti quebra 2: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    (snapshot.data.antiquebra2 != null) ? TextSpan(text: snapshot.data.antiquebra2.descricao) : TextSpan(text: "NI"),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Anti quebra 3: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    (snapshot.data.antiquebra3 != null) ? TextSpan(text: snapshot.data.antiquebra3.descricao) : TextSpan(text: "NI"),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Espessuramento: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    (snapshot.data.espessuramento != null) ? TextSpan(text: snapshot.data.espessuramento.descricao) : TextSpan(text: "NI"),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Tempo: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: snapshot.data.tempo),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Modelo: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: snapshot.data.modelo.descricao +" - " + snapshot.data.modelo.marca.descricao),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Marca: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: snapshot.data.modelo.marca.descricao),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Camelback: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: snapshot.data.camelback.descricao),
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

import 'package:GPPremium/models/matriz.dart';
import 'package:GPPremium/models/pais.dart';
import 'package:GPPremium/models/regra.dart';
import 'package:GPPremium/service/matrizapi.dart';
import 'package:GPPremium/service/paisapi.dart';
import 'package:GPPremium/service/regraapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetalhesMatrizPage extends StatefulWidget {

  int id;
  DetalhesMatrizPage({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetalhesMatrizPageState();
  }
}

class DetalhesMatrizPageState extends State<DetalhesMatrizPage> {
  @override
  Widget build(BuildContext context) {
    var paisApi = new MatrizApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhe Matriz'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: paisApi.getById(widget.id),
          builder: (context, AsyncSnapshot<Matriz> snapshot) {
            if (snapshot.hasData) {
              return RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(text: 'ID: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    TextSpan(text: snapshot.data.id.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    TextSpan(text: '\n\n'),
                    TextSpan(text: 'ID: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    TextSpan(text: snapshot.data.descricao.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    TextSpan(text: '\n\n'),
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

import 'package:GPPremium/models/modelo.dart';
import 'package:GPPremium/service/modeloapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetalhesModeloPage extends StatefulWidget {

  int id;
  DetalhesModeloPage({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetalhesModeloPageState();
  }
}

class DetalhesModeloPageState extends State<DetalhesModeloPage> {
  @override
  Widget build(BuildContext context) {
    var modeloApi = new ModeloApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhe Modelo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: modeloApi.getById(widget.id),
          builder: (context, AsyncSnapshot<Modelo> snapshot) {
            if (snapshot.hasData) {
              return RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(text: 'ID: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    TextSpan(text: snapshot.data.id.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    TextSpan(text: '\n\n'),
                    TextSpan(text: 'Descrição: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    TextSpan(text: snapshot.data.descricao.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    TextSpan(text: '\n\n'),
                    TextSpan(text: 'Marca: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    TextSpan(text: snapshot.data.marca.descricao.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
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

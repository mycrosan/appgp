import 'package:GPPremium/models/medida.dart';
import 'package:GPPremium/service/medidaapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetalhesMedidaPage extends StatefulWidget {

  int id;
  DetalhesMedidaPage({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetalhesMedidaPageState();
  }
}

class DetalhesMedidaPageState extends State<DetalhesMedidaPage> {
  @override
  Widget build(BuildContext context) {
    var paisApi = new MedidaApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhe Medida'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: paisApi.getById(widget.id),
          builder: (context, AsyncSnapshot<Medida> snapshot) {
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

import 'package:GPPremium/screens/carcaca/editdatawidget.dart';
import 'package:GPPremium/service/producaoapi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'adicionar.dart';
import 'detailwidget.dart';
import 'editdatawidget.dart';

class ListaProducao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var producaoAPI = new ProducaoApi();
    final ProducaoApi producao = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Produção'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
            future: producaoAPI.getAll(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text('Número Etiqueta: ' +
                              snapshot.data[index].carcaca.numeroEtiqueta),
                          subtitle: Text('Etiqueta: ' +
                              snapshot.data[index].medidaPneuRaspado.toString() +
                              ' Regra: ' +
                              snapshot.data[index].regra.id.toString()
                          ),
                          trailing: Container(
                            width: 100,
                            child: Row(
                              children: <Widget>[
                                IconButton(onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditarProducaoPage(
                                            producao: snapshot.data[index],
                                          )));
                                }, icon: Icon(Icons.edit, color: Colors.orange)),

                                IconButton(onPressed: () async {

                                  Provider.of<ProducaoApi>(context, listen: false).delete(snapshot.data[index].id);

                                }, icon: Icon(Icons.delete, color: Colors.red,)),
                                // IconButton(onPressed: (){}, icon: Icon(Icons.arrow_right, color: Colors.black,))
                              ],
                            ),
                          ),

                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetalhesProducaoPage(
                                      id: snapshot.data[index].id,
                                    )));
                          },
                        ),
                      );
                    });
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AdicionarProducaoPage(), //AddCarcacaPage(),
              ));
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

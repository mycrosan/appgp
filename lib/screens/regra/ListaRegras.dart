import 'package:GPPremium/service/regraapi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'adicionar.dart';
import 'detailwidget.dart';
import 'editdatawidget.dart';

class ListaRegras extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var regraAPI = new RegraApi();

    final RegraApi producao = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Regras'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
            future: regraAPI.getAll(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            'Matriz: ' + snapshot.data[index].matriz.descricao,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('COD: ' +
                              snapshot.data[index].id.toString() +
                              ' Min: ' +
                              snapshot.data[index].tamanhoMin.toString() +
                              ' Min: ' +
                              snapshot.data[index].tamanhoMax.toString() +
                              '\n' +
                              'Marca: ' +
                              snapshot.data[index].modelo.marca.descricao +
                              '\n' +
                              'Modelo: ' +
                              snapshot.data[index].modelo.descricao +
                              '\n' +
                              'Pais: ' +
                              snapshot.data[index].pais.descricao),
                          trailing: Container(
                            width: 100,
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditarRegraPage(
                                                    regra: snapshot.data[index],
                                                  )));
                                    },
                                    icon:
                                        Icon(Icons.edit, color: Colors.orange)),

                                IconButton(
                                    onPressed: () async {
                                      Provider.of<RegraApi>(context,
                                              listen: false)
                                          .delete(snapshot.data[index].id);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                                // IconButton(onPressed: (){}, icon: Icon(Icons.arrow_right, color: Colors.black,))
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetalhesRegraPage(
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
                builder: (context) => AdicionarRegraPage(), //AddCarcacaPage(),
              ));
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

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
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Wrap(
                            children: [
                              Text.rich(
                                  TextSpan(
                                      text: 'Medida: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text:  snapshot.data[index].medida.descricao,
                                          style: TextStyle(fontWeight: FontWeight.normal),
                                        )
                                      ]
                                  )
                              ),
                              Padding(
                                padding: EdgeInsets.all(3),
                              ),
                              Text.rich(
                                  TextSpan(
                                      text: 'Marca: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text:  snapshot.data[index].modelo.marca.descricao,
                                          style: TextStyle(fontWeight: FontWeight.normal),
                                        )
                                      ]
                                  )
                              ),
                              Padding(
                                padding: EdgeInsets.all(3),
                              ),
                              Text.rich(
                                  TextSpan(
                                      text: 'Modelo: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text:  snapshot.data[index].modelo.descricao,
                                          style: TextStyle(fontWeight: FontWeight.normal),
                                        )
                                      ]
                                  )
                              ),
                              Padding(
                                padding: EdgeInsets.all(3),
                              ),
                              Text.rich(
                                  TextSpan(
                                      text: 'País: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text:  snapshot.data[index].pais.descricao,
                                          style: TextStyle(fontWeight: FontWeight.normal),
                                        )
                                      ]
                                  )
                              ),
                              Padding(
                                padding: EdgeInsets.all(3),
                              ),
                              Text.rich(
                                  TextSpan(
                                      text: 'Camelback: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text:  snapshot.data[index].camelback.descricao,
                                          style: TextStyle(fontWeight: FontWeight.normal),
                                        )
                                      ]
                                  )
                              ),
                              Text.rich(
                                  TextSpan(
                                      text: 'COD: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text:  snapshot.data[index].id.toString(),
                                          style: TextStyle(fontWeight: FontWeight.normal),
                                        )
                                      ]
                                  )
                              ),
                              Padding(
                                padding: EdgeInsets.all(3),
                              ),
                              Text.rich(
                                  TextSpan(
                                      text: 'Min: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text:  snapshot.data[index].tamanhoMin.toString(),
                                          style: TextStyle(fontWeight: FontWeight.normal),
                                        )
                                      ]
                                  )
                              ),
                              Padding(
                                padding: EdgeInsets.all(3),
                              ),
                              Text.rich(
                                  TextSpan(
                                      text: 'Máx: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text:  snapshot.data[index].tamanhoMax.toString(),
                                          style: TextStyle(fontWeight: FontWeight.normal),
                                        )
                                      ]
                                  )
                              ),
                            ],
                          ),
                          // subtitle: Text('COD: ' +
                          //     snapshot.data[index].id.toString() +
                          //     ' Min: ' +
                          //     snapshot.data[index].tamanhoMin.toString() +
                          //     ' Min: ' +
                          //     snapshot.data[index].tamanhoMax.toString() +
                          //     '\n' +
                          //     'Marca: ' +
                          //     snapshot.data[index].modelo.marca.descricao +
                          //     '\n' +
                          //     'Modelo: ' +
                          //     snapshot.data[index].modelo.descricao +
                          //     '\n' +
                          //     'Pais: ' +
                          //     snapshot.data[index].pais.descricao + ' | Camelback: ' +
                          //     snapshot.data[index].camelback.descricao
                          // ),
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

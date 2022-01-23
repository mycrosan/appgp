import 'package:GPPremium/models/responseMessage.dart';
import 'package:GPPremium/screens/carcaca/adicionar.dart';
import 'package:GPPremium/screens/carcaca/editdatawidget.dart';
import 'package:GPPremium/service/carcacaapi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'detailwidget.dart';

class ListaCarcaca extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var carcacasAPI = new CarcacaApi();
    //Fica escutando as mudanças
    final CarcacaApi carcacas = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Carcaças'),
        // actions: [
        //   PopupMenuButton(
        //     itemBuilder: (context) => [
        //       PopupMenuItem(
        //         child: Text("Adicionar"),
        //         value: 1,
        //       ),
        //       PopupMenuItem(
        //         child: Text("Remover"),
        //         value: 1,
        //       )
        //     ],
        //     onSelected: (int menu) {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) =>
        //                 AdicionarCarcacaPage(), //AddCarcacaPage(),
        //           ));
        //     },
        //   )
        // ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
            future: carcacasAPI.getAll(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text('Etiqueta: ' +
                              snapshot.data[index].numeroEtiqueta +
                              " id: " +
                              snapshot.data[index].id.toString()),
                          subtitle: Text('Medida: ' +
                              snapshot.data[index].medida.descricao +
                              "\n"
                                  'DOT: ' +
                              snapshot.data[index].dot +
                              "\n"
                                  'Modelo: ' +
                              snapshot.data[index].modelo.descricao),
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
                                                  EditarCarcacaPage(
                                                    carcacaEdit:
                                                        snapshot.data[index],
                                                  )));
                                    },
                                    icon:
                                        Icon(Icons.edit, color: Colors.orange)),

                                IconButton(
                                    onPressed: () async {
                                      Provider.of<CarcacaApi>(context,
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
                                    builder: (context) => DetalhesCarcacaPage(
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
                    AdicionarCarcacaPage(), //AddCarcacaPage(),
              ));
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

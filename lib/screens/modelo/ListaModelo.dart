import 'package:GPPremium/service/modeloapi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'adicionar.dart';
import 'detailwidget.dart';
import 'editdatawidget.dart';

class ListaModelo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var modeloAPI = new ModeloApi();

    final ModeloApi modelo = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Modelo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
            future: modeloAPI.getAll(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
               snapshot.data;
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text('ID: ' +
                              snapshot.data[index].id.toString()),
                          subtitle: Text('Descricao: ' +
                              snapshot.data[index].descricao
                          ),
                          trailing: Container(
                            width: 100,
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditModeloPage(
                                                modeloEdit: snapshot.data[index],
                                              )));
                                    },
                                    icon:
                                    Icon(Icons.edit, color: Colors.orange)),

                                IconButton(onPressed: () async {

                                  Provider.of<ModeloApi>(context, listen: false).delete(snapshot.data[index].id);

                                }, icon: Icon(Icons.delete, color: Colors.red,)),
                                // IconButton(onPressed: (){}, icon: Icon(Icons.arrow_right, color: Colors.black,))
                              ],
                            ),
                          ),

                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetalhesModeloPage(
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
                    AdicionarModeloPage(), //AddCarcacaPage(),
              ));
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

import 'package:GPPremium/service/camelbackapi.dart';
import 'package:GPPremium/service/paisapi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'adicionar.dart';
import 'detailwidget.dart';
import 'editdatawidget.dart';

class ListaCamelback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var camelbackAPI = new CamelbackApi();

    final CamelbackApi pais = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Camelback'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
            future: camelbackAPI.getAll(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title:
                              Text('ID: ' + snapshot.data[index].id.toString()),
                          subtitle: Text(
                              'Descricao: ' + snapshot.data[index].descricao),
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
                                                  EditCamelBackPage(
                                                    camelbackEdit:
                                                        snapshot.data[index],
                                                  )));
                                    },
                                    icon:
                                        Icon(Icons.edit, color: Colors.orange)),
                                IconButton(
                                    onPressed: () async {
                                      Provider.of<CamelbackApi>(context,
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
                                    builder: (context) => DetalhesCamelbackPage(
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
                    AdicionarCamelbackPage(), //AddCarcacaPage(),
              ));
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

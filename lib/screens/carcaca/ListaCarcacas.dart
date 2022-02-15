import 'package:GPPremium/models/responseMessage.dart';
import 'package:GPPremium/screens/carcaca/adicionar.dart';
import 'package:GPPremium/screens/carcaca/editdatawidget.dart';
import 'package:GPPremium/service/carcacaapi.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'detailwidget.dart';

class ListaCarcaca extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var carcacasAPI = new CarcacaApi();

    TextEditingController textEditingControllerCarcaca;
    textEditingControllerCarcaca = MaskedTextController(mask: '000000');

    //Fica escutando as mudanças
    final CarcacaApi carcacas = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Carcaças'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdicionarCarcacaPage(),
                  ));
              // do something
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 20.0),
              child: TextFormField(
                controller: textEditingControllerCarcaca,
                decoration: InputDecoration(
                  labelText: "Informe o número da etiqueta",
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (String newValue) async {
                  if (newValue.length >= 6) {
                    var response = await CarcacaApi().consultaCarcaca(newValue);
                    print(response);
                    if (response != null) {
                    } else {
                      responseMessage value = response;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(value.message),
                            content: Text(value.debugMessage),
                            actions: [
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
            Expanded(
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
                                                          carcacaEdit: snapshot
                                                              .data[index],
                                                        )));
                                          },
                                          icon: Icon(Icons.edit,
                                              color: Colors.orange)),

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
                                          builder: (context) =>
                                              DetalhesCarcacaPage(
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
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) =>
      //               AdicionarCarcacaPage(), //AddCarcacaPage(),
      //         ));
      //   },
      //   child: Icon(
      //     Icons.add,
      //   ),
      // ),
    );
  }
}

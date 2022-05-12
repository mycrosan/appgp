import 'package:GPPremium/components/Loading.dart';
import 'package:GPPremium/models/carcaca.dart';
import 'package:GPPremium/screens/carcaca/adicionar.dart';
import 'package:GPPremium/screens/carcaca/editdatawidget.dart';
import 'package:GPPremium/screens/producao/printWidget.dart';
import 'package:GPPremium/service/carcacaapi.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'detailwidget.dart';

class ListaCarcaca extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaCarcacaState();
  }
}

class ListaCarcacaState extends State<ListaCarcaca> {
  @override
  Widget build(BuildContext context) {
    var carcacasAPI = new CarcacaApi();

    final DinamicListCard listCards = DinamicListCard();

    TextEditingController textEditingControllerCarcaca;
    textEditingControllerCarcaca = MaskedTextController(mask: '000000');
    Carcaca _responseValue;
    List listaCarcaca = [];
    var _isList = ValueNotifier<bool>(true);

    //Fica escutando as mudanças
    final CarcacaApi carcacas = Provider.of(context);

    @override
    void initState() {
      super.initState();

      this.setState(() {});
    }

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
                    print(_responseValue != null);

                    _responseValue = response;

                    _isList.value = false;

                    _isList.notifyListeners();

                    if (_responseValue != null) {
                      print('chegou no nulo');
                    } else {
                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return AlertDialog(
                      //       title: Text(value.message),
                      //       content: Text(value.debugMessage),
                      //       actions: [
                      //         TextButton(
                      //           child: Text("OK"),
                      //           onPressed: () {
                      //             Navigator.pop(context);
                      //           },
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // );
                    }
                  } else {
                    _isList.value = true;
                    _isList.notifyListeners();
                  }
                },
              ),
            ),
            ValueListenableBuilder(
                valueListenable: _isList,
                builder: (_, __, ___) {
                  return Visibility(
                      visible: !_isList.value,
                      child: _responseValue != null
                          ? listCards.cardResponse(_responseValue, context)
                          : Text('Sem Informações'));
                }),
            Visibility(
              visible: _isList.value,
              child: _exibirLista(context, carcacasAPI) != null
                  ? _exibirLista(context, carcacasAPI)
                  : 'Aguardando..',
            ),
          ],
        ),
      ),
    );
  }

  Widget _exibirLista(context, obj) {
    // return Text("data");
    return Expanded(
      child: FutureBuilder(
          future: obj.getAll(),
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
                                  icon: Icon(Icons.edit, color: Colors.orange)),

                              IconButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Excluir"),
                                          content: Text(
                                              "Tem certeza que deseja excluir o item ${snapshot.data[index].numeroEtiqueta}"),
                                          actions: [
                                            ElevatedButton(
                                              child: Text("Sim"),
                                              onPressed: () {
                                                Provider.of<CarcacaApi>(context,
                                                        listen: false)
                                                    .delete(snapshot
                                                        .data[index].id);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ElevatedButton(
                                              child: Text("Não"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                        ;
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                              // IconButton(
                              //     onPressed: () {
                              //       Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //               builder: (context) =>
                              //                   PrintPage(
                              //                     carcacaPrint:
                              //                     snapshot.data[index],
                              //                   )));
                              //     },
                              //     icon: Icon(Icons.print, color: Colors.greenAccent)),
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
              return cicleLoading(context);
            }
          }),
    );
  }
}

class DinamicListCard extends ChangeNotifier {
  cardResponse(_responseValue, context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white70,
      child: ListTile(
        title: Text('Etiqueta: ' +
            _responseValue.numeroEtiqueta +
            " id: " +
            _responseValue.id.toString()),
        subtitle: Text('Medida: ' +
            _responseValue.medida.descricao +
            "\n"
                'DOT: ' +
            _responseValue.dot +
            "\n"
                'Modelo: ' +
            _responseValue.modelo.descricao),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditarCarcacaPage(
                                  carcacaEdit: _responseValue,
                                )));
                  },
                  icon: Icon(Icons.edit, color: Colors.orange)),

              IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Excluir"),
                          content: Text(
                              "Tem certeza que deseja excluir o item ${_responseValue.numeroEtiqueta}"),
                          actions: [
                            ElevatedButton(
                              child: Text("Sim"),
                              onPressed: () {
                                Provider.of<CarcacaApi>(context, listen: false)
                                    .delete(_responseValue.id);
                                Navigator.pop(context);
                              },
                            ),
                            ElevatedButton(
                              child: Text("Não"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                        ;
                      },
                    );
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
                        id: _responseValue.id,
                      )));
        },
      ),
    );
  }
}

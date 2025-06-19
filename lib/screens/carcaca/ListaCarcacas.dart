import 'package:GPPremium/components/Loading.dart';
import 'package:GPPremium/models/carcaca.dart';
import 'package:GPPremium/screens/carcaca/adicionar.dart';
import 'package:GPPremium/screens/carcaca/editdatawidget.dart';
import 'package:GPPremium/service/carcacaapi.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import '../../components/snackBar.dart';
import '../../models/responseMessage.dart';
import 'detailwidget.dart';

class ListaCarcaca extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaCarcacaState();
  }
}

class ListaCarcacaState extends State<ListaCarcaca> {
  TextEditingController textEditingControllerCarcaca;
  Carcaca _responseValue;
  var _isList = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    textEditingControllerCarcaca = MaskedTextController(mask: '000000');
  }

  Future<void> _scanBarcode() async {
    String barcodeScanRes = '';

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#FF6666',
        'Cancelar',
        true,
        ScanMode.BARCODE,
      );
    } catch (e) {
      print('Erro ao escanear: $e');
    }

    if (barcodeScanRes != '-1' && mounted) {
      // Preenche zeros à esquerda
      String codigoFormatado = barcodeScanRes.padLeft(6, '0');

      setState(() {
        textEditingControllerCarcaca.text = codigoFormatado;
      });

      var response = await CarcacaApi().consultaCarcaca(codigoFormatado);
      if (response is Carcaca) {
        _responseValue = response;
        _isList.value = true;
        _isList.notifyListeners();
      } else if (response is responseMessage) {
        ScaffoldMessenger.of(context)
            .showSnackBar(warningMessage(context, response.message));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    var carcacasAPI = new CarcacaApi();
    final DinamicListCard listCards = DinamicListCard();
    final CarcacaApi carcacas = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          child: Row(children: [
            Expanded(child: Text("Carcaça")),
            Expanded(
              child: Container(
                color: Colors.white,
                height: 30.0,
                child: TextFormField(
                  controller: textEditingControllerCarcaca,
                  decoration: InputDecoration(
                    hintText: 'Nº etiqueta',
                    contentPadding: EdgeInsets.all(10.0),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (String newValue) async {
                      if (newValue.length >= 1) {
                        String codigoFormatado = newValue.padLeft(6, '0');

                        var response = await CarcacaApi().consultaCarcaca(codigoFormatado);

                        if (response is Carcaca) {
                          _responseValue = response;
                          _isList.value = true;
                          _isList.notifyListeners();
                        } else if (response is responseMessage) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(warningMessage(context, response.message));
                        }
                      } else {
                        _isList.value = false;
                        _isList.notifyListeners();
                      }
                    }

                ),
              ),
            )
          ]),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner, color: Colors.white),
            onPressed: () {
              _scanBarcode();
            },
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdicionarCarcacaPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: _isList,
              builder: (_, __, ___) {
                return Visibility(
                  visible: _isList.value,
                  child: _responseValue != null
                      ? listCards.cardResponse(_responseValue, context)
                      : Text(''),
                );
              },
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
                            subtitle: Text(
                              'Medida: ' +
                                  snapshot.data[index].medida.descricao +
                                  "\nDOT: " +
                                  snapshot.data[index].dot +
                                  ' País: ' +
                                  snapshot.data[index].pais.descricao +
                                  "\nModelo: " +
                                  snapshot.data[index].modelo.descricao,
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
                                          builder: (context) =>
                                              EditarCarcacaPage(
                                                carcacaEdit:
                                                snapshot.data[index],
                                              ),
                                        ),
                                      );
                                    },
                                    icon:
                                    Icon(Icons.edit, color: Colors.orange),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Excluir"),
                                            content: Text(
                                              "Tem certeza que deseja excluir o item ${snapshot.data[index].numeroEtiqueta}?",
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                child: Text("Sim"),
                                                onPressed: () {
                                                  Provider.of<CarcacaApi>(
                                                    context,
                                                    listen: false,
                                                  ).delete(
                                                      snapshot.data[index].id);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                      deleteMessage(
                                                          context));
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
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetalhesCarcacaPage(
                                    id: snapshot.data[index].id,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return cicleLoading(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
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
        subtitle: Text(
          'Medida: ' +
              _responseValue.medida.descricao +
              "\nDOT: " +
              _responseValue.dot +
              "\nModelo: " +
              _responseValue.modelo.descricao,
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
                      builder: (context) => EditarCarcacaPage(
                        carcacaEdit: _responseValue,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.edit, color: Colors.orange),
              ),
              IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Excluir"),
                        content: Text(
                          "Tem certeza que deseja excluir o item ${_responseValue.numeroEtiqueta}?",
                        ),
                        actions: [
                          ElevatedButton(
                            child: Text("Sim"),
                            onPressed: () {
                              Provider.of<CarcacaApi>(context, listen: false)
                                  .delete(_responseValue.id);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(deleteMessage(context));
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
                    },
                  );
                },
                icon: Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalhesCarcacaPage(
                id: _responseValue.id,
              ),
            ),
          );
        },
      ),
    );
  }
}

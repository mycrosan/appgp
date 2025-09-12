import 'package:GPPremium/models/marca.dart';
import 'package:GPPremium/models/modelo.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:GPPremium/service/marcaapi.dart';
import 'package:GPPremium/service/modeloapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ListaModelo.dart';

class AdicionarModeloPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AdicionarModeloPageState();
  }
}

class AdicionarModeloPageState extends State<AdicionarModeloPage> {
  final _formkey = GlobalKey<FormState>();

  late TextEditingController textEditingControllerModelo;
  late Modelo modelo;

  //Marca
  List<Marca> marcaList = [];
  late Marca marcaSelected;

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Added to favorite'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  // @override
  // void dispose() {
  // Clean up the controller when the Widget is disposed
  // textEditingControllerPneuRaspado.dispose();
  // super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    textEditingControllerModelo = TextEditingController();
    modelo = Modelo(id: 0, descricao: '');

    MarcaApi().getAll().then((List<Marca> value) {
      setState(() {
        marcaList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modelo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: _construirFormulario(context),
        ),
      ),
    );
  }

  Widget _construirFormulario(context) {
    // var regraApi = new RegraApi();
    return Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            controller: textEditingControllerModelo,
            decoration: InputDecoration(
              labelText: "Modelo",
            ),
            // validator: (value) =>
            // value.length == 0 ? 'Não pode ser nulo' : null,
            onChanged: (String newValue) {
              setState(() {
                modelo.descricao = newValue;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.all(10),
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "Marca",
            ),
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            value: marcaSelected,
            isExpanded: true,
            onChanged: (Marca marca) {
              setState(() {
                marcaSelected = marca;
                modelo.marca = marcaSelected;
              });
            },
            items: marcaList.map((Marca marca) {
              return DropdownMenuItem(
                value: marca,
                child: Text(marca.descricao),
              );
            }).toList(),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/home");
                },
              )),
              Padding(padding: EdgeInsets.all(5)),
              Expanded(
                  child: ElevatedButton(
                child: Text("Salvar"),
                onPressed: () async {
                  if (_formkey.currentState.validate()) {
                    var response = await ModeloApi().create(modelo);

                    if (response is Modelo && response != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaModelo(),
                        ),
                      );
                    } else {
                      responseMessage value =
                          response != null ? response : null;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Atenção! \n" + value.message),
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
              )),
            ],
          )
        ],
      ),
    );
  }
}

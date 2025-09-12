import 'package:GPPremium/models/matriz.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:GPPremium/screens/matriz/ListaMatriz.dart';
import 'package:GPPremium/service/matrizapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdicionarMatrizPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AdicionarMatrizPageState();
  }
}

class AdicionarMatrizPageState extends State<AdicionarMatrizPage> {

  final _formkey = GlobalKey<FormState>();

  late TextEditingController textEditingControllerMatriz;
  late Matriz matriz;

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

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    // textEditingControllerPneuRaspado.dispose();
    // super.dispose();
  }

  @override
  void initState() {
    super.initState();
    textEditingControllerMatriz = TextEditingController();
    matriz = Matriz(id: 0, descricao: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matriz'),
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
          Row(children: [
            Expanded(
              child: TextFormField(
                controller: textEditingControllerMatriz,
                decoration: InputDecoration(
                  labelText: "Matriz",
                ),
                // validator: (value) =>
                // value.length == 0 ? 'Não pode ser nulo' : null,
                onChanged: (String newValue) {
                  setState(() {
                    matriz.descricao = newValue;
                  });
                },
              ),
            ),
            ],
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

                    var response = await MatrizApi().create(matriz);

                    if (response is Matriz && response != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaMatriz(),
                        ),
                      );
                    } else {
                      responseMessage value = response != null ? response : null;
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

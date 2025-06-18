import 'package:GPPremium/models/medida.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:GPPremium/service/medidaapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ListaMedida.dart';

class AdicionarMedidaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AdicionarMedidaPageState();
  }
}

class AdicionarMedidaPageState extends State<AdicionarMedidaPage> {

  final _formkey = GlobalKey<FormState>();

  TextEditingController textEditingControllerMedida;
  Medida medida;

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
    textEditingControllerMedida = TextEditingController();
    medida = Medida();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medida'),
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
                controller: textEditingControllerMedida,
                decoration: InputDecoration(
                  labelText: "Medida",
                ),
                // validator: (value) =>
                // value.length == 0 ? 'Não pode ser nulo' : null,
                onChanged: (String newValue) {
                  setState(() {
                    medida.descricao = newValue;
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

                    var response = await MedidaApi().create(medida);

                    if (response is Medida && response != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaMedida(),
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

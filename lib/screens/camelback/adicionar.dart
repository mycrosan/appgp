import 'package:GPPremium/models/camelback.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:GPPremium/screens/camelback/ListaCamelback.dart';
import 'package:GPPremium/service/camelbackapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdicionarCamelbackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AdicionarCamelbackPageState();
  }
}

class AdicionarCamelbackPageState extends State<AdicionarCamelbackPage> {

  final _formkey = GlobalKey<FormState>();

  late TextEditingController textEditingControllerCamelback;
  late Camelback camelback;

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
    textEditingControllerCamelback = TextEditingController();
    camelback = Camelback(id: 0, descricao: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camelback'),
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
                controller: textEditingControllerCamelback,
                decoration: InputDecoration(
                  labelText: "Camelback",
                ),
                // validator: (value) =>
                // value.length == 0 ? 'Não pode ser nulo' : null,
                onChanged: (String newValue) {
                  setState(() {
                    camelback.descricao = newValue;
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

                    var response = await CamelbackApi().create(camelback);

                    if (response is Camelback && response != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaCamelback(),
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

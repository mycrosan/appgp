import 'package:GPPremium/models/espessuramento.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:GPPremium/screens/espessuramento/ListaEspessuramento.dart';
import 'package:GPPremium/service/espessuramento.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdicionarEspessuramentoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AdicionarEspessuramentoPageState();
  }
}

class AdicionarEspessuramentoPageState extends State<AdicionarEspessuramentoPage> {

  final _formkey = GlobalKey<FormState>();

  TextEditingController textEditingControllerEspessuramento;
  Espessuramento espessuramento;

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
    textEditingControllerEspessuramento = TextEditingController();
    espessuramento = Espessuramento();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Espessuramento'),
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
                controller: textEditingControllerEspessuramento,
                decoration: InputDecoration(
                  labelText: "Espessuramento",
                ),
                // validator: (value) =>
                // value.length == 0 ? 'Não pode ser nulo' : null,
                onChanged: (String newValue) {
                  setState(() {
                    espessuramento.descricao = newValue;
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

                    var response = await EspessuramentoApi().create(espessuramento);

                    if (response is Espessuramento && response != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaEspessuramento(),
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

import 'package:GPPremium/models/pais.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:GPPremium/screens/pais/ListaPais.dart';
import 'package:GPPremium/service/paisapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdicionarPaisPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AdicionarPaisPageState();
  }
}

class AdicionarPaisPageState extends State<AdicionarPaisPage> {

  final _formkey = GlobalKey<FormState>();

  TextEditingController textEditingControllerPais;
  Pais pais;

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
    textEditingControllerPais = TextEditingController();
    pais = Pais();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pais'),
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
                controller: textEditingControllerPais,
                decoration: InputDecoration(
                  labelText: "Pais",
                ),
                // validator: (value) =>
                // value.length == 0 ? 'Não pode ser nulo' : null,
                onChanged: (String newValue) {
                  setState(() {
                    pais.descricao = newValue;
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

                    var response = await PaisApi().create(pais);

                    if (response is Pais && response != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaPais(),
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

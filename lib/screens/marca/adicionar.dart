import 'package:GPPremium/models/marca.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:GPPremium/service/marcaapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ListaMarca.dart';

class AdicionarMarcaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AdicionarMarcaPageState();
  }
}

class AdicionarMarcaPageState extends State<AdicionarMarcaPage> {

  final _formkey = GlobalKey<FormState>();

  late TextEditingController textEditingControllerMarca;
  late Marca marca;

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
    textEditingControllerMarca = TextEditingController();
    marca = Marca(id: 0, descricao: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marca'),
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
                controller: textEditingControllerMarca,
                decoration: InputDecoration(
                  labelText: "Marca",
                ),
                // validator: (value) =>
                // value.length == 0 ? 'Não pode ser nulo' : null,
                onChanged: (String newValue) {
                  setState(() {
                    marca.descricao = newValue;
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

                    var response = await MarcaApi().create(marca);

                    if (response is Marca && response != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaMarca(),
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

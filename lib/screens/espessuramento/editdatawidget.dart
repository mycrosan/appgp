import 'package:GPPremium/models/espessuramento.dart';
import 'package:GPPremium/screens/espessuramento/ListaEspessuramento.dart';
import 'package:GPPremium/service/espessuramento.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditEspessuramentoPage extends StatefulWidget {
  int id;
  Espessuramento espessuramentoEdit;

  EditEspessuramentoPage({Key key, this.espessuramentoEdit}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditEspessuramentoPageState();
  }
}

class EditEspessuramentoPageState extends State<EditEspessuramentoPage> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController textEditingControllerEspessuramento;
  Espessuramento espessuramento;

  //Espessuramento
  List<Espessuramento> espessuramentoList = [];
  Espessuramento espessuramentoSelected;

  @override
  void initState() {
    super.initState();
    textEditingControllerEspessuramento = new TextEditingController();
    espessuramento = new Espessuramento();

    EspessuramentoApi().getAll().then((List<Espessuramento> value) {
      setState(() {
        espessuramentoList = value;
      });
    });
    setState(() {
      textEditingControllerEspessuramento.text =
          widget.espessuramentoEdit.descricao;
      espessuramento = widget.espessuramentoEdit;
    });
  }

  @override
  void dispose() {
    // textEditingControllerMarca.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var espessuramentoApi = new EspessuramentoApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Espessuramento'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: textEditingControllerEspessuramento,
                    decoration: InputDecoration(
                      labelText: "Espessuramento",
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        espessuramento.descricao = newValue;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        child: Text("Cancelar"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListaEspessuramento(),
                            ),
                          );
                        },
                      )),
                      Padding(padding: EdgeInsets.all(5)),
                      Expanded(
                          child: ElevatedButton(
                        child: Text("Atualizar"),
                        onPressed: () async {
                          var espessuramentoApi = new EspessuramentoApi();
                          var response =
                              await espessuramentoApi.update(espessuramento);
                          print(response);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListaEspessuramento(),
                            ),
                          );
                        },
                      )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

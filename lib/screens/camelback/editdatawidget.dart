import 'package:GPPremium/models/camelback.dart';
import 'package:GPPremium/service/camelbackapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ListaCamelback.dart';

// ignore: must_be_immutable
class EditCamelBackPage extends StatefulWidget {
  int id;
  Camelback camelbackEdit;

  EditCamelBackPage({Key key, this.camelbackEdit}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditDetalhesPaisPageState();
  }
}

class EditDetalhesPaisPageState extends State<EditCamelBackPage> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController textEditingControllerCamelback;
  Camelback camelback;

  //camelback
  List<Camelback> camelbackList = [];
  Camelback camelbackSelected;

  @override
  void initState() {
    super.initState();
    textEditingControllerCamelback = new TextEditingController();
    camelback = new Camelback();

    CamelbackApi().getAll().then((List<Camelback> value) {
      setState(() {
        camelbackList = value;
      });
    });
    setState(() {
      textEditingControllerCamelback.text = widget.camelbackEdit.descricao;
      camelback = widget.camelbackEdit;
    });
  }

  @override
  void dispose() {
    // textEditingControllerPais.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var camelbackApi = new CamelbackApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Camelback'),
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
                    controller: textEditingControllerCamelback,
                    decoration: InputDecoration(
                      labelText: "Camelback",
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        camelback.descricao = newValue;
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
                              builder: (context) => ListaCamelback(),
                            ),
                          );
                        },
                      )),
                      Padding(padding: EdgeInsets.all(5)),
                      Expanded(
                          child: ElevatedButton(
                        child: Text("Atualizar"),
                        onPressed: () async {
                          var paisApi = new CamelbackApi();
                          var response = await paisApi.update(camelback);
                          print(response);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListaCamelback(),
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

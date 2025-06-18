import 'package:GPPremium/models/antiquebra.dart';
import 'package:GPPremium/models/marca.dart';
import 'package:GPPremium/screens/antiquebra/ListaAntiquebra.dart';
import 'package:GPPremium/service/antiquebraapi.dart';
import 'package:GPPremium/service/marcaapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditAntiquebraPage extends StatefulWidget {
  int id;
  Antiquebra antiquebraEdit;

  EditAntiquebraPage({Key key, this.antiquebraEdit}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditAntiquebraPageState();
  }
}

class EditAntiquebraPageState extends State<EditAntiquebraPage> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController textEditingControllerAntiquebra;
  Antiquebra antiquebra;

  //Antiquebra
  List<Marca> antiquebraList = [];
  Antiquebra antiquebraSelected;

  @override
  void initState() {
    super.initState();
    textEditingControllerAntiquebra = new TextEditingController();
    antiquebra = new Antiquebra();

    MarcaApi().getAll().then((List<Marca> value) {
      setState(() {
        antiquebraList = value;
      });
    });
    setState(() {
      textEditingControllerAntiquebra.text = widget.antiquebraEdit.descricao;
      antiquebra = widget.antiquebraEdit;
    });
  }

  @override
  void dispose() {
    // textEditingControllerMarca.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var antiquebraApi = new AntiquebraApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Antiquebra'),
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
                    controller: textEditingControllerAntiquebra,
                    decoration: InputDecoration(
                      labelText: "Antiquebra",
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        antiquebra.descricao = newValue;
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
                              builder: (context) => ListaAntiquebra(),
                            ),
                          );
                        },
                      )),
                      Padding(padding: EdgeInsets.all(5)),
                      Expanded(
                          child: ElevatedButton(
                        child: Text("Atualizar"),
                        onPressed: () async {
                          var antiquebraApi = new AntiquebraApi();
                          var response = await antiquebraApi.update(antiquebra);
                          print(response);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListaAntiquebra(),
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

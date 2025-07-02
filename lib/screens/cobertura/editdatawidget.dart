import 'package:GPPremium/models/producao.dart';
import 'package:GPPremium/service/paisapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../service/producaoapi.dart';
import 'ListaCobertura.dart';

// ignore: must_be_immutable
class EditCoberturaPage extends StatefulWidget {
  int id;
  Producao coberturaEdit;

  EditCoberturaPage({Key key, this.coberturaEdit}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditCoberturaPageState();
  }
}

class EditCoberturaPageState extends State<EditCoberturaPage> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController textEditingControllerCobertura;
  Producao cobertura;

  //Cobertura
  List<Producao> coberturaList = [];
  Producao coberturaSelected;

  @override
  void initState() {
    super.initState();
    textEditingControllerCobertura = new TextEditingController();
    cobertura = new Producao();

    ProducaoApi().getAll().then((List<Producao> value) {
      setState(() {
        coberturaList = value;
      });
    });
    setState(() {
      textEditingControllerCobertura.text = widget.coberturaEdit.carcaca.modelo.descricao;
      cobertura = widget.coberturaEdit;
    });
  }

  @override
  void dispose() {
    // textEditingControllerCobertura.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var paisApi = new PaisApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Cobertura'),
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
                    controller: textEditingControllerCobertura,
                    decoration: InputDecoration(
                      labelText: "Cobertura",
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        cobertura.carcaca.modelo.descricao = newValue;
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
                                  builder: (context) => ListaCobertura(),
                                ),
                              );
                            },
                          )),
                      Padding(padding: EdgeInsets.all(5)),
                      Expanded(
                          child: ElevatedButton(
                            child: Text("Atualizar"),
                            onPressed: () async {
                              var coberturaApi = new ProducaoApi();
                              var response = await coberturaApi.update(cobertura);
                              print(response);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListaCobertura(),
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

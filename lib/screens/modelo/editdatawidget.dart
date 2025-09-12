import 'package:GPPremium/models/modelo.dart';
import 'package:GPPremium/models/pais.dart';
import 'package:GPPremium/screens/modelo/ListaModelo.dart';
import 'package:GPPremium/screens/pais/ListaPais.dart';
import 'package:GPPremium/service/modeloapi.dart';
import 'package:GPPremium/service/paisapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditModeloPage extends StatefulWidget {
  int id = 0;
  Modelo modeloEdit;

  EditModeloPage({Key key, this.modeloEdit}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditModeloPageState();
  }
}

class EditModeloPageState extends State<EditModeloPage> {
  int id = 0;

  final _formkey = GlobalKey<FormState>();

  late TextEditingController textEditingControllerModelo;
  late Modelo modelo;

  //Modelo
  List<Modelo> modeloList = [];
  late Modelo modeloSelected;

  @override
  void initState() {
    super.initState();
    textEditingControllerModelo = new TextEditingController();
    modelo = Modelo(id: 0, descricao: '');

    ModeloApi().getAll().then((List<Modelo> value) {
      setState(() {
        modeloList = value;
      });
    });
    setState(() {
      textEditingControllerModelo.text = widget.modeloEdit.descricao;
      modelo = widget.modeloEdit;
    });
  }

  @override
  void dispose() {
    // textEditingControllerModelo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var modeloApi = new ModeloApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Modelo'),
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
                    controller: textEditingControllerModelo,
                    decoration: InputDecoration(
                      labelText: "Modelo",
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        modelo.descricao = newValue;
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
                                  builder: (context) => ListaModelo(),
                                ),
                              );
                            },
                          )),
                      Padding(padding: EdgeInsets.all(5)),
                      Expanded(
                          child: ElevatedButton(
                            child: Text("Atualizar"),
                            onPressed: () async {
                              var modeloApi = new ModeloApi();
                              var response = await modeloApi.update(modelo);
                              print(response);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListaModelo(),
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

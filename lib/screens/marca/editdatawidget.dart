import 'package:GPPremium/models/marca.dart';
import 'package:GPPremium/service/marcaapi.dart';
import 'package:GPPremium/service/paisapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ListaMarca.dart';

// ignore: must_be_immutable
class EditMarcaPage extends StatefulWidget {
  int id;
  Marca marcaEdit;

  EditMarcaPage({Key key, this.marcaEdit}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditMarcaPageState();
  }
}

class EditMarcaPageState extends State<EditMarcaPage> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController textEditingControllerMarca;
  Marca marca;

  //Marca
  List<Marca> marcaList = [];
  Marca marcaSelected;

  @override
  void initState() {
    super.initState();
    textEditingControllerMarca = new TextEditingController();
    marca = new Marca();

    MarcaApi().getAll().then((List<Marca> value) {
      setState(() {
        marcaList = value;
      });
    });
    setState(() {
      textEditingControllerMarca.text = widget.marcaEdit.descricao;
      marca = widget.marcaEdit;
    });
  }

  @override
  void dispose() {
    // textEditingControllerMarca.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var paisApi = new PaisApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Marca'),
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
                    controller: textEditingControllerMarca,
                    decoration: InputDecoration(
                      labelText: "Marca",
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        marca.descricao = newValue;
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
                                  builder: (context) => ListaMarca(),
                                ),
                              );
                            },
                          )),
                      Padding(padding: EdgeInsets.all(5)),
                      Expanded(
                          child: ElevatedButton(
                            child: Text("Atualizar"),
                            onPressed: () async {
                              var marcaApi = new MarcaApi();
                              var response = await marcaApi.update(marca);
                              print(response);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListaMarca(),
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

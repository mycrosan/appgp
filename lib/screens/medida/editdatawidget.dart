import 'package:GPPremium/models/medida.dart';
import 'package:GPPremium/screens/pais/ListaPais.dart';
import 'package:GPPremium/service/medidaapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ListaMedida.dart';

// ignore: must_be_immutable
class EditMedidaPage extends StatefulWidget {
  int id;
  Medida medidaEdit;

  EditMedidaPage({Key key, this.medidaEdit}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditMedidaPageState();
  }
}

class EditMedidaPageState extends State<EditMedidaPage> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController textEditingControllerMedida;
  Medida medida;

  //Medida
  List<Medida> medidaList = [];
  Medida medidaSelected;

  @override
  void initState() {
    super.initState();
    textEditingControllerMedida = new TextEditingController();
    medida = new Medida();

    MedidaApi().getAll().then((List<Medida> value) {
      setState(() {
        medidaList = value;
      });
    });
    setState(() {
      textEditingControllerMedida.text = widget.medidaEdit.descricao;
      medida = widget.medidaEdit;
    });
  }

  @override
  void dispose() {
    // textEditingControllerPais.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var medidaApi = new MedidaApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Medida'),
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
                    controller: textEditingControllerMedida,
                    decoration: InputDecoration(
                      labelText: "Medida",
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        medida.descricao = newValue;
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
                                  builder: (context) => ListaPais(),
                                ),
                              );
                            },
                          )),
                      Padding(padding: EdgeInsets.all(5)),
                      Expanded(
                          child: ElevatedButton(
                            child: Text("Atualizar"),
                            onPressed: () async {
                              var paisApi = new MedidaApi();
                              var response = await paisApi.update(medida);
                              print(response);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListaMedida(),
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

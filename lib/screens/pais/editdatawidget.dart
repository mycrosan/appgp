import 'package:GPPremium/models/pais.dart';
import 'package:GPPremium/screens/pais/ListaPais.dart';
import 'package:GPPremium/service/paisapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



// ignore: must_be_immutable
class EditDetalhesPaisPage extends StatefulWidget {
  int id = 0;
  Pais paisEdit;

  EditDetalhesPaisPage({Key key, this.paisEdit}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditDetalhesPaisPageState();
  }
}

class EditDetalhesPaisPageState extends State<EditDetalhesPaisPage> {
  int id = 0;

  final _formkey = GlobalKey<FormState>();

  late TextEditingController textEditingControllerPais;
  late Pais pais;

  //Pais
  List<Pais> paisList = [];
  late Pais paisSelected;

  @override
  void initState() {
    super.initState();
    textEditingControllerPais = new TextEditingController();
    pais = Pais(id: 0, descricao: '');

    PaisApi().getAll().then((List<Pais> value) {
      setState(() {
        paisList = value;
       
      });
    });
    setState(() {
      textEditingControllerPais.text = widget.paisEdit.descricao;
      pais = widget.paisEdit;
    });
  }

  @override
  void dispose() {
    // textEditingControllerPais.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var paisApi = new PaisApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Pais'),
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
                    controller: textEditingControllerPais,
                    decoration: InputDecoration(
                      labelText: "Pais",
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        pais.descricao = newValue;
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
                          var paisApi = new PaisApi();
                          var response = await paisApi.update(pais);
                          print(response);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListaPais(),
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

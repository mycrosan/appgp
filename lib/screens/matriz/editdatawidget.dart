
import 'package:GPPremium/models/matriz.dart';
import 'package:GPPremium/screens/matriz/ListaMatriz.dart';
import 'package:GPPremium/service/matrizapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



// ignore: must_be_immutable
class EditMatrizPage extends StatefulWidget {
  int id = 0;
  Matriz matrizEdit;

  EditMatrizPage({Key key, this.matrizEdit}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditMatrizPageState();
  }
}

class EditMatrizPageState extends State<EditMatrizPage> {
  int id = 0;

  final _formkey = GlobalKey<FormState>();

  late TextEditingController textEditingControllerMatriz;
  late Matriz matriz;

  //Matriz
  List<Matriz> matrizList = [];
  late Matriz matrizSelected;

  @override
  void initState() {
    super.initState();
    textEditingControllerMatriz = new TextEditingController();
    matriz = Matriz(id: 0, descricao: '');

    MatrizApi().getAll().then((List<Matriz> value) {
      setState(() {
        matrizList = value;
      });
    });
    setState(() {
      textEditingControllerMatriz.text = widget.matrizEdit.descricao;
      matriz = widget.matrizEdit;
    });
  }

  @override
  void dispose() {
    // textEditingControllerMatriz.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var matrizApi = new MatrizApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Matriz'),
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
                    controller: textEditingControllerMatriz,
                    decoration: InputDecoration(
                      labelText: "Matriz",
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        matriz.descricao = newValue;
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
                                  builder: (context) => ListaMatriz(),
                                ),
                              );
                            },
                          )),
                      Padding(padding: EdgeInsets.all(5)),
                      Expanded(
                          child: ElevatedButton(
                            child: Text("Atualizar"),
                            onPressed: () async {
                              var matrizApi = new MatrizApi();
                              var response = await matrizApi.update(matriz);
                              print(response);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListaMatriz(),
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

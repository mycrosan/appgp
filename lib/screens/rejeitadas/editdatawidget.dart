import 'package:GPPremium/models/medida.dart';
import 'package:GPPremium/models/modelo.dart';
import 'package:GPPremium/models/pais.dart';

import 'package:GPPremium/service/medidaapi.dart';
import 'package:GPPremium/service/modeloapi.dart';
import 'package:GPPremium/service/paisapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../../models/rejeitadas.dart';
import '../../service/rejeitadasapi.dart';
import 'ListaRejeitadas.dart';

class EditarRejeitadasPage extends StatefulWidget {
  final int id;
  final Rejeitadas? carcacaEdit;

  const EditarRejeitadasPage({Key? key, required this.id, this.carcacaEdit}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditarRejeitadasPageState();
  }
}

class EditarRejeitadasPageState extends State<EditarRejeitadasPage> {
  final _formkey = GlobalKey<FormState>();

  late TextEditingController textEditingControllerDescricao;
  late TextEditingController textEditingControllerMotivo;

  late Rejeitadas carcaca;
  Image? _image;
  bool image_ok = false;

  //Modelo
  List<Modelo> modeloList = [];
  Modelo? modeloSelected;

  //Medida
  List<Medida> medidaList = [];
  Medida? medidaSelected;

  //Pais
  List<Pais> paisList = [];
  Pais? paisSelected;

  @override
  void initState() {
    super.initState();
    textEditingControllerDescricao = new TextEditingController();
    textEditingControllerMotivo = new TextEditingController();
    carcaca = Rejeitadas(
      id: 0,
      modelo: Modelo(id: 0, descricao: '', marca: null),
      medida: Medida(id: 0, descricao: ''),
      pais: Pais(id: 0, descricao: ''),
      motivo: '',
      descricao: ''
    );
    // image = showImage( widget.carcacaEdit.fotos);

    ModeloApi().getAll().then((List<Modelo> value) {
      setState(() {
        modeloList = value;
       
      });
    });

    MedidaApi().getAll().then((List<Medida> value) {
      setState(() {
        medidaList = value;
      
      });
    });

    PaisApi().getAll().then((List<Pais> value) {
      setState(() {
        paisList = value;
       
      });
    });

    setState(() {
      carcaca.id = widget.carcacaEdit?.id ?? 0;
      carcaca.modelo = widget.carcacaEdit?.modelo ?? Modelo(id: 0, descricao: '', marca: null);
      carcaca.medida = widget.carcacaEdit?.medida ?? Medida(id: 0, descricao: '');
      carcaca.pais = widget.carcacaEdit?.pais ?? Pais(id: 0, descricao: '');
      carcaca.motivo = widget.carcacaEdit?.motivo ?? '';
      carcaca.descricao = widget.carcacaEdit?.descricao ?? '';
      textEditingControllerMotivo.text = widget.carcacaEdit?.motivo ?? '';
      textEditingControllerDescricao.text = widget.carcacaEdit?.descricao ?? '';
      modeloSelected = carcaca.modelo;
      medidaSelected = carcaca.medida;
      paisSelected = carcaca.pais;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var carcacaApi = new RejeitadasApi();

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Carcaça Proibida'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  DropdownButtonFormField(
                    // hint: Text("Selecione um modelo"),
                    decoration: InputDecoration(
                      labelText: "Modelo",
                    ),
                    validator: (value) =>
                        value == null ? 'Não pode ser nulo' : null,
                    value: modeloSelected,
                    isExpanded: true,
                    onChanged: (modelo) {
                      setState(() {
                        modeloSelected = modelo;
                        if (modeloSelected != null) carcaca.modelo = modeloSelected!;
                      });
                    },
                    items: modeloList.map((modelo) {
                      return DropdownMenuItem(
                        value: modelo,
                        child: Text(modelo.descricao),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField(
                    // hint: Text("Selecione um medida"),
                    decoration: InputDecoration(
                      labelText: "Medida",
                    ),
                    validator: (value) =>
                        value == null ? 'Não pode ser nulo' : null,
                    value: medidaSelected,
                    isExpanded: true,
                    onChanged: (medida) {
                      setState(() {
                        medidaSelected = medida;
                        if (medidaSelected != null) carcaca.medida = medidaSelected!;
                      });
                    },
                    items: medidaList.map((medida) {
                      return DropdownMenuItem(
                        value: medida,
                        child: Text(medida.descricao),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField(
                    // hint: Text("Selecione um pais"),
                    decoration: InputDecoration(
                      labelText: "País",
                    ),
                    validator: (value) =>
                        value == null ? 'Não pode ser nulo' : null,
                    value: paisSelected,
                    isExpanded: true,
                    onChanged: (pais) {
                      setState(() {
                        paisSelected = pais;
                        if (paisSelected != null) carcaca.pais = paisSelected!;
                      });
                    },
                    items: paisList.map((pais) {
                      return DropdownMenuItem(
                        value: pais,
                        child: Text(pais.descricao),
                      );
                    }).toList(),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  TextFormField(
                    controller: textEditingControllerMotivo,
                    decoration: InputDecoration(
                      labelText: "Motivo",
                    ),
                    // validator: (value) =>
                    // value.length == 0 ? 'Não pode ser nulo' : null,
                    onChanged: (String newValue) {
                      setState(() {
                        carcaca.motivo = newValue;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  TextFormField(
                    controller: textEditingControllerDescricao,
                    decoration: InputDecoration(
                      labelText: "Descrição",
                    ),
                    // validator: (value) =>
                    // value.length == 0 ? 'Não pode ser nulo' : null,
                    onChanged: (String newValue) {
                      setState(() {
                        carcaca.descricao = newValue;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
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
                              builder: (context) => ListaRejeitadas(),
                            ),
                          );
                        },
                      )),
                      Padding(padding: EdgeInsets.all(5)),
                      Expanded(
                          child: ElevatedButton(
                        child: Text("Atualizar"),
                        onPressed: () async {
                          var carcacaApi = new RejeitadasApi();
                          var response = await carcacaApi.update(carcaca);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListaRejeitadas(),
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

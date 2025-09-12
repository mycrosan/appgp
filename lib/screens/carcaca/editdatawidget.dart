import 'package:GPPremium/models/carcaca.dart';
import 'package:GPPremium/models/marca.dart';
import 'package:GPPremium/models/medida.dart';
import 'package:GPPremium/models/modelo.dart';
import 'package:GPPremium/models/pais.dart';
import 'package:GPPremium/service/carcacaapi.dart';
import 'package:GPPremium/service/get_image.dart';
import 'package:GPPremium/service/medidaapi.dart';
import 'package:GPPremium/service/modeloapi.dart';
import 'package:GPPremium/service/paisapi.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../models/responseMessage.dart';
import 'ListaCarcacas.dart';

class EditarCarcacaPage extends StatefulWidget {
  int id = 0;
  Carcaca carcacaEdit;

  EditarCarcacaPage({Key? key, this.carcacaEdit, producao}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditarCarcacaPageState();
  }
}

class EditarCarcacaPageState extends State<EditarCarcacaPage> {
  final _formkey = GlobalKey<FormState>();

  late TextEditingController textEditingControllerEtiqueta;
  late TextEditingController textEditingControllerDot;
  late Carcaca carcaca;
  Image? _image;
  bool image_ok = false;

  //Modelo
  List<Modelo> modeloList = [];
  late Modelo modeloSelected;

  //Medida
  List<Medida> medidaList = [];
  late Medida medidaSelected;

  //Pais
  List<Pais> paisList = [];
  late Pais paisSelected;

  @override
  void initState() {
    super.initState();
    textEditingControllerEtiqueta = new TextEditingController();
    textEditingControllerDot = new TextEditingController();
    carcaca = Carcaca(
      id: 0,
      etiqueta: '',
      dot: '',
      marca: Marca(id: 0, descricao: ''),
      medida: Medida(id: 0, descricao: ''),
      pais: Pais(id: 0, descricao: ''),
      modelo: Modelo(id: 0, descricao: ''),
      imagem: ''
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
      carcaca.id = widget.carcacaEdit.id;
      textEditingControllerEtiqueta.text = widget.carcacaEdit.numeroEtiqueta;
      carcaca.numeroEtiqueta = widget.carcacaEdit.numeroEtiqueta;
      textEditingControllerDot.text = widget.carcacaEdit.dot;
      carcaca.dot = widget.carcacaEdit.dot;
      carcaca.modelo = widget.carcacaEdit.modelo;
      carcaca.medida = widget.carcacaEdit.medida;
      carcaca.pais = widget.carcacaEdit.pais;
      carcaca.fotos = widget.carcacaEdit.fotos;
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
    var carcacaApi = new CarcacaApi();

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Carcaça'),
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
                    controller: textEditingControllerEtiqueta,
                    decoration: InputDecoration(
                      labelText: "Etiqueta",
                    ),
                    validator: (value) =>
                        value.length == 0 ? 'Não pode ser nulo' : null,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onChanged: (String newValue) {
                      setState(() {
                        carcaca.numeroEtiqueta = newValue;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  TextFormField(
                    // initialValue: (snapshot.data !=null) ? snapshot.data.dot : null,
                    controller: textEditingControllerDot,
                    decoration: InputDecoration(
                      labelText: "Dot",
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        carcaca.dot = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 10),

                  // MODELO
                  DropdownSearch<Modelo>(
                    mode: Mode.BOTTOM_SHEET,
                    showSearchBox: true,
                    label: "Modelo",
                    validator: (value) =>
                    value == null ? 'Não pode ser nulo' : null,
                    items: modeloList,
                    selectedItem: modeloSelected,
                    itemAsString: (Modelo m) => m.descricao,
                    onChanged: (modelo) {
                      setState(() {
                        modeloSelected = modelo;
                        carcaca.modelo = modeloSelected;
                      });
                    },
                  ),
                  SizedBox(height: 10),

                  // MEDIDA
                  DropdownSearch<Medida>(
                    mode: Mode.BOTTOM_SHEET,
                    showSearchBox: true,
                    label: "Medida",
                    validator: (value) =>
                    value == null ? 'Não pode ser nulo' : null,
                    items: medidaList,
                    selectedItem: medidaSelected,
                    itemAsString: (Medida m) => m.descricao,
                    onChanged: (medida) {
                      setState(() {
                        medidaSelected = medida;
                        carcaca.medida = medidaSelected;
                      });
                    },
                  ),
                  SizedBox(height: 10),

                  // PAÍS
                  DropdownSearch<Pais>(
                    mode: Mode.BOTTOM_SHEET,
                    showSearchBox: true,
                    label: "País",
                    validator: (value) =>
                    value == null ? 'Não pode ser nulo' : null,
                    items: paisList,
                    selectedItem: paisSelected,
                    itemAsString: (Pais p) => p.descricao,
                    onChanged: (pais) {
                      setState(() {
                        paisSelected = pais;
                        carcaca.pais = paisSelected;
                      });
                    },
                  ),

                  SizedBox(height: 20),
                  Container(
                    child: FutureBuilder(
                        future: new ImageService().showImage(carcaca.fotos, "carcaca"),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              height: 200.0,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return snapshot.data[index];
                                },
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
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
                              builder: (context) => ListaCarcaca(),
                            ),
                          );
                        },
                      )),
                      Padding(padding: EdgeInsets.all(5)),
                      Expanded(
                          child: ElevatedButton(
                        child: Text("Atualizar"),
                        onPressed: () async {
                          var carcacaApi = new CarcacaApi();

                          var response = await carcacaApi.update(carcaca);

                          if (response is Carcaca && response != null) {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListaCarcaca(),
                              ),
                            );

                          } else {
                            responseMessage value =
                            response != null ? response : null;
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Atenção!"),
                                  content: Text(value.debugMessage),
                                  actions: [
                                    TextButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ListaCarcaca(),
                                          ),
                                        );
                                        // _btnController1.reset();
                                        // Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
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

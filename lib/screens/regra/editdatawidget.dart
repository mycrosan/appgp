import 'package:GPPremium/models/antiquebra.dart';
import 'package:GPPremium/models/camelback.dart';
import 'package:GPPremium/models/espessuramento.dart';
import 'package:GPPremium/models/matriz.dart';
import 'package:GPPremium/models/medida.dart';
import 'package:GPPremium/models/modelo.dart';
import 'package:GPPremium/models/pais.dart';
import 'package:GPPremium/models/regra.dart';
import 'package:GPPremium/service/antiquebraapi.dart';
import 'package:GPPremium/service/camelbackapi.dart';
import 'package:GPPremium/service/espessuramento.dart';
import 'package:GPPremium/service/matrizapi.dart';
import 'package:GPPremium/service/medidaapi.dart';
import 'package:GPPremium/service/modeloapi.dart';
import 'package:GPPremium/service/paisapi.dart';
import 'package:GPPremium/service/regraapi.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'ListaRegras.dart';

class EditarRegraPage extends StatefulWidget {
  int id;
  Regra regra;

  EditarRegraPage({Key key, this.regra}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditarRegraPageState();
  }
}

class EditarRegraPageState extends State<EditarRegraPage> {
  final _formkey = GlobalKey<FormState>();

  MaskedTextController textEditingControllerTamanhoMin;
  MaskedTextController textEditingControllerTamanhoMax;
  TextEditingController textEditingControllerCamelback;
  TextEditingController textEditingControllerAntiquebra1;
  TextEditingController textEditingControllerAntiquebra2;
  TextEditingController textEditingControllerAntiquebra3;
  TextEditingController textEditingControllerEspessuramento;
  MaskedTextController textEditingControllerTempo;
  TextEditingController pais;
  Regra regra;

  //Regra
  List<Matriz> matrizList = [];
  Matriz matrizSelected;

  //Medida
  List<Medida> medidaList = [];
  Medida medidaSelected;

  //Modelo
  List<Modelo> modeloList = [];
  Modelo modeloSelected;

  //Pais
  List<Pais> paisList = [];
  Pais paisSelected;

  //Cameback
  List<Camelback> camelbackList = [];
  Camelback camelbackSelected;

  //Antiquebra
  List<Antiquebra> antiquebraList = [];
  Antiquebra antiquebra1Selected;
  Antiquebra antiquebra2Selected;
  Antiquebra antiquebra3Selected;

  //Espessuramento
  List<Espessuramento> espessuramentoList = [];
  Espessuramento espessuramentoSelected;

  @override
  void initState() {
    super.initState();
    textEditingControllerTamanhoMin = MaskedTextController(mask: '0.000');
    textEditingControllerTamanhoMax = MaskedTextController(mask: '0.000');
    textEditingControllerAntiquebra1 = TextEditingController();
    textEditingControllerAntiquebra2 = TextEditingController();
    textEditingControllerAntiquebra3 = TextEditingController();
    textEditingControllerEspessuramento = TextEditingController();
    textEditingControllerTempo = MaskedTextController(mask: '000');
    regra = Regra();

    pais = TextEditingController();

    MatrizApi().getAll().then((List<Matriz> value) {
      setState(() {
        matrizList = value;
      });
    });

    MedidaApi().getAll().then((List<Medida> value) {
      setState(() {
        medidaList = value;
      });
    });

    ModeloApi().getAll().then((List<Modelo> value) {
      setState(() {
        modeloList = value;
      });
    });

    PaisApi().getAll().then((List<Pais> value) {
      setState(() {
        paisList = value;
       
      });
    });

    CamelbackApi().getAll().then((List<Camelback> value) {
      setState(() {
        camelbackList = value;
      });
    });

    AntiquebraApi().getAll().then((List<Antiquebra> value) {
      setState(() {
        antiquebraList = value;
      });
    });
    EspessuramentoApi().getAll().then((List<Espessuramento> value) {
      setState(() {
        espessuramentoList = value;
      });
    });

    setState(() {
      regra.id = widget.regra.id;

      textEditingControllerTamanhoMin.text = widget.regra.tamanhoMin.toString();
      textEditingControllerTamanhoMax.text = widget.regra.tamanhoMax.toString();
      textEditingControllerTempo.text = widget.regra.tempo;

      regra.tamanhoMin = widget.regra.tamanhoMin;
      regra.tamanhoMax = widget.regra.tamanhoMax;
      regra.tempo = widget.regra.tempo;
      regra.antiquebra1 = widget.regra.antiquebra1;
      regra.antiquebra2 = widget.regra.antiquebra2;
      regra.antiquebra3 = widget.regra.antiquebra3;
      regra.espessuramento = widget.regra.espessuramento;
      regra.camelback = widget.regra.camelback;
      regra.matriz = widget.regra.matriz;
      regra.medida = widget.regra.medida;
      regra.modelo = widget.regra.modelo;
      regra.pais = widget.regra.pais;

      antiquebra1Selected = regra.antiquebra1;
      antiquebra2Selected = regra.antiquebra2;
      antiquebra3Selected = regra.antiquebra3;
      espessuramentoSelected = regra.espessuramento;
      camelbackSelected = regra.camelback;
      matrizSelected = regra.matriz;
      medidaSelected = regra.medida;
      modeloSelected = regra.modelo;
      paisSelected = regra.pais;
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  void dispose() {
    // textEditingControllerEtiqueta.dispose();
    // textEditingControllerDot.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var carcacaApi = new RegraApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Regra'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: textEditingControllerTamanhoMin,
                        decoration: InputDecoration(
                          labelText: "Tamanho mínimo",
                        ),
                        // ignore: missing_return
                        validator: (value) {
                          if (value.length == 0) return 'Não pode ser nulo';
                        },
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onChanged: (String newValue) {
                          setState(() {
                            regra.tamanhoMin = double.parse(newValue);
                          });
                        },
                      )),
                      Padding(padding: EdgeInsets.all(5)),
                      Expanded(
                          child: TextFormField(
                        controller: textEditingControllerTamanhoMax,
                        decoration: InputDecoration(
                          labelText: "Tamanho máximo",
                        ),
                        // ignore: missing_return
                        validator: (value) {
                          if (value.length == 0) return 'Não pode ser nulo';
                        },
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onChanged: (String newValue) {
                          setState(() {
                            regra.tamanhoMax = double.parse(newValue);
                          });
                        },
                      )),
                    ],
                  ),
                  Row(children: [
                    Expanded(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Antiquebra1",
                        ),
                        validator: (value) =>
                            value == null ? 'Não pode ser nulo' : null,
                        value: antiquebra1Selected,
                        isExpanded: true,
                        onChanged: (Antiquebra antiquebra) {
                          setState(() {
                            antiquebra1Selected = antiquebra;
                            regra.antiquebra1 = antiquebra1Selected;
                          });
                        },
                        items: antiquebraList.map((antiquebra) {
                          return DropdownMenuItem(
                            value: antiquebra,
                            child: Text(antiquebra.descricao),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Expanded(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Antiquebra2",
                        ),
                        validator: (value) =>
                            value == null ? 'Não pode ser nulo' : null,
                        value: antiquebra2Selected,
                        isExpanded: true,
                        onChanged: (Antiquebra antiquebra) {
                          setState(() {
                            antiquebra2Selected = antiquebra;
                            regra.antiquebra2 = antiquebra2Selected;
                          });
                        },
                        items: antiquebraList.map((antiquebra) {
                          return DropdownMenuItem(
                            value: antiquebra,
                            child: Text(antiquebra.descricao),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Expanded(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Antiquebra3",
                        ),
                        validator: (value) =>
                            value == null ? 'Não pode ser nulo' : null,
                        value: antiquebra3Selected,
                        isExpanded: true,
                        onChanged: (Antiquebra antiquebra) {
                          setState(() {
                            antiquebra3Selected = antiquebra;
                            regra.antiquebra3 = antiquebra3Selected;
                          });
                        },
                        items: antiquebraList.map((antiquebra) {
                          return DropdownMenuItem(
                            value: antiquebra,
                            child: Text(antiquebra.descricao),
                          );
                        }).toList(),
                      ),
                    )
                  ]),
                  Row(children: [
                    Expanded(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Espessuramento",
                        ),
                        validator: (value) =>
                            value == null ? 'Não pode ser nulo' : null,
                        value: espessuramentoSelected,
                        isExpanded: true,
                        onChanged: (Espessuramento espessuramento) {
                          setState(() {
                            espessuramentoSelected = espessuramento;
                            regra.espessuramento = espessuramentoSelected;
                          });
                        },
                        items: espessuramentoList.map((espessuramento) {
                          return DropdownMenuItem(
                            value: espessuramento,
                            child: Text(espessuramento.descricao),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Expanded(
                      child: TextFormField(
                        controller: textEditingControllerTempo,
                        decoration: InputDecoration(
                          labelText: "Tempo",
                        ),
                        validator: (value) =>
                            value.length == 0 ? 'Não pode ser nulo' : null,
                        onChanged: (String newValue) {
                          setState(() {
                            regra.tempo = newValue;
                          });
                        },
                      ),
                    )
                  ]),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Camelback",
                    ),
                    validator: (value) =>
                        value == null ? 'Não pode ser nulo' : null,
                    value: camelbackSelected,
                    isExpanded: true,
                    onChanged: (Camelback camelback) {
                      setState(() {
                        camelbackSelected = camelback;
                        regra.camelback = camelbackSelected;
                      });
                    },
                    items: camelbackList.map((camelback) {
                      return DropdownMenuItem(
                        value: camelback,
                        child: Text(camelback.descricao),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Matriz",
                    ),
                    validator: (value) =>
                        value == null ? 'Não pode ser nulo' : null,
                    value: matrizSelected,
                    isExpanded: true,
                    onChanged: (Matriz matriz) {
                      // var regra = regraList.firstWhere((regra) => regra.id == matriz.id);
                      setState(() {
                        matrizSelected = matriz;
                        regra.matriz = matrizSelected;
                      });
                    },
                    items: matrizList.map((Matriz matriz) {
                      return DropdownMenuItem(
                        value: matriz,
                        child: Text(matriz.descricao),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Medida",
                    ),
                    validator: (value) =>
                        value == null ? 'Não pode ser nulo' : null,
                    value: medidaSelected,
                    isExpanded: true,
                    onChanged: (Medida medida) {
                      // var regra = regraList.firstWhere((regra) => regra.id == matriz.id);
                      setState(() {
                        medidaSelected = medida;
                        regra.medida = medidaSelected;
                      });
                    },
                    items: medidaList.map((Medida medida) {
                      return DropdownMenuItem(
                        value: medida,
                        child: Text(medida.descricao),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Modelo",
                    ),
                    validator: (value) =>
                        value == null ? 'Não pode ser nulo' : null,
                    value: modeloSelected,
                    isExpanded: true,
                    onChanged: (Modelo modelo) {
                      // var regra = regraList.firstWhere((regra) => regra.id == modelo.id);
                      setState(() {
                        modeloSelected = modelo;
                        regra.modelo = modeloSelected;
                      });
                    },
                    items: modeloList.map((Modelo modelo) {
                      return DropdownMenuItem(
                        value: modelo,
                        child: Text(modelo.descricao),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Pais",
                    ),
                    validator: (value) =>
                        value == null ? 'Não pode ser nulo' : null,
                    value: paisSelected,
                    isExpanded: true,
                    onChanged: (Pais pais) {
                      // var regra = regraList.firstWhere((regra) => regra.id == pais.id);
                      setState(() {
                        paisSelected = pais;
                        regra.pais = paisSelected;
                      });
                    },
                    items: paisList.map((Pais pais) {
                      return DropdownMenuItem(
                        value: pais,
                        child: Text(pais.descricao),
                      );
                    }).toList(),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        child: Text("Cancelar"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListaRegras(),
                            ),
                          );
                        },
                      )),
                      Padding(padding: EdgeInsets.all(5)),
                      Expanded(
                          child: ElevatedButton(
                        child: Text("Atualizar"),
                        onPressed: () async {
                          var regraApi = new RegraApi();
                          var response = await regraApi.update(regra);
                          print(response);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListaRegras(),
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

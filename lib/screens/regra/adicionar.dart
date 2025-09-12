import 'package:GPPremium/models/antiquebra.dart';
import 'package:GPPremium/models/camelback.dart';
import 'package:GPPremium/models/espessuramento.dart';
import 'package:GPPremium/models/matriz.dart';
import 'package:GPPremium/models/medida.dart';
import 'package:GPPremium/models/modelo.dart';
import 'package:GPPremium/models/pais.dart';
import 'package:GPPremium/models/regra.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:GPPremium/service/matrizapi.dart';
import 'package:GPPremium/service/regraapi.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../service/antiquebraapi.dart';
import '../../service/camelbackapi.dart';
import '../../service/espessuramento.dart';
import '../../service/medidaapi.dart';
import '../../service/modeloapi.dart';
import '../../service/paisapi.dart';
import 'ListaRegras.dart';

class AdicionarRegraPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AdicionarRegraPageState();
  }
}

class AdicionarRegraPageState extends State<AdicionarRegraPage> {
  final _formkey = GlobalKey<FormState>();

  late MaskedTextController textEditingControllerTamanhoMin;
  late MaskedTextController textEditingControllerTamanhoMax;
  late TextEditingController textEditingControllerCamelback;
  late MaskedTextController textEditingControllerTempo;
  late TextEditingController pais;
  late Regra regra;

  //Regra
  List<Matriz> matrizList = [];
  Matriz? matrizSelected;

  //Medida
  List<Medida> medidaList = [];
  Medida? medidaSelected;

  //Modelo
  List<Modelo> modeloList = [];
  Modelo? modeloSelected;

  //Pais
  List<Pais> paisList = [];
  Pais? paisSelected;

  //Cameback
  List<Camelback> camelbackList = [];
  Camelback? camelbackSelected;

  //Antiquebra
  List<Antiquebra> antiquebraList = [];
  Antiquebra? antiquebra1Selected;
  Antiquebra? antiquebra2Selected;
  Antiquebra? antiquebra3Selected;

  //Espessuramento
  List<Espessuramento> espessuramentoList = [];
  Espessuramento? espessuramentoSelected;

  @override
  void initState() {
    super.initState();
    textEditingControllerTamanhoMin = MaskedTextController(mask: '0.000');
    textEditingControllerTamanhoMax = MaskedTextController(mask: '0.000');
    textEditingControllerCamelback = TextEditingController();
    textEditingControllerTempo = MaskedTextController(mask: '000');
    regra = Regra(
      id: 0,
      tamanhoMin: 0.0,
      tamanhoMax: 0.0,
      tempo: '',
      matriz: Matriz(id: 0, descricao: ''),
      medida: Medida(id: 0, descricao: ''),
      modelo: Modelo(id: 0, descricao: ''),
      pais: Pais(id: 0, descricao: ''),
      camelback: Camelback(id: 0, descricao: ''),
      antiquebra1: Antiquebra(id: 0, descricao: ''),
      antiquebra2: Antiquebra(id: 0, descricao: ''),
      antiquebra3: Antiquebra(id: 0, descricao: ''),
      espessuramento: Espessuramento(id: 0, descricao: ''),
    );

    pais = TextEditingController();

    MatrizApi().getAll().then((value) {
      setState(() {
        matrizList = value;
      });
    });

    MedidaApi().getAll().then((value) {
      setState(() {
        medidaList = value;
      });
    });

    ModeloApi().getAll().then((value) {
      setState(() {
        modeloList = value;
      });
    });

    PaisApi().getAll().then((value) {
      setState(() {
        paisList = value;
      });
    });

    CamelbackApi().getAll().then((value) {
      setState(() {
        camelbackList = value;
      });
    });

    AntiquebraApi().getAll().then((value) {
      setState(() {
        antiquebraList = value;
      });
    });

    EspessuramentoApi().getAll().then((value) {
      setState(() {
        espessuramentoList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regra'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: _construirFormulario(context),
        ),
      ),
    );
  }

  Widget _construirFormulario(context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          DropdownSearch<Matriz>(
            mode: Mode.BOTTOM_SHEET,
            showSearchBox: true,
            label: "Matriz",
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            items: matrizList,
            selectedItem: matrizSelected,
            itemAsString: (Matriz m) => m.descricao,
            onChanged: (matriz) {
              setState(() {
                matrizSelected = matriz;
                regra.matriz = matrizSelected;
              });
            },
          ),
          DropdownSearch<Medida>(
            mode: Mode.BOTTOM_SHEET,
            showSearchBox: true,
            label: "Medida",
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            items: medidaList,
            selectedItem: medidaSelected,
            itemAsString: (Medida m) => m.descricao,
            onChanged: (medida) {
              setState(() {
                medidaSelected = medida;
                regra.medida = medidaSelected;
              });
            },
          ),
          DropdownSearch<Modelo>(
            mode: Mode.BOTTOM_SHEET,
            showSearchBox: true,
            label: "Modelo",
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            items: modeloList,
            selectedItem: modeloSelected,
            itemAsString: (Modelo m) => m.descricao,
            onChanged: (modelo) {
              setState(() {
                modeloSelected = modelo;
                regra.modelo = modeloSelected;
              });
            },
          ),
          DropdownSearch<Pais>(
            mode: Mode.BOTTOM_SHEET,
            showSearchBox: true,
            label: "País",
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            items: paisList,
            selectedItem: paisSelected,
            itemAsString: (Pais p) => p.descricao,
            onChanged: (pais) {
              setState(() {
                paisSelected = pais;
                regra.pais = paisSelected;
              });
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: textEditingControllerTamanhoMin,
                  decoration: InputDecoration(
                    labelText: "Tamanho mínimo",
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Não pode ser nulo';
                    return null;
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (newValue) {
                    setState(() {
                      regra.tamanhoMin = double.parse(newValue);
                    });
                  },
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: TextFormField(
                  controller: textEditingControllerTamanhoMax,
                  decoration: InputDecoration(
                    labelText: "Tamanho máximo",
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Não pode ser nulo';
                    return null;
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (newValue) {
                    setState(() {
                      regra.tamanhoMax = double.parse(newValue);
                    });
                  },
                ),
              ),
            ],
          ),
// Camelback
          DropdownSearch<Camelback>(
            mode: Mode.MENU,
            showSearchBox: true,
            label: "Camelback",
            selectedItem: camelbackSelected,
            onChanged: (Camelback camelback) {
              setState(() {
                camelbackSelected = camelback;
                regra.camelback = camelbackSelected;
              });
            },
            items: camelbackList,
            itemAsString: (Camelback c) => c.descricao,
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
          ),

// Antiquebra 1
          DropdownSearch<Antiquebra>(
            mode: Mode.MENU,
            showSearchBox: true,
            label: "Antiquebra 1",
            selectedItem: antiquebra1Selected,
            onChanged: (Antiquebra antiquebra) {
              setState(() {
                antiquebra1Selected = antiquebra;
                regra.antiquebra1 = antiquebra1Selected;
              });
            },
            items: antiquebraList,
            itemAsString: (Antiquebra a) => a.descricao,
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
          ),

// Antiquebra 2
          DropdownSearch<Antiquebra>(
            mode: Mode.MENU,
            showSearchBox: true,
            label: "Antiquebra 2",
            selectedItem: antiquebra2Selected,
            onChanged: (Antiquebra antiquebra) {
              setState(() {
                antiquebra2Selected = antiquebra;
                regra.antiquebra2 = antiquebra2Selected;
              });
            },
            items: antiquebraList,
            itemAsString: (Antiquebra a) => a.descricao,
          ),

// Antiquebra 3
          DropdownSearch<Antiquebra>(
            mode: Mode.MENU,
            showSearchBox: true,
            label: "Antiquebra 3",
            selectedItem: antiquebra3Selected,
            onChanged: (Antiquebra antiquebra) {
              setState(() {
                antiquebra3Selected = antiquebra;
                regra.antiquebra3 = antiquebra3Selected;
              });
            },
            items: antiquebraList,
            itemAsString: (Antiquebra a) => a.descricao,
          ),

// Espessuramento
          DropdownSearch<Espessuramento>(
            mode: Mode.MENU,
            showSearchBox: true,
            label: "Espessuramento",
            selectedItem: espessuramentoSelected,
            onChanged: (Espessuramento espessuramento) {
              setState(() {
                espessuramentoSelected = espessuramento;
                regra.espessuramento = espessuramentoSelected;
              });
            },
            items: espessuramentoList,
            itemAsString: (Espessuramento e) => e.descricao,
          ),

// Tempo
          TextFormField(
            controller: textEditingControllerTempo,
            decoration: InputDecoration(
              labelText: "Tempo",
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Não pode ser nulo' : null,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (String newValue) {
              setState(() {
                regra.tempo = newValue;
              });
            },
          ),

          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/home");
                  },
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: ElevatedButton(
                  child: Text("Salvar"),
                  onPressed: () async {
                    if (_formkey.currentState?.validate() ?? false) {
                      var response = await RegraApi().create(regra);
                      if (response is Regra && response != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListaRegras(),
                          ),
                        );
                      } else {
                        responseMessage value =
                        response as responseMessage?;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Atenção! \n" + value.message),
                              content: Text(value.debugMessage),
                              actions: [
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

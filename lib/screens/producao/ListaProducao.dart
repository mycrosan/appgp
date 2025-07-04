import 'package:GPPremium/components/Loading.dart';
import 'package:GPPremium/components/snackBar.dart';
import 'package:GPPremium/service/producaoapi.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/carcaca.dart';
import '../../models/marca.dart';
import '../../models/medida.dart';
import '../../models/modelo.dart';
import '../../models/pais.dart';
import '../../models/producao.dart';
import '../../service/marcaapi.dart';
import '../../service/medidaapi.dart';
import '../../service/modeloapi.dart';
import '../../service/paisapi.dart';
import 'adicionar.dart';
import 'detailwidget.dart';
import 'editdatawidget.dart';

class ListaProducao extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaProducaoState();
  }
}

class ListaProducaoState extends State<ListaProducao> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController textEditingControllerModelo;
  TextEditingController textEditingControllerMarca;
  TextEditingController textEditingControllerMedida;

  // final DinamicListCard listCards = DinamicListCard();

  TextEditingController textEditingControllerCarcaca;
  Producao producao;

  // bool loading = true;
  var loading = ValueNotifier<bool>(true);

  //Modelo
  List<Modelo> modeloList = [];
  Modelo modeloSelected;

  //Medida
  List<Medida> medidaList = [];
  Medida medidaSelected;

  //Pais
  List<Pais> paisList = [];
  Pais paisSelected;

  //Marca
  List<Marca> marcaList = [];
  Marca marcaSelected;

  List<Producao> producaoList = [];

  @override
  void initState() {
    super.initState();
    textEditingControllerModelo = TextEditingController();
    textEditingControllerMarca = TextEditingController();
    textEditingControllerMedida = TextEditingController();

    producao = new Producao();
    producao.carcaca = new Carcaca();
    producao.carcaca.modelo = new Modelo();
    producao.carcaca.modelo.marca = new Marca();

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

    MarcaApi().getAll().then((List<Marca> value) {
      setState(() {
        marcaList = value;
      });
    });

    ProducaoApi().getAll().then((List<Producao> value) {
      setState(() {
        producaoList = value;
        loading.value = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var producaoAPI = new ProducaoApi();
    // final ProducaoApi producao = Provider.of(context);

    final DinamicListCard listCards = DinamicListCard();

    TextEditingController textEditingControllerCarcaca;
    textEditingControllerCarcaca = MaskedTextController(mask: '000000');

    List listaCarcaca = [];
    var _isList = ValueNotifier<bool>(true);

    final ProducaoApi producoes = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          child: Row(children: [
            Expanded(child: Text("Produção")),
            Expanded(
              child: Container(
                color: Colors.white,
                height: 30.0,
                child: TextFormField(
                  controller: textEditingControllerCarcaca,
                  decoration: InputDecoration(
                    hintText: 'Nº Etiqueta',
                    contentPadding: EdgeInsets.all(10.0),
                    // prefixIcon: Icon(Icons.search),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (String newValue) async {
                    if (newValue.length >= 6) {
                      loading.value = true;
                      producao.carcaca.numeroEtiqueta = newValue;
                      producaoList = await listCards.pesquisa(producao);

                      if(producaoList.length > 0) {
                        loading.value = false;
                        _isList.value = true;
                        listCards.exibirListaConsulta(context, producaoList);
                        _isList.notifyListeners();
                        listCards.notifyListeners();
                        loading.notifyListeners();
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            warningMessage(context, "Sem resultados para etiqueta " + newValue));
                      }
                    } else {
                      _isList.value = false;
                      _isList.notifyListeners();
                    }
                  },
                ),
              ),
            )
          ]),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdicionarProducaoPage(),
                  ));
              // do something
            },
          ),
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: "Modelo",
                  ),
                  validator: (value) =>
                      value == null ? 'Não pode ser nulo' : null,
                  value: modeloSelected,
                  isExpanded: true,
                  onChanged: (Modelo modelo) {
                    setState(() {
                      modeloSelected = modelo;
                      producao.carcaca.modelo = modeloSelected;
                      marcaSelected = modeloSelected.marca;
                      producao.carcaca.modelo.marca = marcaSelected;
                    });
                  },
                  items: modeloList.map((Modelo modelo) {
                    return DropdownMenuItem(
                      value: modelo,
                      child: Text(modelo.descricao),
                    );
                  }).toList(),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                Row(children: [
                  Expanded(
                      child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Medida",
                    ),
                    validator: (value) =>
                        value == null ? 'Não pode ser nulo' : null,
                    value: medidaSelected,
                    isExpanded: true,
                    onChanged: (Medida medida) {
                      setState(() {
                        medidaSelected = medida;
                        producao.carcaca.medida = medidaSelected;
                      });
                    },
                    items: medidaList.map((Medida medida) {
                      return DropdownMenuItem(
                        value: medida,
                        child: Text(medida.descricao),
                      );
                    }).toList(),
                  )),
                  Expanded(
                      child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "País",
                    ),
                    validator: (value) =>
                        value == null ? 'Não pode ser nulo' : null,
                    value: paisSelected,
                    isExpanded: true,
                    onChanged: (Pais pais) {
                      setState(() {
                        paisSelected = pais;
                        producao.carcaca.pais = paisSelected;
                      });
                    },
                    items: paisList.map((Pais pais) {
                      return DropdownMenuItem(
                        value: pais,
                        child: Text(pais.descricao),
                      );
                    }).toList(),
                  )),
                  Expanded(
                      child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Marca",
                    ),
                    validator: (value) =>
                        value == null ? 'Não pode ser nulo' : null,
                    value: marcaSelected,
                    isExpanded: true,
                    onChanged: (Marca marca) {
                      setState(() {
                        marcaSelected = marca;
                        producao.carcaca.modelo.marca = marcaSelected;
                      });
                    },
                    items: marcaList.map((Marca marca) {
                      return DropdownMenuItem(
                        value: marca,
                        child: Text(marca.descricao),
                      );
                    }).toList(),
                  )),
                ]),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                Container(
                    child: ElevatedButton(
                  child: Text("Pesquisar"),
                  onPressed: () async {
                    if (true) {
                      loading.value = true;
                      producaoList = await listCards.pesquisa(producao);
                      loading.value = false;
                      _isList.value = true;
                      _isList.notifyListeners();
                    }
                  },
                )),
                Container(
                  child: Expanded(
                    child: ValueListenableBuilder(
                        valueListenable: _isList,
                        builder: (_, __, ___) {
                          return Visibility(
                            child: listCards.exibirListaConsulta(
                                        context, producaoList) !=
                                    null
                                ? listCards.exibirListaConsulta(
                                    context, producaoList)
                                : loading.value
                                    ? cicleLoading(context)
                                    : producaoList.length == 0
                                        ? Text('Nenhuma produção encontrada')
                                        : '',
                          );
                        }),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class DinamicListCard extends ChangeNotifier {
  exibirListaConsulta(context, Servico) {
    if (Servico.length > 0) {
      return Container(
        height: 400.0,
        child: ListView.builder(
            itemCount: Servico.length,
            itemBuilder: (context, index) {
              if (Servico.length > 0) {
                return Card(
                  child: ListTile(
                    title: Text(
                        'Etiqueta: ' + Servico[index].carcaca.numeroEtiqueta),
                    subtitle: Text('Med. Pneu Rasp.: ' +
                        Servico[index].medidaPneuRaspado.toString() +
                        ' Regra: ' +
                        Servico[index].regra.id.toString()),
                    trailing: Container(
                      width: 100,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditarProducaoPage(
                                              producao: Servico[index],
                                            )));
                              },
                              icon: Icon(Icons.edit, color: Colors.orange)),
                          IconButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Excluir"),
                                      content: Text(
                                          "Tem certeza que deseja excluir o item ${Servico[index].carcaca.numeroEtiqueta}"),
                                      actions: [
                                        ElevatedButton(
                                          child: Text("Sim"),
                                          onPressed: () async {
                                            var response =
                                                await Provider.of<ProducaoApi>(
                                                        context,
                                                        listen: false)
                                                    .delete(Servico[index].id)
                                                    .then((value) {
                                              return value;
                                            });
                                            if (response) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                      deleteMessage(context));
                                              Servico.removeAt(index);
                                              Navigator.pop(context);
                                            }
                                          },
                                        ),
                                        ElevatedButton(
                                          child: Text("Não"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                    notifyListeners();
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetalhesProducaoPage(
                                    producao: Servico[index],
                                  )));
                    },
                  ),
                );
              } else {
                return cicleLoading(context);
              }
            }),
      );
    } else {
      return null;
    }
  }

  pesquisa(producao) {
    return ProducaoApi().consultaProducao(producao);
  }
}

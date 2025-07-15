import 'package:GPPremium/components/Loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/snackBar.dart';
import '../../models/marca.dart';
import '../../models/medida.dart';
import '../../models/modelo.dart';
import '../../models/pais.dart';
import '../../models/rejeitadas.dart';
import '../../service/marcaapi.dart';
import '../../service/medidaapi.dart';
import '../../service/modeloapi.dart';
import '../../service/paisapi.dart';
import '../../service/rejeitadasapi.dart';
import 'adicionar.dart';
import 'detailwidget.dart';
import 'editdatawidget.dart';

class ListaRejeitadas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaRejeitadasState();
  }
}

class ListaRejeitadasState extends State<ListaRejeitadas> {

  final _formkey = GlobalKey<FormState>();

  TextEditingController textEditingControllerModelo;
  TextEditingController textEditingControllerMarca;
  TextEditingController textEditingControllerMedida;

  final DinamicListRejeitada listCards = DinamicListRejeitada();

  TextEditingController textEditingControllerCarcaca;
  Rejeitadas rejeitada;

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

  List<Rejeitadas> carcacaList = [];

  @override
  void initState() {
    super.initState();
    textEditingControllerModelo = TextEditingController();
    textEditingControllerMarca = TextEditingController();
    textEditingControllerMedida = TextEditingController();

    rejeitada = new Rejeitadas();
    rejeitada.modelo = new Modelo();
    rejeitada.medida = new Medida();
    rejeitada.pais = new Pais();
    rejeitada.modelo.marca = new Marca();

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

    RejeitadasApi().getAll().then((List<Rejeitadas> value) {
      setState(() {
        carcacaList = value;
        loading.value = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    var rejeitadasApi = new RejeitadasApi();

    final RejeitadasApi rejeitadas = Provider.of(context);
    var _isList = ValueNotifier<bool>(true);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          child: Row(children: [
            Expanded(child: Text("Proibidas")),
            Expanded(
              child: Container(
                color: Colors.white,
                height: 30.0,
                child: TextFormField(
                  controller: textEditingControllerCarcaca,
                  decoration: InputDecoration(
                    hintText: 'Modelo',
                    contentPadding: EdgeInsets.all(10.0),
                    // prefixIcon: Icon(Icons.search),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (String newValue) async {
                    if (newValue.length >= 6) {
                      loading.value = true;
                      // qualidade.producao.carcaca.numeroEtiqueta = newValue;
                      // producaoList =
                      // await listCards.pesquisa(qualidade.producao);
                      // loading.value = false;
                      // _isList.value = true;
                      // listCards.exibirProducao(context, producaoList);
                      _isList.notifyListeners();
                      listCards.notifyListeners();
                      loading.notifyListeners();
                    } else {
                      _isList.value = true;
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
                    builder: (context) => AdicionarRejeitadasPage(),
                  ));
              // do something
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                  rejeitada.modelo = modeloSelected;
                  marcaSelected = modeloSelected.marca;
                  rejeitada.modelo.marca = marcaSelected;
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
                        rejeitada.medida = medidaSelected;
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
                        rejeitada.pais = paisSelected;
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
                        rejeitada.modelo.marca = marcaSelected;
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
                      carcacaList = await listCards.pesquisa(rejeitada);
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
                            context, carcacaList) !=
                            null
                            ? listCards.exibirListaConsulta(
                            context, carcacaList)
                            : loading.value
                            ? cicleLoading(context)
                            : carcacaList.length == 0
                            ? Text('Nenhuma produção encontrada')
                            : '',
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DinamicListRejeitada extends ChangeNotifier {
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
                        "ID: " +
                            Servico[index].id.toString() +
                            " Modelo: " +
                            Servico[index].modelo.descricao),
                    subtitle: Text('Medida: ' +
                        Servico[index].medida.descricao +
                        "\n"
                            'Pais: ' +
                        Servico[index].pais.descricao +
                        "\n"
                            'Motivo: ' +
                        ((Servico[index].motivo != null)
                            ? Servico[index].motivo.toString()
                            : "NI") +
                        "\n"
                            'Observacao: ' +
                        ((Servico[index].descricao != null)
                            ? Servico[index].descricao.toString()
                            : "NI")),
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
                                            EditarRejeitadasPage(
                                              carcacaEdit:
                                              Servico[index],
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
                                          "Tem certeza que deseja excluir o item ${Servico[index].id}"),
                                      actions: [
                                        ElevatedButton(
                                          child: Text("Sim"),
                                          onPressed: () async {
                                            var response =
                                            await Provider.of<RejeitadasApi>(
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
                              builder: (context) => DetalhesRejeitadasPage(
                                id: Servico[index].id,
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

  cardResponse(_responseValue, context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white70,
      child: ListTile(
        title: Text('Etiqueta: ' +
            _responseValue.toString() +
            " id: " +
            _responseValue.id.toString()),
        subtitle: Text('Medida: ' +
            _responseValue.medida.descricao +
            "\n"
                'Modelo: ' +
            _responseValue.modelo.descricao),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditarRejeitadasPage(
                              carcacaEdit: _responseValue,
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
                              "Tem certeza que deseja excluir o item ${_responseValue.numeroEtiqueta}"),
                          actions: [
                            ElevatedButton(
                              child: Text("Sim"),
                              onPressed: () {
                                Provider.of<RejeitadasApi>(context,
                                    listen: false)
                                    .delete(_responseValue.id);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(deleteMessage(context));
                                Navigator.pop(context);
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
                        ;
                      },
                    );
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
              // IconButton(onPressed: (){}, icon: Icon(Icons.arrow_right, color: Colors.black,))
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetalhesRejeitadasPage(
                    id: _responseValue.id,
                  )));
        },
      ),
    );
  }

  pesquisa(carcaca) {
    return RejeitadasApi().consultaRejeitadas(carcaca);
  }
}

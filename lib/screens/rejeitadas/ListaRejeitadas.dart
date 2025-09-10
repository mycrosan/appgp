import 'package:GPPremium/components/Loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

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
  TextEditingController textEditingControllerCarcaca;

  final DinamicListRejeitada listCards = DinamicListRejeitada();
  Rejeitadas rejeitada;

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
    textEditingControllerCarcaca = TextEditingController();

    rejeitada = Rejeitadas();
    rejeitada.modelo = Modelo();
    rejeitada.medida = Medida();
    rejeitada.pais = Pais();
    rejeitada.modelo.marca = Marca();

    ModeloApi().getAll().then((value) {
      setState(() {
        modeloList = value;
      });
    });

    MedidaApi().getAll().then((value) {
      setState(() {
        medidaList = value;
      });
    });

    PaisApi().getAll().then((value) {
      setState(() {
        paisList = value;
      });
    });

    MarcaApi().getAll().then((value) {
      setState(() {
        marcaList = value;
      });
    });

    RejeitadasApi().getAll().then((value) {
      setState(() {
        carcacaList = value;
        loading.value = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _isList = ValueNotifier<bool>(true);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          child: Row(
            children: [
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
                    ),
                    keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                    onChanged: (String newValue) async {
                      if (newValue.length >= 6) {
                        loading.value = true;
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
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdicionarRejeitadasPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownSearch<Modelo>(
              mode: Mode.BOTTOM_SHEET,
              showSearchBox: true,
              label: "Modelo",
              validator: (value) {
                if (value == null) return 'Não pode ser nulo';
                return null;
              },
              items: modeloList,
              selectedItem: modeloSelected,
              itemAsString: (Modelo m) => m.descricao,
              onChanged: (modelo) {
                setState(() {
                  modeloSelected = modelo;
                  rejeitada.modelo = modeloSelected;
                  marcaSelected = modeloSelected.marca;
                  rejeitada.modelo.marca = marcaSelected;
                });
              },
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: DropdownSearch<Medida>(
                    mode: Mode.BOTTOM_SHEET,
                    showSearchBox: true,
                    label: "Medida",
                    validator: (value) {
                      if (value == null) return 'Não pode ser nulo';
                      return null;
                    },
                    items: medidaList,
                    selectedItem: medidaSelected,
                    itemAsString: (Medida m) => m.descricao,
                    onChanged: (medida) {
                      setState(() {
                        medidaSelected = medida;
                        rejeitada.medida = medidaSelected;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: DropdownSearch<Pais>(
                    mode: Mode.BOTTOM_SHEET,
                    showSearchBox: true,
                    label: "País",
                    validator: (value) {
                      if (value == null) return 'Não pode ser nulo';
                      return null;
                    },
                    items: paisList,
                    selectedItem: paisSelected,
                    itemAsString: (Pais p) => p.descricao,
                    onChanged: (pais) {
                      setState(() {
                        paisSelected = pais;
                        rejeitada.pais = paisSelected;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: DropdownSearch<Marca>(
                    mode: Mode.BOTTOM_SHEET,
                    showSearchBox: true,
                    label: "Marca",
                    validator: (value) {
                      if (value == null) return 'Não pode ser nulo';
                      return null;
                    },
                    items: marcaList,
                    selectedItem: marcaSelected,
                    itemAsString: (Marca m) => m.descricao,
                    onChanged: (marca) {
                      setState(() {
                        marcaSelected = marca;
                        rejeitada.modelo.marca = marcaSelected;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            ElevatedButton(
              child: Text("Pesquisar"),
              onPressed: () async {
                loading.value = true;
                carcacaList = await listCards.pesquisa(rejeitada);
                loading.value = false;
                _isList.value = true;
                _isList.notifyListeners();
              },
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _isList,
                builder: (_, __, ___) {
                  return Visibility(
                    child: listCards.exibirListaConsulta(
                        context, carcacaList) !=
                        null
                        ? listCards.exibirListaConsulta(context, carcacaList)
                        : loading.value
                        ? cicleLoading(context)
                        : carcacaList.isEmpty
                        ? Text('Nenhuma produção encontrada')
                        : '',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------- LISTA DINÂMICA ----------------------

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
                  title: Text("ID: ${Servico[index].id} "
                      "Modelo: ${Servico[index].modelo.descricao}"),
                  subtitle: Text(
                    'Medida: ${Servico[index].medida.descricao}\n'
                        'Pais: ${Servico[index].pais.descricao}\n'
                        'Motivo: ${Servico[index].motivo ?? "NI"}\n'
                        'Observacao: ${Servico[index].descricao ?? "NI"}',
                  ),
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
                                  carcacaEdit: Servico[index],
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit, color: Colors.orange),
                        ),
                        IconButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Excluir"),
                                  content: Text(
                                      "Tem certeza que deseja excluir o item ${Servico[index].id}?"),
                                  actions: [
                                    ElevatedButton(
                                      child: Text("Sim"),
                                      onPressed: () async {
                                        var response =
                                        await Provider.of<RejeitadasApi>(
                                            context,
                                            listen: false)
                                            .delete(Servico[index].id)
                                            .then((value) => value);
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
                              },
                            );
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetalhesRejeitadasPage(id: Servico[index].id),
                      ),
                    );
                  },
                ),
              );
            } else {
              return cicleLoading(context);
            }
          },
        ),
      );
    } else {
      return null;
    }
  }

  pesquisa(carcaca) {
    return RejeitadasApi().consultaRejeitadas(carcaca);
  }
}

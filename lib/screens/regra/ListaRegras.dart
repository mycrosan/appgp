import 'package:GPPremium/service/regraapi.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/Loading.dart';
import '../../models/marca.dart';
import '../../models/medida.dart';
import '../../models/modelo.dart';
import '../../models/pais.dart';
import '../../models/regra.dart';
import '../../service/marcaapi.dart';
import '../../service/medidaapi.dart';
import '../../service/modeloapi.dart';
import '../../service/paisapi.dart';
import 'adicionar.dart';
import 'detailwidget.dart';
import 'editdatawidget.dart';

class ListaRegras extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaRegraState();
  }
}

class ListaRegraState extends State<ListaRegras> {
  final _formkey = GlobalKey<FormState>();

  late TextEditingController textEditingControllerModelo;
  late TextEditingController textEditingControllerMarca;
  late TextEditingController textEditingControllerMedida;
  late TextEditingController textEditingControllerCarcaca;

  final DinamicListRegra listRegras = DinamicListRegra();

  late Regra regra;

  // bool loading = true;
  var loading = ValueNotifier<bool>(true);

  //Modelo
  List<Modelo> modeloList = [];
  late Modelo modeloSelected;

  //Medida
  List<Medida> medidaList = [];
  late Medida medidaSelected;

  //Pais
  List<Pais> paisList = [];
  late Pais paisSelected;

  //Marca
  List<Marca> marcaList = [];
  late Marca marcaSelected;

  List<Regra> regraList = [];

  @override
  void initState() {
    super.initState();
    textEditingControllerModelo = TextEditingController();
    textEditingControllerMarca = TextEditingController();
    textEditingControllerMedida = TextEditingController();

    regra = new Regra();
    regra.medida = new Medida();
    regra.modelo = new Modelo();
    regra.modelo.marca = new Marca();

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

    RegraApi().getAll().then((List<Regra> value) {
      setState(() {
        regraList = value;
        loading.value = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var regraAPI = new RegraApi();

    final RegraApi regras = Provider.of(context);
    var _isList = ValueNotifier<bool>(true);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          child: Row(children: [
            Expanded(child: Text("Regras")),
            Expanded(
              child: Container(
                color: Colors.white,
                height: 30.0,
                child: TextFormField(
                  controller: textEditingControllerRegra,
                  decoration: InputDecoration(
                    hintText: 'Nº Regra',
                    contentPadding: EdgeInsets.all(10.0),
                    // prefixIcon: Icon(Icons.search),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (String newValue) async {
                    if (newValue.length >= 1) {
                      loading.value = true;
                      regra.id = int.parse(newValue);
                      regraList = await listRegras.pesquisa(regra);
                      loading.value = false;
                      _isList.value = true;
                      listRegras.exibirListaConsulta(context, regraList);
                      _isList.notifyListeners();
                      listRegras.notifyListeners();
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
                    builder: (context) => AdicionarRegraPage(),
                  ));
              // do something
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                child: DropdownSearch<Modelo>(
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
                      marcaSelected = modeloSelected.marca;
                      regra.modelo.marca = marcaSelected;
                    });
                  },
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: DropdownSearch<Marca>(
                  mode: Mode.BOTTOM_SHEET,
                  showSearchBox: true,
                  label: "Marca",
                  validator: (value) => value == null ? 'Não pode ser nulo' : null,
                  items: marcaList,
                  selectedItem: marcaSelected,
                  itemAsString: (Marca m) => m.descricao,
                  onChanged: (marca) {
                    setState(() {
                      marcaSelected = marca;
                      regra.modelo.marca = marcaSelected;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Row(
            children: [
              Expanded(
                child: DropdownSearch<Medida>(
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
              ),
              const SizedBox(width: 5),
              Expanded(
                child: DropdownSearch<Pais>(
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
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          Container(
              child: ElevatedButton(
            child: Text("Pesquisar"),
            onPressed: () async {
              if (true) {
                loading.value = true;
                regraList = await listRegras.pesquisa(regra);
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
                      child: listRegras.exibirListaConsulta(
                                  context, regraList) !=
                              null
                          ? listRegras.exibirListaConsulta(context, regraList)
                          : loading.value
                              ? cicleLoading(context)
                              : regraList.length == 0
                                  ? Text('Nenhuma produção encontrada')
                                  : '',
                    );
                  }),
            ),
          )
        ]),
      ),
    );
  }
}

class DinamicListRegra extends ChangeNotifier {
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
                      'Matriz: ' + Servico[index].matriz.descricao,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Wrap(
                      children: [
                        Text.rich(TextSpan(
                            text: 'Medida: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: <InlineSpan>[
                              TextSpan(
                                text: Servico[index].medida.descricao,
                                style: TextStyle(fontWeight: FontWeight.normal),
                              )
                            ])),
                        Padding(
                          padding: EdgeInsets.all(3),
                        ),
                        Text.rich(TextSpan(
                            text: 'Marca: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: <InlineSpan>[
                              TextSpan(
                                text:
                                    Servico[index].modelo.marca.descricao,
                                style: TextStyle(fontWeight: FontWeight.normal),
                              )
                            ])),
                        Padding(
                          padding: EdgeInsets.all(3),
                        ),
                        Text.rich(TextSpan(
                            text: 'Modelo: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: <InlineSpan>[
                              TextSpan(
                                text: Servico[index].modelo.descricao,
                                style: TextStyle(fontWeight: FontWeight.normal),
                              )
                            ])),
                        Padding(
                          padding: EdgeInsets.all(3),
                        ),
                        Text.rich(TextSpan(
                            text: 'País: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: <InlineSpan>[
                              TextSpan(
                                text: Servico[index].pais.descricao,
                                style: TextStyle(fontWeight: FontWeight.normal),
                              )
                            ])),
                        Padding(
                          padding: EdgeInsets.all(3),
                        ),
                        Text.rich(TextSpan(
                            text: 'Camelback: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: <InlineSpan>[
                              TextSpan(
                                text: Servico[index].camelback.descricao,
                                style: TextStyle(fontWeight: FontWeight.normal),
                              )
                            ])),
                        Text.rich(TextSpan(
                            text: 'COD: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: <InlineSpan>[
                              TextSpan(
                                text: Servico[index].id.toString(),
                                style: TextStyle(fontWeight: FontWeight.normal),
                              )
                            ])),
                        Padding(
                          padding: EdgeInsets.all(3),
                        ),
                        Text.rich(TextSpan(
                            text: 'Min: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: <InlineSpan>[
                              TextSpan(
                                text: Servico[index].tamanhoMin
                                    .toStringAsFixed(3),
                                style: TextStyle(fontWeight: FontWeight.normal),
                              )
                            ])),
                        Padding(
                          padding: EdgeInsets.all(3),
                        ),
                        Text.rich(TextSpan(
                            text: 'Máx: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: <InlineSpan>[
                              TextSpan(
                                text: Servico[index].tamanhoMax
                                    .toStringAsFixed(3),
                                style: TextStyle(fontWeight: FontWeight.normal),
                              )
                            ])),
                      ],
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
                                        builder: (context) => EditarRegraPage(
                                              regra: Servico[index],
                                            )));
                              },
                              icon: Icon(Icons.edit, color: Colors.orange)),

                          IconButton(
                              onPressed: () async {
                                Provider.of<RegraApi>(context, listen: false)
                                    .delete(Servico[index].id);
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
                              builder: (context) => DetalhesRegraPage(
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

  pesquisa(regra) {
    return RegraApi().pesquisaRegra(regra);
  }
}

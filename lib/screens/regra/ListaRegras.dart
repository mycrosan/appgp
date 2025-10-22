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

  TextEditingController textEditingControllerModelo;
  TextEditingController textEditingControllerMarca;
  TextEditingController textEditingControllerMedida;

  final DinamicListRegra listRegras = DinamicListRegra();

  TextEditingController textEditingControllerRegra;
  Regra regra;

  // bool loading = true;
  var loading = ValueNotifier<bool>(true);
  var errorMessage = ValueNotifier<String>('');

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

  List<Regra> regraList = [];

  @override
  void initState() {
    super.initState();
    textEditingControllerModelo = TextEditingController();
    textEditingControllerMarca = TextEditingController();
    textEditingControllerMedida = TextEditingController();
    textEditingControllerRegra = TextEditingController();

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
                      try {
                        loading.value = true;
                        errorMessage.value = '';
                        
                        // Validação se é um número válido
                        final numeroRegra = int.tryParse(newValue);
                        if (numeroRegra == null) {
                          errorMessage.value = 'Digite apenas números';
                          loading.value = false;
                          return;
                        }
                        
                        regra.id = numeroRegra;
                        try {
                          final resultado = await listRegras.pesquisa(regra);
                          
                          if (resultado is List<Regra>) {
                            regraList = resultado;
                            errorMessage.value = '';
                          } else {
                            regraList = [];
                            errorMessage.value = 'Nenhuma regra encontrada';
                          }
                        } catch (e) {
                          regraList = [];
                          errorMessage.value = 'Erro ao pesquisar: ${e.toString()}';
                        }
                        
                        loading.value = false;
                        _isList.value = true;
                        _isList.notifyListeners();
                        listRegras.notifyListeners();
                        loading.notifyListeners();
                      } catch (e) {
                        loading.value = false;
                        errorMessage.value = 'Erro na pesquisa: ${e.toString()}';
                        regraList = [];
                        _isList.notifyListeners();
                      }
                    } else {
                      regraList = [];
                      errorMessage.value = '';
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
                  hint: "Selecione um modelo",
                  validator: (value) => value == null ? 'Não pode ser nulo' : null,
                  items: modeloList,
                  selectedItem: modeloSelected,
                  itemAsString: (Modelo m) => m.descricao,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: "Digite para pesquisar modelos...",
                      prefixIcon: Icon(Icons.search, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                  filterFn: (Modelo modelo, String filter) {
                    return modelo.descricao.toLowerCase().contains(filter.toLowerCase());
                  },
                  emptyBuilder: (context, searchEntry) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off, size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Nenhum modelo encontrado',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          if (searchEntry.isNotEmpty)
                            Text(
                              'para "${searchEntry}"',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                        ],
                      ),
                    ),
                  ),
                  loadingBuilder: (context, searchEntry) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Carregando modelos...'),
                        ],
                      ),
                    ),
                  ),
                  onChanged: (modelo) {
                    setState(() {
                      modeloSelected = modelo;
                      regra.modelo = modeloSelected;
                      if (modeloSelected != null && modeloSelected.marca != null) {
                        marcaSelected = modeloSelected.marca;
                        regra.modelo.marca = marcaSelected;
                      } else {
                        marcaSelected = null;
                        if (regra.modelo != null) {
                          regra.modelo.marca = null;
                        }
                      }
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
                  hint: "Selecione uma marca",
                  validator: (value) => value == null ? 'Não pode ser nulo' : null,
                  items: marcaList,
                  selectedItem: marcaSelected,
                  itemAsString: (Marca m) => m.descricao,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: "Digite para pesquisar marcas...",
                      prefixIcon: Icon(Icons.search, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                  filterFn: (Marca marca, String filter) {
                    return marca.descricao.toLowerCase().contains(filter.toLowerCase());
                  },
                  emptyBuilder: (context, searchEntry) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off, size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Nenhuma marca encontrada',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          if (searchEntry.isNotEmpty)
                            Text(
                              'para "${searchEntry}"',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                        ],
                      ),
                    ),
                  ),
                  loadingBuilder: (context, searchEntry) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Carregando marcas...'),
                        ],
                      ),
                    ),
                  ),
                  onChanged: (marca) {
                    setState(() {
                      marcaSelected = marca;
                      if (regra.modelo != null) {
                        regra.modelo.marca = marcaSelected;
                      }
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
                  hint: "Selecione uma medida",
                  validator: (value) => value == null ? 'Não pode ser nulo' : null,
                  items: medidaList,
                  selectedItem: medidaSelected,
                  itemAsString: (Medida m) => m.descricao,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: "Digite para pesquisar medidas...",
                      prefixIcon: Icon(Icons.search, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                  filterFn: (Medida medida, String filter) {
                    return medida.descricao.toLowerCase().contains(filter.toLowerCase());
                  },
                  emptyBuilder: (context, searchEntry) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off, size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Nenhuma medida encontrada',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          if (searchEntry.isNotEmpty)
                            Text(
                              'para "${searchEntry}"',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                        ],
                      ),
                    ),
                  ),
                  loadingBuilder: (context, searchEntry) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Carregando medidas...'),
                        ],
                      ),
                    ),
                  ),
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
                  hint: "Selecione um país",
                  validator: (value) => value == null ? 'Não pode ser nulo' : null,
                  items: paisList,
                  selectedItem: paisSelected,
                  itemAsString: (Pais p) => p.descricao,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: "Digite para pesquisar países...",
                      prefixIcon: Icon(Icons.search, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                  filterFn: (Pais pais, String filter) {
                    return pais.descricao.toLowerCase().contains(filter.toLowerCase());
                  },
                  emptyBuilder: (context, searchEntry) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off, size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Nenhum país encontrado',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          if (searchEntry.isNotEmpty)
                            Text(
                              'para "${searchEntry}"',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                        ],
                      ),
                    ),
                  ),
                  loadingBuilder: (context, searchEntry) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Carregando países...'),
                        ],
                      ),
                    ),
                  ),
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
                errorMessage.value = '';
                try {
                  regraList = await listRegras.pesquisa(regra);
                } catch (e) {
                  regraList = [];
                  errorMessage.value = 'Erro ao pesquisar: ${e.toString()}';
                }
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
                      child: ValueListenableBuilder<String>(
                        valueListenable: errorMessage,
                        builder: (context, error, child) {
                          if (error.isNotEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline, 
                                       color: Colors.red, size: 48),
                                  SizedBox(height: 16),
                                  Text(error, 
                                       style: TextStyle(color: Colors.red),
                                       textAlign: TextAlign.center),
                                ],
                              ),
                            );
                          }
                          
                          if (loading.value) {
                            return cicleLoading(context);
                          }
                          
                          if (regraList.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off, 
                                       color: Colors.grey, size: 48),
                                  SizedBox(height: 16),
                                  Text('Nenhuma regra encontrada',
                                       style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            );
                          }
                          
                          return listRegras.exibirListaConsulta(context, regraList) ?? Container();
                        },
                      ),
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

  pesquisa(regra) async {
    try {
      return await RegraApi().pesquisaRegra(regra);
    } catch (e) {
      throw Exception('Erro ao realizar pesquisa: ${e.toString()}');
    }
  }
}

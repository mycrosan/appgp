import 'package:GPPremium/service/regraapi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/OrderData.dart';
import '../../models/marca.dart';
import '../../models/medida.dart';
import '../../models/modelo.dart';
import '../../models/pais.dart';
import '../../models/regra.dart';
import '../../service/marcaapi.dart';
import '../../service/medidaapi.dart';
import '../../service/modeloapi.dart';
import '../../service/paisapi.dart';
import '../../service/producaoapi.dart';
import '../carcaca/ListaCarcacas.dart';
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

  final DinamicListCard listCards = DinamicListCard();

  TextEditingController textEditingControllerCarcaca;
  Regra regra;

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

  List<Regra> regraList = [];

  @override
  void initState() {
    super.initState();
    textEditingControllerModelo = TextEditingController();
    textEditingControllerMarca = TextEditingController();
    textEditingControllerMedida = TextEditingController();
    regra = new Regra();
    // producao.carcaca = new Carcaca();
    // producao.carcaca.modelo = new Modelo();
    // producao.carcaca.modelo.marca = new Marca();

    ModeloApi().getAll().then((List<Modelo> value) {
      setState(() {
        modeloList = value;
        alfabetSortList(modeloList);
      });
    });

    MedidaApi().getAll().then((List<Medida> value) {
      setState(() {
        medidaList = value;
        alfabetSortList(medidaList);
      });
    });

    PaisApi().getAll().then((List<Pais> value) {
      setState(() {
        paisList = value;
        alfabetSortList(paisList);
      });
    });

    MarcaApi().getAll().then((List<Marca> value) {
      setState(() {
        marcaList = value;
        alfabetSortList(marcaList);
      });
    });

    // ProducaoApi().getAll().then((List<Regra> value) {
    //   setState(() {
    //     regraList = value;
    //     loading.value = false;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    var regraAPI = new RegraApi();

    final RegraApi producao = Provider.of(context);

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
                  controller: textEditingControllerCarcaca,
                  decoration: InputDecoration(
                    hintText: 'Nº Regra',
                    contentPadding: EdgeInsets.all(10.0),
                    // prefixIcon: Icon(Icons.search),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (String newValue) async {
                    if (newValue.length >= 6) {
                      loading.value = true;
                      //   producao.carcaca.numeroEtiqueta = newValue;
                      //   producaoList = await listCards.pesquisa(producao);
                      //   loading.value = false;
                      //   _isList.value = true;
                      //   listCards.exibirListaConsulta(context, producaoList);
                      //   _isList.notifyListeners();
                      //   listCards.notifyListeners();
                      //   loading.notifyListeners();
                      // } else {
                      //   _isList.value = true;
                      //   _isList.notifyListeners();
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
        Row(children: [
          Expanded(
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: "Modelo",
              ),
              validator: (value) => value == null ? 'Não pode ser nulo' : null,
              value: modeloSelected,
              isExpanded: true,
              onChanged: (Modelo modelo) {
                setState(() {
                  modeloSelected = modelo;
                  // producao.carcaca.modelo = modeloSelected;
                  marcaSelected = modeloSelected.marca;
                  // producao.carcaca.modelo.marca = marcaSelected;
                });
              },
              items: modeloList.map((Modelo modelo) {
                return DropdownMenuItem(
                  value: modelo,
                  child: Text(modelo.descricao),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          Expanded(
              child: DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "Marca",
            ),
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            value: marcaSelected,
            isExpanded: true,
            onChanged: (Marca marca) {
              setState(() {
                marcaSelected = marca;
                // producao.carcaca.modelo.marca = marcaSelected;
              });
            },
            items: marcaList.map((Marca marca) {
              return DropdownMenuItem(
                value: marca,
                child: Text(marca.descricao),
              );
            }).toList(),
          )),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          ]),
          
          Row(children: [
            Expanded(
                child: DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: "Medida",
              ),
              validator: (value) => value == null ? 'Não pode ser nulo' : null,
              value: medidaSelected,
              isExpanded: true,
              onChanged: (Medida medida) {
                setState(() {
                  medidaSelected = medida;
                  // producao.carcaca.medida = medidaSelected;
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
              validator: (value) => value == null ? 'Não pode ser nulo' : null,
              value: paisSelected,
              isExpanded: true,
              onChanged: (Pais pais) {
                setState(() {
                  paisSelected = pais;
                  // producao.carcaca.pais = paisSelected;
                });
              },
              items: paisList.map((Pais pais) {
                return DropdownMenuItem(
                  value: pais,
                  child: Text(pais.descricao),
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
                    // producaoList = await listCards.pesquisa(producao);
                    // loading.value = false;
                    // _isList.value = true;
                    // _isList.notifyListeners();
                  }
                },
              )),

          Container(
            height: 500.0,
            padding: EdgeInsets.all(10),
            child: FutureBuilder(
                future: regraAPI.getAll(),
                builder: (context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(
                                'Matriz: ' +
                                    snapshot.data[index].matriz.descricao,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Wrap(
                                children: [
                                  Text.rich(TextSpan(
                                      text: 'Medida: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: snapshot
                                              .data[index].medida.descricao,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        )
                                      ])),
                                  Padding(
                                    padding: EdgeInsets.all(3),
                                  ),
                                  Text.rich(TextSpan(
                                      text: 'Marca: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: snapshot.data[index].modelo
                                              .marca.descricao,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        )
                                      ])),
                                  Padding(
                                    padding: EdgeInsets.all(3),
                                  ),
                                  Text.rich(TextSpan(
                                      text: 'Modelo: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: snapshot
                                              .data[index].modelo.descricao,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        )
                                      ])),
                                  Padding(
                                    padding: EdgeInsets.all(3),
                                  ),
                                  Text.rich(TextSpan(
                                      text: 'País: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: snapshot
                                              .data[index].pais.descricao,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        )
                                      ])),
                                  Padding(
                                    padding: EdgeInsets.all(3),
                                  ),
                                  Text.rich(TextSpan(
                                      text: 'Camelback: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: snapshot
                                              .data[index].camelback.descricao,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        )
                                      ])),
                                  Text.rich(TextSpan(
                                      text: 'COD: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: snapshot.data[index].id
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        )
                                      ])),
                                  Padding(
                                    padding: EdgeInsets.all(3),
                                  ),
                                  Text.rich(TextSpan(
                                      text: 'Min: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: snapshot.data[index].tamanhoMin
                                              .toStringAsFixed(3),
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        )
                                      ])),
                                  Padding(
                                    padding: EdgeInsets.all(3),
                                  ),
                                  Text.rich(TextSpan(
                                      text: 'Máx: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: snapshot.data[index].tamanhoMax
                                              .toStringAsFixed(3),
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        )
                                      ])),
                                ],
                              ),
                              // subtitle: Text('COD: ' +
                              //     snapshot.data[index].id.toString() +
                              //     ' Min: ' +
                              //     snapshot.data[index].tamanhoMin.toString() +
                              //     ' Min: ' +
                              //     snapshot.data[index].tamanhoMax.toString() +
                              //     '\n' +
                              //     'Marca: ' +
                              //     snapshot.data[index].modelo.marca.descricao +
                              //     '\n' +
                              //     'Modelo: ' +
                              //     snapshot.data[index].modelo.descricao +
                              //     '\n' +
                              //     'Pais: ' +
                              //     snapshot.data[index].pais.descricao + ' | Camelback: ' +
                              //     snapshot.data[index].camelback.descricao
                              // ),
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
                                                      EditarRegraPage(
                                                        regra: snapshot
                                                            .data[index],
                                                      )));
                                        },
                                        icon: Icon(Icons.edit,
                                            color: Colors.orange)),

                                    IconButton(
                                        onPressed: () async {
                                          Provider.of<RegraApi>(context,
                                                  listen: false)
                                              .delete(snapshot.data[index].id);
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
                                              id: snapshot.data[index].id,
                                            )));
                              },
                            ),
                          );
                        });
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          )
        ]),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => AdicionarRegraPage(), //AddCarcacaPage(),
      //         ));
      //   },
      //   child: Icon(
      //     Icons.add,
      //   ),
      // ),
    );
  }
}

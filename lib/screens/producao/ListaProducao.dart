import 'package:GPPremium/service/producaoapi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/OrderData.dart';
import '../../models/carcaca.dart';
import '../../models/medida.dart';
import '../../models/modelo.dart';
import '../../models/pais.dart';
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
  Carcaca carcaca;

  //Modelo
  List<Modelo> modeloList = [];
  Modelo modeloSelected;

  //Medida
  List<Medida> medidaList = [];
  Medida medidaSelected;

  //Pais
  List<Pais> paisList = [];
  Pais paisSelected;

  @override
  void initState() {
    // super.initState();

    textEditingControllerModelo = TextEditingController();
    textEditingControllerMarca = TextEditingController();
    textEditingControllerMedida = TextEditingController();
    carcaca = new Carcaca();

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
  }

  @override
  Widget build(BuildContext context) {
    var producaoAPI = new ProducaoApi();
    final ProducaoApi producao = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Produção'),
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
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: _construirFormulario(context)),
          Padding(
            padding: EdgeInsets.all(10),
            child: FutureBuilder(
                future: producaoAPI.getAll(),
                builder: (context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text('Número Etiqueta: ' +
                                  snapshot.data[index].carcaca.numeroEtiqueta),
                              subtitle: Text('Etiqueta: ' +
                                  snapshot.data[index].medidaPneuRaspado
                                      .toString() +
                                  ' Regra: ' +
                                  snapshot.data[index].regra.id.toString()),
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
                                                        producao: snapshot
                                                            .data[index],
                                                      )));
                                        },
                                        icon: Icon(Icons.edit,
                                            color: Colors.orange)),

                                    IconButton(
                                        onPressed: () async {
                                          Provider.of<ProducaoApi>(context,
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
                                        builder: (context) =>
                                            DetalhesProducaoPage(
                                              producao: snapshot.data[index],
                                            )));
                              },
                            ),
                          );
                        });
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) =>
      //               AdicionarProducaoPage(), //AddCarcacaPage(),
      //         ));
      //   },
      //   child: Icon(
      //     Icons.add,
      //   ),
      // ),
    );
  }

  Widget _construirFormulario(context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "Modelo",
            ),
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            value: modeloSelected,
            isExpanded: true,
            onChanged: (Modelo modelo) {
              setState(() {
                modeloSelected = modelo;
                carcaca.modelo = modeloSelected;
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
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "Medida",
            ),
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            value: medidaSelected,
            isExpanded: true,
            onChanged: (Medida medida) {
              setState(() {
                medidaSelected = medida;
                carcaca.medida = medidaSelected;
              });
            },
            items: medidaList.map((Medida medida) {
              return DropdownMenuItem(
                value: medida,
                child: Text(medida.descricao),
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "País",
            ),
            validator: (value) => value == null ? 'Não pode ser nulo' : null,
            value: paisSelected,
            isExpanded: true,
            onChanged: (Pais pais) {
              setState(() {
                paisSelected = pais;
                carcaca.pais = paisSelected;
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
        ],
      ),
    );
  }
}

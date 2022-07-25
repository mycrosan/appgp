import 'package:GPPremium/components/Loading.dart';
import 'package:GPPremium/components/snackBar.dart';
import 'package:GPPremium/models/classificacao.dart';
import 'package:GPPremium/models/observacao.dart';
import 'package:GPPremium/models/producao.dart';
import 'package:GPPremium/screens/qualidade/qualificar.dart';
import 'package:GPPremium/service/tipo_classificacaoapi.dart';
import 'package:GPPremium/service/tipo_observacacaoapi.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/OrderData.dart';
import '../../models/carcaca.dart';
import '../../models/qualidade.dart';
import '../../service/Qualidadeapi.dart';
import '../../service/producaoapi.dart';
import 'adicionar.dart';
import 'editdatawidget.dart';

class ListaQualidade extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaQualidadeState();
  }
}

class ListaQualidadeState extends State<ListaQualidade> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController textEditingControllerModelo;
  TextEditingController textEditingControllerMarca;
  TextEditingController textEditingControllerMedida;

  // final DinamicListCard listCards = DinamicListCard();

  TextEditingController textEditingControllerCarcaca;
  Qualidade qualidade;

  // bool loading = true;
  var loading = ValueNotifier<bool>(true);

  //Classificacão
  List<TipoClassificacao> classificacaoList = [];
  TipoClassificacao classificacaoSelected;

  //Observacação
  List<TipoObservacao> observacaoList = [];
  TipoObservacao observavaoSelected;

  List<Qualidade> qualidadeList = [];
  List<Producao> producaoList = [];

  @override
  void initState() {
    super.initState();
    textEditingControllerModelo = TextEditingController();
    textEditingControllerMarca = TextEditingController();
    textEditingControllerMedida = TextEditingController();
    qualidade = new Qualidade();
    qualidade.producao = new Producao();
    qualidade.producao.carcaca = new Carcaca();
    qualidade.tipo_observacao = new TipoObservacao();

    TipoClassificacaoApi().getAll().then((List<TipoClassificacao> value) {
      setState(() {
        classificacaoList = value;
        alfabetSortList(classificacaoList);
      });
    });

    TipoObservacacaoApi().getAll().then((List<TipoObservacao> value) {
      setState(() {
        observacaoList = value;
        alfabetSortList(observacaoList);
      });
    });

    QualidadeApi().getAll().then((List<Qualidade> value) {
      setState(() {
        qualidadeList = value;
        loading.value = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // var qualidadeAPI = new QualidadeApi();
    // final QualidadeApi qualidade = Provider.of(context);

    final DinamicShowCards listCards = DinamicShowCards();

    TextEditingController textEditingControllerCarcaca;
    textEditingControllerCarcaca = MaskedTextController(mask: '000000');

    List listaQualidade = [];
    var _isList = ValueNotifier<bool>(true);

    // final QualidadeApi producoes = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          child: Row(children: [
            Expanded(child: Text("Qualidade")),
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
                      qualidade.producao.carcaca.numeroEtiqueta = newValue;
                      producaoList =
                          await listCards.pesquisa(qualidade.producao);
                      loading.value = false;
                      _isList.value = true;
                      listCards.exibirProducao(context, producaoList);
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
                    builder: (context) => AdicionarQualidadePage(),
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

                ValueListenableBuilder(
                    valueListenable: _isList,
                    builder: (_, __, ___) {
                      return Visibility(
                          visible: _isList.value,
                          child: listCards.exibirProducao(context, producaoList) != null
                              ? listCards.exibirProducao(context, producaoList)
                              : Text(''));
                    }),
                Visibility(
                  child: listCards.exibirListaConsulta(
                              context, qualidadeList) !=
                          null
                      ? listCards.exibirListaConsulta(context, qualidadeList)
                      : loading.value
                          ? cicleLoading(context)
                          : qualidadeList.length == 0
                              ? Text('')
                              : '',
                ),
              ],
            ),
          )),
    );
  }
}

class DinamicShowCards extends ChangeNotifier {
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
                    title: Text('Etiqueta: ' +
                        Servico[index].producao.carcaca.numeroEtiqueta),
                    subtitle: Text('Med. Pneu Rasp.: ' +
                        Servico[index].producao.medidaPneuRaspado.toString() +
                        ' Regra: ' +
                        Servico[index].producao.regra.id.toString()),
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
                                            EditarQualidadePage(
                                              qualidade: Servico[index],
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
                                          "Tem certeza que deseja excluir o item ${Servico[index].producao.carcaca.numeroEtiqueta}"),
                                      actions: [
                                        ElevatedButton(
                                          child: Text("Sim"),
                                          onPressed: () async {
                                            var response =
                                                await Provider.of<QualidadeApi>(
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
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => DetalhesQualidadePage(
                      //           qualidade: Servico[index],
                      //         )));
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

  exibirProducao(context, Servico) {
    if (Servico.length > 0) {
      Servico = Servico[0];
      return Card(
        child: ListTile(
          title: Text('Etiqueta: ' + Servico.carcaca.numeroEtiqueta),
          subtitle: Text('Med. Pneu Rasp.: ' +
              Servico.medidaPneuRaspado.toString() +
              ' Regra: ' +
              Servico.regra.id.toString()),
          trailing: Container(
            width: 50,
            child: Row(
              children: <Widget>[
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AdicionarQualificarPage(
                                    producao: Servico,
                                  )));
                    },
                    icon: Icon(Icons.check_rounded, color: Colors.green))

              ],
            ),
          ),
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => DetalhesQualidadePage(
            //           qualidade: Servico[index],
            //         )));
          },
        ),
      );
    } else {
      return null;
    }
  }

  pesquisa(producao) {
    return ProducaoApi().consultaProducao(producao);
  }
}

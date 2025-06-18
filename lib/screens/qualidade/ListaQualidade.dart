import 'package:GPPremium/components/Loading.dart';
import 'package:GPPremium/components/snackBar.dart';
import 'package:GPPremium/screens/qualidade/qualificar.dart';
import 'package:GPPremium/service/qualidadeapi.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/carcaca.dart';
import '../../models/classificacao.dart';
import '../../models/observacao.dart';
import '../../models/producao.dart';
import '../../models/qualidade.dart';
import '../../models/responseMessage.dart';
import '../../service/producaoapi.dart';
import '../../service/tipo_classificacaoapi.dart';
import '../../service/tipo_observacacaoapi.dart';
import 'detailwidget.dart';
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
      });
    });

    TipoObservacacaoApi().getAll().then((List<TipoObservacao> value) {
      setState(() {
        observacaoList = value;
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
    final DinamicShowCards listCards = DinamicShowCards();

    TextEditingController textEditingControllerCarcaca;
    TextEditingController textEditingControllerQualidade;
    textEditingControllerCarcaca = MaskedTextController(mask: '000000');

    var _isList = ValueNotifier<bool>(false);
    var _isListQualidade = ValueNotifier<bool>(false);
    Qualidade qualidadePesquisa;

//Fica escutando as mudanças
    final QualidadeApi qualidades = Provider.of(context);

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
                    hintText: 'Nº etiqueta',
                    contentPadding: EdgeInsets.all(10.0),
                    // prefixIcon: Icon(Icons.search),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (String newValue) async {
                    if (newValue.length >= 6) {
                      loading.value = true;
                      var response =
                          await listCards.pesquisaQualidade(newValue);
                      loading.value = false;
                      if (response is Qualidade && response != null) {
                        _isListQualidade.value = true;
                        qualidadePesquisa = response;
                        listCards.exibirQualidade(context, response);
                        _isListQualidade.notifyListeners();
                        listCards.notifyListeners();
                        loading.notifyListeners();
                      } else if (response.status == 'PRECONDITION_REQUIRED') {
                        loading.value = true;
                        qualidade.producao.carcaca.numeroEtiqueta = newValue;
                        producaoList = await listCards
                            .pesquisaProducao(qualidade.producao);
                        if (producaoList.length > 0) {
                          loading.value = false;
                          _isList.value = true;
                          listCards.exibirProducao(context, producaoList);
                          _isList.notifyListeners();
                          listCards.notifyListeners();
                          loading.notifyListeners();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              warningMessage(context,
                                  "Sem resultados para etiqueta " + newValue));
                        }
                      } else {
                        responseMessage value =
                            response != null ? response : null;
                        ScaffoldMessenger.of(context).showSnackBar(
                            warningMessage(context, value.message));
                      }
                    } else {
                      _isListQualidade.value = false;
                      _isList.value = false;
                      _isListQualidade.notifyListeners();
                    }
                  },
                ),
              ),
            )
          ]),
        ),
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
                          child: listCards.exibirProducao(
                                      context, producaoList) !=
                                  null
                              ? listCards.exibirProducao(context, producaoList)
                              : Text(''));
                    }),
                ValueListenableBuilder(
                    valueListenable: _isListQualidade,
                    builder: (_, __, ___) {
                      return Visibility(
                          visible: _isListQualidade.value,
                          child: listCards.exibirQualidade(
                                      context, qualidadePesquisa) !=
                                  null
                              ? listCards.exibirQualidade(
                                  context, qualidadePesquisa)
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
      return Expanded(
        child: ListView.builder(
            itemCount: Servico.length,
            itemBuilder: (context, index) {
              if (Servico.length > 0) {
                return Card(
                  child: ListTile(
                    title: Text('Etiquetas: ' +
                        Servico[index].producao.carcaca.numeroEtiqueta),
                    subtitle: Text('Med. Pneu Rasp.: ' +
                        Servico[index].producao.medidaPneuRaspado.toString() +
                        ' Regra: ' +
                        Servico[index].producao.regra.id.toString() +
                        ' Situação: ' +
                        Servico[index]
                            .tipo_observacao
                            .tipoClassificacao
                            .descricao +
                        ' Classificação: ' +
                        Servico[index].tipo_observacao.descricao),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetalhesQualidadePage(
                                    qualidade: Servico[index],
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

  exibirProducao(context, Servico) {
    if (Servico.length > 0) {
      Servico = Servico[0];
      return Card(
        child: ListTile(
          title: Text('Etiqueta2: ' + Servico.carcaca.numeroEtiqueta),
          subtitle: Text('Med. Pneu Rasp.: ' +
              Servico.medidaPneuRaspado.toString() +
              ' Regra: ' +
              Servico.regra.id.toString()
          ),
          trailing: Container(
            width: 50,
            child: Row(
              children: <Widget>[
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdicionarQualificarPage(
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

  exibirQualidade(context, Servico) {
    if (Servico != null) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.white70,
        child: ListTile(
          title: Text('Etiqueta: ' + Servico.producao.carcaca.numeroEtiqueta),
          subtitle: Text('Med. Pneu Rasp.: ' +
              Servico.producao.medidaPneuRaspado.toString() +
              ' Regra: ' +
              Servico.producao.regra.id.toString()
              +
              ' Situação: ' +
              Servico
                  .tipo_observacao
                  .tipoClassificacao
                  .descricao +
              ' Classificação: ' +
              Servico.tipo_observacao.descricao
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
                              builder: (context) => EditarQualidadePage(
                                    qualidade: Servico,
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
                                "Tem certeza que deseja excluir o item ${Servico.producao.carcaca.numeroEtiqueta}"),
                            actions: [
                              ElevatedButton(
                                child: Text("Sim"),
                                onPressed: () async {
                                  Provider.of<QualidadeApi>(context,
                                          listen: false)
                                      .delete(Servico.id);
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
                    builder: (context) => DetalhesQualidadePage(
                          qualidade: Servico,
                        )));
          },
        ),
      );
    } else {
      return null;
    }
  }

  pesquisaProducao(producao) {
    return ProducaoApi().consultaProducao(producao);
  }

  pesquisaQualidade(qualidade) {
    return QualidadeApi().consultaQualidade(qualidade);
  }
}

import 'package:GPPremium/components/Loading.dart';
import 'package:GPPremium/components/snackBar.dart';
import 'package:GPPremium/screens/qualidade/qualificar.dart';
import 'package:GPPremium/service/qualidadeapi.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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

  late TextEditingController textEditingControllerModelo;
  late TextEditingController textEditingControllerMarca;
  late TextEditingController textEditingControllerMedida;
  late TextEditingController textEditingControllerCarcaca;
  late Qualidade qualidade;

  var loading = ValueNotifier<bool>(true);

  //Classificacao
  List<TipoClassificacao> classificacaoList = [];
  late TipoClassificacao classificacaoSelected;
  //Observacao
  List<TipoObservacao> observacaoList = [];
  late TipoObservacao observavaoSelected;

  List<Qualidade> qualidadeList = [];
  List<Producao> producaoList = [];

  //Pesquisa
  late Qualidade qualidadePesquisa;

  final _isList = ValueNotifier<bool>(false);
  final _isListQualidade = ValueNotifier<bool>(false);

  final DinamicShowCards listCards = DinamicShowCards();

  @override
  void initState() {
    super.initState();
    textEditingControllerModelo = TextEditingController();
    textEditingControllerMarca = TextEditingController();
    textEditingControllerMedida = TextEditingController();
    textEditingControllerCarcaca = MaskedTextController(mask: '000000');
    qualidade = Qualidade();
    qualidade.producao = Producao();
    qualidade.producao.carcaca = Carcaca();
    qualidade.tipo_observacao = TipoObservacao();

    TipoClassificacaoApi().getAll().then((value) {
      setState(() => classificacaoList = value);
    });

    TipoObservacacaoApi().getAll().then((value) {
      setState(() => observacaoList = value);
    });

    QualidadeApi().getAll().then((value) {
      setState(() {
        qualidadeList = value;
        loading.value = false;
      });
    });
  }

  Future<void> pesquisarPorEtiqueta(String etiqueta) async {
    if (etiqueta.length >= 6) {
      etiqueta = etiqueta.padLeft(6, '0');
      loading.value = true;
      var response = await listCards.pesquisaQualidade(etiqueta);
      loading.value = false;
      if (response is Qualidade) {
        _isListQualidade.value = true;
        qualidadePesquisa = response;
        listCards.notifyListeners();
      } else if (response.status == 'PRECONDITION_REQUIRED') {
        qualidade.producao.carcaca.numeroEtiqueta = etiqueta;
        producaoList = await listCards.pesquisaProducao(qualidade.producao);
        if (producaoList.isNotEmpty) {
          _isList.value = true;
          listCards.notifyListeners();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            warningMessage(context, "Sem resultados para etiqueta $etiqueta"),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          warningMessage(context, response.message ?? 'Erro na leitura'),
        );
      }
    }
  }

  Future<void> scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancelar',
      true,
      ScanMode.BARCODE,
    );

    if (barcodeScanRes != '-1') {
      barcodeScanRes = barcodeScanRes.padLeft(6, '0');
      textEditingControllerCarcaca.text = barcodeScanRes;
      await pesquisarPorEtiqueta(barcodeScanRes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final QualidadeApi qualidades = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text("Qualidade")),
            Expanded(
              child: Container(
                color: Colors.white,
                height: 30.0,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: textEditingControllerCarcaca,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          hintText: 'Etiqueta',
                          contentPadding: EdgeInsets.all(12.0),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (String newValue) async {
                          await pesquisarPorEtiqueta(newValue);
                        },
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.qr_code_scanner, size: 20, color: Colors.black),
                        onPressed: scanBarcode,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
                    child: listCards.exibirProducao(context, producaoList) != null
                        ? listCards.exibirProducao(context, producaoList)
                        : Text(''),
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: _isListQualidade,
                builder: (_, __, ___) {
                  return Visibility(
                    visible: _isListQualidade.value,
                    child: listCards.exibirQualidade(context, qualidadePesquisa) != null
                        ? listCards.exibirQualidade(context, qualidadePesquisa)
                        : Text(''),
                  );
                },
              ),
              Visibility(
                child: listCards.exibirListaConsulta(context, qualidadeList) != null
                    ? listCards.exibirListaConsulta(context, qualidadeList)
                    : loading.value
                    ? cicleLoading(context)
                    : qualidadeList.length == 0
                    ? Text('')
                    : '',
              ),
            ],
          ),
        ),
      ),
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

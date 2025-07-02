import 'package:GPPremium/components/Loading.dart';
import 'package:GPPremium/components/snackBar.dart';
import 'package:GPPremium/service/producaoapi.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
  TextEditingController textEditingControllerCarcaca;
  Producao producao;

  var loading = ValueNotifier<bool>(true);

  List<Modelo> modeloList = [];
  Modelo modeloSelected;

  List<Medida> medidaList = [];
  Medida medidaSelected;

  List<Pais> paisList = [];
  Pais paisSelected;

  List<Marca> marcaList = [];
  Marca marcaSelected;

  List<Producao> producaoList = [];

  @override
  void initState() {
    super.initState();
    textEditingControllerModelo = TextEditingController();
    textEditingControllerMarca = TextEditingController();
    textEditingControllerMedida = TextEditingController();
    textEditingControllerCarcaca = MaskedTextController(mask: '000000');

    producao = Producao();
    producao.carcaca = Carcaca();
    producao.carcaca.modelo = Modelo();
    producao.carcaca.modelo.marca = Marca();

    ModeloApi().getAll().then((value) => setState(() => modeloList = value));
    MedidaApi().getAll().then((value) => setState(() => medidaList = value));
    PaisApi().getAll().then((value) => setState(() => paisList = value));
    MarcaApi().getAll().then((value) => setState(() => marcaList = value));

    ProducaoApi().getAll().then((value) {
      setState(() {
        producaoList = value;
        loading.value = false;
      });
    });
  }

  Future<void> scanBarcode() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancelar',
        true,
        ScanMode.BARCODE,
      );

      if (barcodeScanRes != '-1') {
        String etiquetaFormatada = barcodeScanRes.padLeft(6, '0');

        setState(() {
          textEditingControllerCarcaca.text = etiquetaFormatada;
        });

        await _pesquisarEtiqueta(etiquetaFormatada);
      }
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(
        errorMessage(context, "Falha ao iniciar o scanner."),
      );
    }
  }


  Future<void> _pesquisarEtiqueta(String etiqueta) async {
    final listCards = DinamicListCard();
    loading.value = true;
    producao.carcaca.numeroEtiqueta = etiqueta;
    producaoList = await listCards.pesquisa(producao);
    loading.value = false;

    if (producaoList.isNotEmpty) {
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        warningMessage(context, "Sem resultados para etiqueta $etiqueta"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final listCards = DinamicListCard();
    var _isList = ValueNotifier<bool>(true);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text("Produção")),
            Expanded(
              child: Container(
                color: Colors.white,
                height: 30.0,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: textEditingControllerCarcaca,
                        style: TextStyle(fontSize: 12),  // fonte reduzida
                        decoration: InputDecoration(
                          hintText: 'Etiqueta',
                          contentPadding: EdgeInsets.all(12.0),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (newValue) async {
                          if (newValue.length >= 6) {
                            await _pesquisarEtiqueta(newValue);
                          } else {
                            _isList.value = false;
                          }
                        },
                      ),
                    ),
                    Container(
                      height: 30,  // Mesma altura da sua TextFormField
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
            )

          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdicionarProducaoPage()));
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
                decoration: InputDecoration(labelText: "Modelo"),
                validator: (value) => value == null ? 'Não pode ser nulo' : null,
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
                items: modeloList.map((modelo) {
                  return DropdownMenuItem(
                    value: modelo,
                    child: Text(modelo.descricao),
                  );
                }).toList(),
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(labelText: "Medida"),
                      validator: (value) => value == null ? 'Não pode ser nulo' : null,
                      value: medidaSelected,
                      isExpanded: true,
                      onChanged: (Medida medida) {
                        setState(() {
                          medidaSelected = medida;
                          producao.carcaca.medida = medidaSelected;
                        });
                      },
                      items: medidaList.map((medida) {
                        return DropdownMenuItem(
                          value: medida,
                          child: Text(medida.descricao),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(labelText: "País"),
                      validator: (value) => value == null ? 'Não pode ser nulo' : null,
                      value: paisSelected,
                      isExpanded: true,
                      onChanged: (Pais pais) {
                        setState(() {
                          paisSelected = pais;
                          producao.carcaca.pais = paisSelected;
                        });
                      },
                      items: paisList.map((pais) {
                        return DropdownMenuItem(
                          value: pais,
                          child: Text(pais.descricao),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(labelText: "Marca"),
                      validator: (value) => value == null ? 'Não pode ser nulo' : null,
                      value: marcaSelected,
                      isExpanded: true,
                      onChanged: (Marca marca) {
                        setState(() {
                          marcaSelected = marca;
                          producao.carcaca.modelo.marca = marcaSelected;
                        });
                      },
                      items: marcaList.map((marca) {
                        return DropdownMenuItem(
                          value: marca,
                          child: Text(marca.descricao),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                child: Text("Pesquisar"),
                onPressed: () async {
                  loading.value = true;
                  producaoList = await listCards.pesquisa(producao);
                  loading.value = false;
                  _isList.value = true;
                },
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _isList,
                  builder: (_, __, ___) {
                    return Visibility(
                      child: listCards.exibirListaConsulta(context, producaoList) ??
                          (loading.value
                              ? cicleLoading(context)
                              : producaoList.isEmpty
                              ? Text('Nenhuma produção encontrada')
                              : Container()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DinamicListCard extends ChangeNotifier {
  exibirListaConsulta(context, Servico) {
    if (Servico.isNotEmpty) {
      return Container(
        height: 400.0,
        child: ListView.builder(
          itemCount: Servico.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text('Etiqueta: ${Servico[index].carcaca.numeroEtiqueta}'),
                subtitle: Text(
                    'Med. Pneu Rasp.: ${Servico[index].medidaPneuRaspado} | Regra: ${Servico[index].regra.id}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditarProducaoPage(producao: Servico[index]),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        bool confirm = await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Excluir"),
                            content: Text("Excluir item ${Servico[index].carcaca.numeroEtiqueta}?"),
                            actions: [
                              TextButton(
                                child: Text("Não"),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                              TextButton(
                                child: Text("Sim"),
                                onPressed: () => Navigator.pop(context, true),
                              ),
                            ],
                          ),
                        );
                        if (confirm) {
                          bool deleted = await Provider.of<ProducaoApi>(context, listen: false)
                              .delete(Servico[index].id);
                          if (deleted) {
                            Servico.removeAt(index);
                            ScaffoldMessenger.of(context).showSnackBar(deleteMessage(context));
                            notifyListeners();
                          }
                        }
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetalhesProducaoPage(producao: Servico[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    }
    return null;
  }

  pesquisa(producao) {
    return ProducaoApi().consultaProducao(producao);
  }
}

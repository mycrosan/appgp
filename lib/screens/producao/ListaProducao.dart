import 'package:GPPremium/components/snackBar.dart';
import 'package:GPPremium/service/producaoapi.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // <-- import shimmer
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
  var _isList = ValueNotifier<bool>(true);

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

    _carregarTodasProducoes();
  }

  Future<void> _carregarTodasProducoes() async {
    loading.value = true;
    List<Producao> todas = await ProducaoApi().getAll();
    setState(() {
      producaoList = todas;
      loading.value = false;
      _isList.value = true;
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
    loading.value = true;
    producao.carcaca.numeroEtiqueta = etiqueta;
    List<Producao> resultados = await DinamicListCard().pesquisa(producao);
    loading.value = false;

    setState(() {
      producaoList = resultados;
      _isList.value = true;
    });

    if (resultados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        warningMessage(context, "Sem resultados para etiqueta $etiqueta"),
      );
    }
  }

  Future<void> _pesquisar() async {
    loading.value = true;
    List<Producao> resultados = await DinamicListCard().pesquisa(producao);
    loading.value = false;

    setState(() {
      producaoList = resultados;
      _isList.value = true;
    });
  }

  Widget _shimmerLoading() {
    // Simula uma lista com 5 cards shimmer
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listCards = DinamicListCard();

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
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          hintText: 'Etiqueta',
                          contentPadding: EdgeInsets.all(12.0),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
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
                      height: 30,
                      width: 30,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.qr_code_scanner,
                            size: 20, color: Colors.black),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AdicionarProducaoPage()));
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
              DropdownSearch<Modelo>(
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
                    producao.carcaca.modelo = modeloSelected;
                    marcaSelected = modeloSelected.marca;
                    producao.carcaca.modelo.marca = marcaSelected;
                  });
                },
              ),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(labelText: "Medida"),
                      validator: (value) =>
                          value == null ? 'Não pode ser nulo' : null,
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
                      validator: (value) =>
                          value == null ? 'Não pode ser nulo' : null,
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
                      validator: (value) =>
                          value == null ? 'Não pode ser nulo' : null,
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
              SizedBox(height: 8),
              ElevatedButton(
                child: Text("Pesquisar"),
                onPressed: () async {
                  await _pesquisar();
                },
              ),
              SizedBox(height: 8),
              Expanded(
                child: ValueListenableBuilder<bool>(
                  valueListenable: loading,
                  builder: (_, isLoading, __) {
                    if (isLoading) {
                      return _shimmerLoading();
                    } else {
                      return ValueListenableBuilder<bool>(
                        valueListenable: _isList,
                        builder: (_, isListVisible, __) {
                          if (!isListVisible) {
                            return Center(
                                child: Text('Digite uma etiqueta válida.'));
                          }
                          if (producaoList.isEmpty) {
                            return Center(
                                child: Text('Nenhuma produção encontrada'));
                          }
                          return listCards.exibirListaConsulta(
                              context, producaoList);
                        },
                      );
                    }
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
  Widget exibirListaConsulta(BuildContext context, List<Producao> listaProducao,
      {String etiquetaDestacada}) {
    return ListView.builder(
      itemCount: listaProducao.length,
      itemBuilder: (context, index) {
        final producao = listaProducao[index];
        final isHighlighted = etiquetaDestacada != null &&
            producao.carcaca.numeroEtiqueta == etiquetaDestacada;

        return Card(
          color: isHighlighted ? Colors.green[50] : null,
          elevation: isHighlighted ? 4 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isHighlighted
                ? BorderSide(color: Colors.green, width: 2)
                : BorderSide.none,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.confirmation_number_outlined,
                              color: Colors.blueGrey),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Etiqueta: ${producao.carcaca.numeroEtiqueta}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.straighten,
                              size: 16, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text('Med. Raspado: ${producao.medidaPneuRaspado}'),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.rule, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text('Regra: ${producao.regra?.id ?? ''}'),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.model_training,
                              size: 16, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Modelo: ${producao.carcaca.modelo?.descricao ?? ''}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditarProducaoPage(producao: producao),
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
                            content: Text(
                                "Excluir item ${producao.carcaca.numeroEtiqueta}?"),
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
                          bool deleted = await Provider.of<ProducaoApi>(context,
                                  listen: false)
                              .delete(producao.id);
                          if (deleted) {
                            listaProducao.removeAt(index);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(deleteMessage(context));
                            notifyListeners();
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  pesquisa(Producao producao) {
    return ProducaoApi().consultaProducao(producao);
  }
}

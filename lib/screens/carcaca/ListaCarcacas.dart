import 'package:GPPremium/models/carcaca.dart';
import 'package:GPPremium/screens/carcaca/adicionar.dart';
import 'package:GPPremium/screens/carcaca/editdatawidget.dart';
import 'package:GPPremium/service/carcacaapi.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../components/snackBar.dart';
import '../../models/responseMessage.dart';
import 'detailwidget.dart';

class ListaCarcaca extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaCarcacaState();
  }
}

class ListaCarcacaState extends State<ListaCarcaca> {
  TextEditingController textEditingControllerCarcaca;
  Carcaca _responseValue;
  var _isList = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    textEditingControllerCarcaca = MaskedTextController(mask: '000000');
  }

  Future<void> _scanBarcode() async {
    String barcodeScanRes = '';
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#FF6666', 'Cancelar', true, ScanMode.BARCODE,
      );
    } catch (e) {
      print('Erro ao escanear: $e');
    }

    if (barcodeScanRes != '-1' && mounted) {
      String codigoFormatado = barcodeScanRes.padLeft(6, '0');
      setState(() {
        textEditingControllerCarcaca.text = codigoFormatado;
      });

      var response = await CarcacaApi().consultaCarcaca(codigoFormatado);
      if (response is Carcaca) {
        _responseValue = response;
        _isList.value = true;
        _isList.notifyListeners();
      } else if (response is responseMessage) {
        ScaffoldMessenger.of(context)
            .showSnackBar(warningMessage(context, response.message));
      }
    }
  }

  Widget shimmerLoadingList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: ListTile(
              title: Container(height: 12, width: 100, color: Colors.white),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, width: 150, color: Colors.white),
                  SizedBox(height: 6),
                  Container(height: 12, width: 80, color: Colors.white),
                ],
              ),
              trailing: Container(
                width: 48,
                height: 24,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final carcacasAPI = CarcacaApi();
    final listCards = DinamicListCard();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text("Carcaça")),
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
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (newValue) async {
                          if (newValue.length >= 6) {
                            String codigoFormatado = newValue.padLeft(6, '0');
                            var response = await CarcacaApi().consultaCarcaca(codigoFormatado);
                            if (response is Carcaca) {
                              _responseValue = response;
                              _isList.value = true;
                              _isList.notifyListeners();
                            } else if (response is responseMessage) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(warningMessage(context, response.message));
                            }
                          } else {
                            _isList.value = false;
                            _isList.notifyListeners();
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
                        icon: Icon(Icons.qr_code_scanner, size: 20, color: Colors.black),
                        onPressed: _scanBarcode,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdicionarCarcacaPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: _isList,
              builder: (_, __, ___) {
                return Visibility(
                  visible: _isList.value,
                  child: _responseValue != null
                      ? listCards.cardResponse(_responseValue, context, isHighlighted: true)
                      : Text(''),
                );
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: carcacasAPI.getAll(),
                builder: (context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return shimmerLoadingList();
                  }

                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data[index];
                        final isHighlighted = _responseValue != null && _responseValue.id == item.id;
                        return DinamicListCard().cardResponse(item, context, isHighlighted: isHighlighted);
                      },
                    );
                  } else {
                    return Center(child: Text('Erro ao carregar dados.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DinamicListCard extends ChangeNotifier {
  Widget cardResponse(Carcaca item, BuildContext context, {bool isHighlighted = false}) {
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
                      Icon(Icons.confirmation_number_outlined, color: Colors.blueGrey),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Etiqueta: ${item.numeroEtiqueta}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.straighten, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text('Medida: ${item.medida.descricao}', overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.flag, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text('País: ${item.pais.descricao}', overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.model_training, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Expanded(child: Text('Modelo: ${item.modelo.descricao}')),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.date_range, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text('DOT: ${item.dot}'),
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
                        builder: (_) => EditarCarcacaPage(carcacaEdit: item),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text("Excluir"),
                          content: Text("Tem certeza que deseja excluir o item ${item.numeroEtiqueta}?"),
                          actions: [
                            ElevatedButton(
                              child: Text("Sim"),
                              onPressed: () {
                                Provider.of<CarcacaApi>(context, listen: false).delete(item.id);
                                ScaffoldMessenger.of(context).showSnackBar(deleteMessage(context));
                                Navigator.pop(context);
                              },
                            ),
                            ElevatedButton(
                              child: Text("Não"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

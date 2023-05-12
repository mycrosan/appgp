import 'package:GPPremium/components/Loading.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/snackBar.dart';
import '../../models/rejeitadas.dart';
import '../../service/rejeitadasapi.dart';

class ListaRelatorio extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaRelatorioState();
  }
}

class ListaRelatorioState extends State<ListaRelatorio> {
  @override
  Widget build(BuildContext context) {
    var rejeitadasAPI = new RejeitadasApi();

    final DinamicListCard listCards = DinamicListCard();

    TextEditingController textEditingControllerRejeitadas;
    textEditingControllerRejeitadas = MaskedTextController(mask: '000000');
    Rejeitadas _responseValue;
    List ListaRelatorio = [];
    var _isList = ValueNotifier<bool>(true);

    //Fica escutando as mudanças
    final RejeitadasApi rejeitadas = Provider.of(context);

    @override
    void initState() {
      super.initState();

      this.setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Relatórios'),
        actions: [
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
                      visible: !_isList.value,
                      child: _responseValue != null
                          ? listCards.cardResponse(_responseValue, context)
                          : Text('Sem Informações'));
                }),
            // Visibility(
            //   visible: _isList.value,
            //   child: _exibirLista(context, rejeitadasAPI) != null
            //       ? _exibirLista(context, rejeitadasAPI)
            //       : 'Aguardando..',
            // ),
          ],
        ),
      ),
    );
  }
}

class DinamicListCard extends ChangeNotifier {
  cardResponse(_responseValue, context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white70,
      child: ListTile(
        title: Text('Etiqueta: ' +
            _responseValue.toString() +
            " id: " +
            _responseValue.id.toString()),
        subtitle: Text('Medida: ' +
            _responseValue.medida.descricao +
            "\n"
                'Modelo: ' +
            _responseValue.modelo.descricao),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => null));
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
                              "Tem certeza que deseja excluir o item ${_responseValue.numeroEtiqueta}"),
                          actions: [
                            ElevatedButton(
                              child: Text("Sim"),
                              onPressed: () {
                                Provider.of<RejeitadasApi>(context,
                                        listen: false)
                                    .delete(_responseValue.id);
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
                        ;
                      },
                    );
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
                  builder: (context) => null));
        },
      ),
    );
  }
}

import 'package:GPPremium/models/responseMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/ImagePreview.dart';
import '../../models/rejeitadas.dart';
import '../../service/get_image.dart';
import '../../service/rejeitadasapi.dart';

class DetalhesRejeitadasPage extends StatefulWidget {
  int id;

  DetalhesRejeitadasPage({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetalhesRejeitadasPageState();
  }
}

class DetalhesRejeitadasPageState extends State<DetalhesRejeitadasPage> {
  @override
  Widget build(BuildContext context) {
    var rejeitadaApi = new RejeitadasApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhe Carcaça'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: rejeitadaApi.getById(widget.id),
          builder: (context, AsyncSnapshot<Rejeitadas> snapshot) {
            if (snapshot.hasData) {
              return Column(children: [
                Card(
                  child: ListTile(
                    title: Text("Modelo: " + snapshot.data.modelo.descricao),
                    subtitle: Text('Medida: ' +
                        snapshot.data.medida.descricao +
                        "\n"
                            'Pais: ' +
                        snapshot.data.pais.descricao +
                        "\n"
                            'Motivo: ' +
                        ((snapshot.data.motivo != null)
                            ? snapshot.data.motivo.toString()
                            : "NI") +
                        "\n"
                            'Observacao: ' +
                        ((snapshot.data.descricao != null)
                            ? snapshot.data.descricao.toString()
                            : "NI")),
                  ),
                ),
              ]);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

import 'package:GPPremium/models/carcaca.dart';
import 'package:GPPremium/models/responseMessage.dart';
import 'package:GPPremium/service/carcacaapi.dart';
import 'package:flutter/material.dart';

import '../../components/ImagePreview.dart';
import '../../service/get_image.dart';

class DetalhesCarcacaPage extends StatefulWidget {
  final int id;

  DetalhesCarcacaPage({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetalhesCarcacaPageState();
  }
}

class DetalhesCarcacaPageState extends State<DetalhesCarcacaPage> {
  @override
  Widget build(BuildContext context) {
    var carcacaApi = CarcacaApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Carcaça'),
        centerTitle: true,
      ),
      body: FutureBuilder<Carcaca>(
        future: carcacaApi.getById(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text("Nenhum dado encontrado"));
          }

          final carcaca = snapshot.data;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Carcaça ${carcaca.id}",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Exibe os dados principais
                      _buildFieldTwoLines("Etiqueta", carcaca.numeroEtiqueta ?? "NI"),
                      _buildFieldOneLine("DOT", carcaca.dot ?? "NI"),
                      _buildFieldOneLine("Medida", carcaca.medida?.descricao ?? "NI"),
                      _buildFieldOneLine("Modelo", carcaca.modelo?.descricao ?? "NI"),
                      _buildFieldOneLine("Marca", carcaca.modelo?.marca?.descricao ?? "NI"),
                      _buildFieldOneLine("País", carcaca.pais?.descricao ?? "NI"),

                      Divider(height: 30),

                      Text(
                        "Imagens",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),

                      FutureBuilder(
                        future: ImageService().showImage(carcaca.fotos, "carcaca"),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data is responseMessage) {
                              return Text("Falha ao carregar imagem!");
                            }
                            return showImage(snapshot.data, "detalhar");
                          }
                          return Text("Nenhuma imagem disponível");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Exibe título em cima e valor embaixo
  Widget _buildFieldTwoLines(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            valor,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  /// Exibe título e valor na mesma linha
  Widget _buildFieldOneLine(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              titulo,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              valor,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:GPPremium/models/regra.dart';
import 'package:GPPremium/service/regraapi.dart';
import 'package:flutter/material.dart';

class DetalhesRegraPage extends StatefulWidget {
  final int id;

  DetalhesRegraPage({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetalhesRegraPageState();
  }
}

class DetalhesRegraPageState extends State<DetalhesRegraPage> {
  @override
  Widget build(BuildContext context) {
    var regraApi = RegraApi();
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Regra'),
        centerTitle: true,
      ),
      body: FutureBuilder<Regra>(
        future: regraApi.getById(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text("Nenhum dado encontrado"));
          }

          final regra = snapshot.data;

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
                          "Regra ${regra.id}",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Estes ficam em duas linhas
                      _buildFieldTwoLines("Matriz", regra.matriz?.descricao ?? "NI"),
                      _buildFieldTwoLines("Modelo", "${regra.modelo?.descricao ?? 'NI'} - ${regra.modelo?.marca?.descricao ?? ''}"),

                      Divider(height: 30),

                      // Estes ficam em uma linha só
                      _buildFieldOneLine("Tamanho Mínimo", regra.tamanhoMin?.toStringAsFixed(3) ?? "NI"),
                      _buildFieldOneLine("Tamanho Máximo", regra.tamanhoMax?.toStringAsFixed(3) ?? "NI"),
                      _buildFieldOneLine("Anti quebra 1", regra.antiquebra1?.descricao ?? "NI"),
                      _buildFieldOneLine("Anti quebra 2", regra.antiquebra2?.descricao ?? "NI"),
                      _buildFieldOneLine("Anti quebra 3", regra.antiquebra3?.descricao ?? "NI"),
                      _buildFieldOneLine("Espessuramento", regra.espessuramento?.descricao ?? "NI"),
                      _buildFieldOneLine("Tempo", regra.tempo ?? "NI"),
                      _buildFieldOneLine("Marca", regra.modelo?.marca?.descricao ?? "NI"),
                      _buildFieldOneLine("Camelback", regra.camelback?.descricao ?? "NI"),
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
            flex: 6,
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
            flex: 6,
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

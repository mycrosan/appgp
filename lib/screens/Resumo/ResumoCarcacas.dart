import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:GPPremium/service/carcacaapi.dart';
import 'package:GPPremium/service/producaoapi.dart';
import 'package:GPPremium/service/qualidadeapi.dart';

class ResumoCarcacasPage extends StatefulWidget {
  @override
  _ResumoCarcacasPageState createState() => _ResumoCarcacasPageState();
}

class _ResumoCarcacasPageState extends State<ResumoCarcacasPage> {
  Timer _timer;
  String _horaAtual = '';

  Map<String, int> carcaca = {
    'mesRetrasado': 0,
    'mesPassado': 0,
    'mesAtual': 0,
    'anteontem': 0,
    'ontem': 0,
    'hoje': 0,
  };

  Map<String, int> producao = {
    'mesRetrasado': 0,
    'mesPassado': 0,
    'mesAtual': 0,
    'anteontem': 0,
    'ontem': 0,
    'hoje': 0,
  };

  Map<String, int> qualidade = {
    'mesRetrasado': 0,
    'mesPassado': 0,
    'mesAtual': 0,
    'anteontem': 0,
    'ontem': 0,
    'hoje': 0,
  };

  @override
  void initState() {
    super.initState();
    _atualizarHora();
    _carregarTodos();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _atualizarHora();
      _carregarTodos();
    });
  }

  void _atualizarHora() {
    final agora = DateTime.now();
    setState(() {
      _horaAtual = DateFormat.Hm().format(agora);
    });
  }

  Future<void> _carregarTodos() async {
    await Future.wait([
      _carregarResumoCarcaca(),
      _carregarResumoProducao(),
      _carregarResumoQualidade(),
    ]);
  }

  Future<void> _carregarResumoCarcaca() async {
    try {
      final resumo = await CarcacaApi().getResumo();
      setState(() {
        carcaca = {
          'mesRetrasado': resumo['mesRetrasado'] ?? 0,
          'mesPassado': resumo['mesPassado'] ?? 0,
          'mesAtual': resumo['mesAtual'] ?? 0,
          'anteontem': resumo['anteontem'] ?? 0,
          'ontem': resumo['ontem'] ?? 0,
          'hoje': resumo['hoje'] ?? 0,
        };
      });
    } catch (e) {
      print('Erro ao carregar resumo Carcaça: $e');
    }
  }

  Future<void> _carregarResumoProducao() async {
    try {
      final resumo = await ProducaoApi().getResumo();
      setState(() {
        producao = {
          'mesRetrasado': resumo['mesRetrasado'] ?? 0,
          'mesPassado': resumo['mesPassado'] ?? 0,
          'mesAtual': resumo['mesAtual'] ?? 0,
          'anteontem': resumo['anteontem'] ?? 0,
          'ontem': resumo['ontem'] ?? 0,
          'hoje': resumo['hoje'] ?? 0,
        };
      });
    } catch (e) {
      print('Erro ao carregar resumo Produção: $e');
    }
  }

  Future<void> _carregarResumoQualidade() async {
    try {
      final resumo = await QualidadeApi().getResumo();
      setState(() {
        qualidade = {
          'mesRetrasado': resumo['mesRetrasado'] ?? 0,
          'mesPassado': resumo['mesPassado'] ?? 0,
          'mesAtual': resumo['mesAtual'] ?? 0,
          'anteontem': resumo['anteontem'] ?? 0,
          'ontem': resumo['ontem'] ?? 0,
          'hoje': resumo['hoje'] ?? 0,
        };
      });
    } catch (e) {
      print('Erro ao carregar resumo Qualidade: $e');
    }
  }

  Widget buildAnimatedCard(String title, int value, Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value.toDouble()),
      duration: Duration(milliseconds: 800),
      builder: (context, val, _) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Container(
            width: 110,
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  val.toInt().toString(),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildResumo(String titulo, Map<String, int> valores) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 24),
        Text(titulo, style: TextStyle(color: Colors.white ,fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            buildAnimatedCard("Mês Retrasado", valores['mesRetrasado'], Colors.indigo),
            buildAnimatedCard("Mês Passado", valores['mesPassado'], Colors.teal),
            buildAnimatedCard("Mês Atual", valores['mesAtual'], Colors.orange),
            buildAnimatedCard("Anteontem", valores['anteontem'], Colors.indigo),
            buildAnimatedCard("Ontem", valores['ontem'], Colors.teal),
            buildAnimatedCard("Hoje", valores['hoje'], Colors.orange),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 8),
                      Center(child: Text(_horaAtual, style: TextStyle(color: Colors.white, fontSize: 18))),
                      Center(child: Text("Atualiza a cada minuto", style: TextStyle(color: Colors.red, fontSize: 12))),
                      buildResumo("Carcaça", carcaca),
                      buildResumo("Produção", producao),
                      buildResumo("Qualidade", qualidade),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_back, color: Colors.white),
                tooltip: "Voltar para o início",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

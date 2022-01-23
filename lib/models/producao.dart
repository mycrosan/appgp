import 'carcaca.dart';
import 'regra.dart';

class Producao {
  int id;
  Carcaca carcaca;
  double medidaPneuRaspado;
  String dados;
  Regra regra;

  Producao(
      {this.id, this.carcaca, this.medidaPneuRaspado, this.dados, this.regra});

  Producao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    carcaca = json['carcaca'] != null ? new Carcaca.fromJson(json['carcaca']) : null;
    medidaPneuRaspado = json['medida_pneu_raspado'];
    dados = json['dados'];
    regra = json['regra'] != null ? new Regra.fromJson(json['regra']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.carcaca != null) {
      data['carcaca'] = this.carcaca.toJson();
    }
    data['medida_pneu_raspado'] = this.medidaPneuRaspado;
    data['dados'] = this.dados;
    if (this.regra != null) {
      data['regra'] = this.regra.toJson();
    }
    return data;
  }
}
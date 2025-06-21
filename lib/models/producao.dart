import 'carcaca.dart';
import 'regra.dart';

class Producao {
  int id;
  Carcaca carcaca;
  double medidaPneuRaspado;
  String dados;
  Regra regra;
  String fotos;

  Producao(
      {this.id, this.carcaca, this.medidaPneuRaspado, this.dados, this.regra, this.fotos});

  Producao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    carcaca = json['carcaca'] != null ? new Carcaca.fromJson(json['carcaca']) : null;
    medidaPneuRaspado = json['medida_pneu_raspado'];
    dados = json['dados'];
    regra = json['regra'] != null ? new Regra.fromJson(json['regra']) : null;
    fotos = json["fotos"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['carcaca'] = this.carcaca.toJson();
      data['medida_pneu_raspado'] = this.medidaPneuRaspado;
    data['dados'] = this.dados;
    data['regra'] = this.regra.toJson();
      data['fotos'] = this.fotos;
    return data;
  }
}
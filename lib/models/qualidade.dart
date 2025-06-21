import 'package:GPPremium/models/producao.dart';

import 'observacao.dart';

class Qualidade {
  int id;
  Producao producao;
  String observacao;
  String fotos;
  TipoObservacao tipo_observacao;

  Qualidade(
      {this.id, this.producao, this.observacao, this.fotos, this.tipo_observacao});

  Qualidade.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    producao = json['producao'] != null ? new Producao.fromJson(json['producao']) : null;
    observacao = json['observacao'];
    fotos = json["fotos"];
    tipo_observacao = json['tipo_observacao'] != null ? new TipoObservacao.fromJson(json['tipo_observacao']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;

    if (this.producao != null) {
      data['producao'] = this.producao.toJson();
    }

    data['observacao'] = this.observacao;

    data['fotos'] = this.fotos;

    data['tipo_observacao'] = this.tipo_observacao.toJson();
  
    return data;
  }
}
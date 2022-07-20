import 'package:GPPremium/models/producao.dart';

import 'observacao.dart';

class Qualidade {
  int id;
  Producao producao;
  String observacao;
  String fotos;
  TipoObservacao tipoObservacao;

  Qualidade(
      {this.id, this.producao, this.observacao, this.fotos, this.tipoObservacao});

  Qualidade.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    producao = json['producao'] != null ? new Producao.fromJson(json['producao']) : null;
    observacao = json['observacao'];
    fotos = json["fotos"];
    tipoObservacao = json['tipoObservacao'] != null ? new TipoObservacao.fromJson(json['tipoObservacao']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;

    if (this.producao != null) {
      data['producao'] = this.producao.toJson();
    }

    data['observacao'] = this.observacao;

    data['fotos'] = this.fotos;

    if (this.tipoObservacao != null) {
      data['tipoObservacao'] = this.tipoObservacao.toJson();
    }

    return data;
  }
}
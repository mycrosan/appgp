import 'package:GPPremium/models/producao.dart';

import 'carcaca.dart';
import 'classificacao.dart';
import 'observacao.dart';
import 'regra.dart';

class Qualidade {
  int id;
  Producao producao;
  String observacao;
  TipoClassificacao tipoClassificacao;
  String fotos;
  TipoObservacao tipoObservacao;

  Qualidade(
      {this.id, this.producao, this.observacao, this.tipoClassificacao, this.fotos, this.tipoObservacao});

  Qualidade.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    producao = json['producao'] != null ? new Producao.fromJson(json['producao']) : null;
    observacao = json['observacao'];
    tipoClassificacao = json['dados'];
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

    if (this.tipoClassificacao != null) {
      data['tipoClassificacao'] = this.tipoClassificacao.toJson();
    }
    data['fotos'] = this.fotos;

    if (this.tipoObservacao != null) {
      data['tipoObservacao'] = this.tipoObservacao.toJson();
    }

    return data;
  }
}
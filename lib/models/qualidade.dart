import 'package:GPPremium/models/producao.dart';

import 'observacao.dart';

class Qualidade {
  int id;
  Producao producao;
  String observacao;
  String fotos;
  TipoObservacao tipo_observacao;

  Qualidade({
    required this.id,
    required this.producao,
    required this.observacao,
    required this.fotos,
    required this.tipo_observacao,
  });

  Qualidade.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        producao = json['producao'] != null 
            ? Producao.fromJson(json['producao']) 
            : Producao(id: 0, dados: '', fotos: ''),
        observacao = json['observacao'] ?? '',
        fotos = json["fotos"] ?? '',
        tipo_observacao = json['tipo_observacao'] != null 
            ? TipoObservacao.fromJson(json['tipo_observacao']) 
            : TipoObservacao(id: 0, descricao: '', tipoClassificacao: null);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['producao'] = this.producao.toJson();
    data['observacao'] = this.observacao;
    data['fotos'] = this.fotos;
    data['tipo_observacao'] = this.tipo_observacao.toJson();
  
    return data;
  }
}
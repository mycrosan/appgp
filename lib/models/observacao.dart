import 'classificacao.dart';

class TipoObservacao {
  int id;
  String descricao;
  TipoClassificacao tipoClassificacao;

  TipoObservacao({this.id, this.descricao, this.tipoClassificacao});

  bool operator ==(dynamic other) =>
      other != null && other is TipoObservacao && this.id == other.id && this.descricao == other.descricao;

  @override
  int get hashCode => super.hashCode;

  TipoObservacao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    tipoClassificacao = json['tipo_classificacao'] != null
        ? new TipoClassificacao.fromJson(json['tipo_classificacao'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    if (this.tipoClassificacao != null) {
      data['tipo_classificacao'] = this.tipoClassificacao.toJson();
    }
    return data;
  }
}

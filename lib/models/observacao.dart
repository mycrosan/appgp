import 'classificacao.dart';

class TipoObservacao {
  int id;
  String descricao;
  TipoClassificacao tipoClassificacao;

  TipoObservacao({this.id, this.descricao, this.tipoClassificacao});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TipoObservacao &&
              runtimeType == other.runtimeType &&
              descricao == other.descricao &&
              id == other.id &&
              tipoClassificacao == other.tipoClassificacao;

  @override
  int get hashCode => descricao.hashCode ^ id.hashCode ^ tipoClassificacao.hashCode;

  factory TipoObservacao.fromJson(Map<String, dynamic> json) => TipoObservacao(
    id: json["id"],
    descricao: json["descricao"],
    tipoClassificacao: TipoClassificacao.fromJson(json["tipo_classificacao"]),
  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "descricao": descricao,
    "tipo_classificacao": tipoClassificacao.toJson(),
  };
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['descricao'] = this.descricao;
  //   if (this.tipoClassificacao != null) {
  //     data['tipo_classificacao'] = this.tipoClassificacao.toJson();
  //   }
  //   return data;
  // }
}

class TipoClassificacao {
  TipoClassificacao({
    this.id,
    this.descricao,
  });

  int id;
  String descricao;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TipoClassificacao &&
              runtimeType == other.runtimeType &&
              descricao == other.descricao &&
              id == other.id;

  @override
  int get hashCode => descricao.hashCode ^ id.hashCode;

  factory TipoClassificacao.fromJson(Map<String, dynamic> json) => TipoClassificacao(
    id: json["id"],
    descricao: json["descricao"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "descricao": descricao,
  };
}
class TipoObservacao {
  TipoObservacao({
    this.id,
    this.descricao,
  });

  int id;
  String descricao;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TipoObservacao &&
              runtimeType == other.runtimeType &&
              descricao == other.descricao &&
              id == other.id;

  @override
  int get hashCode => descricao.hashCode ^ id.hashCode;

  factory TipoObservacao.fromJson(Map<String, dynamic> json) => TipoObservacao(
    id: json["id"],
    descricao: json["descricao"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "descricao": descricao,
  };
}
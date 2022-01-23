class Medida {
  Medida({
    this.id,
    this.descricao,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Medida &&
              runtimeType == other.runtimeType &&
              descricao == other.descricao &&
              id == other.id;

  @override
  int get hashCode => descricao.hashCode ^ id.hashCode;

  int id;
  String descricao;

  factory Medida.fromJson(Map<String, dynamic> json) => Medida(
    id: json["id"],
    descricao: json["descricao"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "descricao": descricao,
  };
}

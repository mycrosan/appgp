class Espessuramento {

  int id;
  String descricao;

  Espessuramento({
    this.id,
    this.descricao,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Espessuramento &&
              runtimeType == other.runtimeType &&
              descricao == other.descricao &&
              id == other.id;

  @override
  int get hashCode => descricao.hashCode ^ id.hashCode;

  factory Espessuramento.fromJson(Map<String, dynamic> json) => Espessuramento(
    id: json["id"],
    descricao: json["descricao"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "descricao": descricao,
  };
}
class Pais {
  Pais({
    required this.id,
    required this.descricao,
  });

  int id;
  String descricao;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Pais &&
              runtimeType == other.runtimeType &&
              descricao == other.descricao &&
              id == other.id;

  @override
  int get hashCode => descricao.hashCode ^ id.hashCode;

  factory Pais.fromJson(Map<String, dynamic> json) => Pais(
    id: json["id"],
    descricao: json["descricao"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "descricao": descricao,
  };
}
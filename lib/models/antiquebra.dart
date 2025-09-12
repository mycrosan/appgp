class Antiquebra {

  int id;
  String descricao;

  Antiquebra({
    required this.id,
    required this.descricao,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Antiquebra &&
              runtimeType == other.runtimeType &&
              descricao == other.descricao &&
              id == other.id;

  @override
  int get hashCode => descricao.hashCode ^ id.hashCode;

  factory Antiquebra.fromJson(Map<String, dynamic> json) => Antiquebra(
    id: json["id"],
    descricao: json["descricao"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "descricao": descricao,
  };
}
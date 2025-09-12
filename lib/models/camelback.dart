class Camelback {

  int id;
  String descricao;

  Camelback({
    required this.id,
    required this.descricao,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Camelback &&
              runtimeType == other.runtimeType &&
              descricao == other.descricao &&
              id == other.id;

  @override
  int get hashCode => descricao.hashCode ^ id.hashCode;

  factory Camelback.fromJson(Map<String, dynamic> json) => Camelback(
    id: json["id"],
    descricao: json["descricao"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "descricao": descricao,
  };
}
class Matriz {
  int id;
  String descricao;

  Matriz({required this.id, required this.descricao});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Matriz &&
              runtimeType == other.runtimeType &&
              descricao == other.descricao &&
              id == other.id;

  @override
  int get hashCode => descricao.hashCode ^ id.hashCode;

  Matriz.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        descricao = json['descricao'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricao'] = descricao;
    return data;
  }
}
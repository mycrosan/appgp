class Usuario {
  int id;
  String nome;
  String login;
  String senha;
  List<Perfil> perfil;
  bool status;

  Usuario({
    required this.id,
    required this.nome,
    required this.login,
    required this.senha,
    required this.perfil,
    required this.status,
  });

  Usuario.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        nome = json['nome'] ?? '',
        login = json['login'] ?? '',
        senha = json['senha'] ?? '',
        status = json['status'] ?? false,
        perfil = json['perfil'] != null
            ? (json['perfil'] as List).map((v) => Perfil.fromJson(v)).toList()
            : <Perfil>[];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['login'] = this.login;
    data['senha'] = this.senha;
    data['status'] = this.status;
    data['perfil'] = (this.perfil ?? []).map((v) => v.toJson()).toList();
    return data;
  }
}

class Perfil {
  int id;
  String descricao;
  String authority;

  Perfil({required this.id, required this.descricao, required this.authority});

  Perfil.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        descricao = json['descricao'] ?? '',
        authority = json['authority'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['authority'] = this.authority;
    return data;
  }
}
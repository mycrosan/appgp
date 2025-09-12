class AuthDTO {
  String mensagem;
  bool status;
  String token;

  AuthDTO({
    required this.mensagem,
    required this.status,
    required this.token,
  });

  AuthDTO.fromJson(Map<String, dynamic> json)
      : mensagem = json['mensagem'] ?? '',
        status = json['status'] ?? false,
        token = json['token'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mensagem'] = mensagem;
    data['status'] = status;
    data['token'] = token;
    return data;
  }
}
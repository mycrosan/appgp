class responseMessageSimple {
  String message;
  List<dynamic> content;

  responseMessageSimple({
    required this.message,
    required this.content,
  });

  responseMessageSimple.fromJson(Map<String, dynamic> json)
      : message = json['message'] ?? '',
        content = json['content'] ?? [];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['content'] = this.content;
    return data;
  }
}

class Borracha {
  Borracha({
    this.id,
    this.camelback,
    this.antiQuebra,
    this.espessuramento,
  });

  int id;
  String camelback;
  String antiQuebra;
  String espessuramento;

  factory Borracha.fromJson(Map<String, dynamic> json) => Borracha(
    id: json["id"],
    camelback: json["camelback"],
    antiQuebra: json["anti_quebra"],
    espessuramento: json["espessuramento"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "camelback": camelback,
    "anti_quebra": antiQuebra,
    "espessuramento": espessuramento,
  };
}

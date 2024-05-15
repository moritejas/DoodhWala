import 'dart:convert';

List<DudhWala> dudhWalaFromJson(String str) =>
    List<DudhWala>.from(json.decode(str).map((x) => DudhWala.fromJson(x)));

String dudhWalaJson(List<DudhWala> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DudhWala {
  String username;
  String idno;
  dynamic phoneno;
  DudhWala({
    required this.username,
    required this.idno,
    this.phoneno,
  });

  factory DudhWala.fromJson(Map<String, dynamic> json) => DudhWala(
        username: json["User-Name"],
        idno: json["Id-No."],
        phoneno: json["Phone-No."],
      );
  Map<String, dynamic> toJson() => {
        // "Code": code,
        "User-Name": username,
        "Id-No.": idno,
        "Phone-No.": phoneno,
      };
}

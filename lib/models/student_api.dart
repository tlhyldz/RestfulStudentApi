// To parse this JSON data, do
//
//     final student = studentFromJson(jsonString);

import 'dart:convert';

List<Student> studentFromJson(String str) => List<Student>.from(json.decode(str).map((x) => Student.fromJson(x)));

String studentToJson(List<Student> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Student {
    Student({
        required this.bolum,
        required this.id,
        required this.isim,
        required this.numara,
    });

    String bolum;
    int id;
    String isim;
    String numara;

    factory Student.fromJson(Map<String, dynamic> json) => Student(
        bolum: json["bolum"],
        id: json["id"],
        isim: json["isim"],
        numara: json["numara"],
    );

    Map<String, dynamic> toJson() => {
        "bolum": bolum,
        "id": id,
        "isim": isim,
        "numara": numara,
    };
}

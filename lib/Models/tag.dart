import 'dart:convert';

List<Tag> tagFromJson(String str) => List<Tag>.from(json.decode(str).map((x) => Tag.fromJson(x)));

String tagToJson(List<Tag> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tag {
    int id;
    String tagName;
    String tagColor;

    Tag({
        required this.id,
        required this.tagName,
        required this.tagColor,
    });

    factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        tagName: json["tagName"],
        tagColor: json["tagColor"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tagName": tagName,
        "tagColor": tagColor,
    };
}
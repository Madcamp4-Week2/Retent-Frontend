import 'dart:convert';

import 'package:test_project/Models/tag.dart';

List<Deck> deckFromJson(String str) => List<Deck>.from(json.decode(str).map((x) => Deck.fromJson(x)));

String deckToJson(List<Deck> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Deck {
    int id;
    String deckName;
    int user;
    bool deckFavorite;
    String? description;
    bool isShared;
    List<Tag> tagList;

    Deck({
      required this.id,
      required this.deckName,
      required this.user,
      this.deckFavorite = false,
      this.description = "",
      this.isShared = false,
      List<Tag>? tagList,
    }) : tagList = tagList ?? [];

    factory Deck.fromJson(Map<String, dynamic> json) => Deck(
      id: json["id"],
      deckName: json["deckName"],
      user: json["user"],
      deckFavorite: json["deckFavorite"],
    );

    Map<String, dynamic> toJson() => {
      "id": id,
      "deckName": deckName,
      "user": user,
      "deckFavorite": deckFavorite,
    };
}

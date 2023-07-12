import 'dart:convert';

List<History> historyFromJson(String str) => List<History>.from(json.decode(str).map((x) => History.fromJson(x)));

String historyToJson(List<History> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class History {
  DateTime dateTime;
  double answerTime;
  double accuracy;
  int deckId;

  History({
    required this.dateTime,
    required this.answerTime,
    required this.accuracy,
    required this.deckId,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
    dateTime: json["createAt"],
    answerTime: json["deckAnswerTime"],
    accuracy: json["accuracy"],
    deckId: json["deck"],
  );

  Map<String, dynamic> toJson() => {
    "createAt" : dateTime,
    "deckAnswerTime": answerTime,
    "accuracy": accuracy,
    "deck": deckId,
  };
}
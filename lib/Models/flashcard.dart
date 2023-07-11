import 'dart:convert';

List<Flashcard> flashcardFromJson(String str) => List<Flashcard>.from(json.decode(str).map((x) => Flashcard.fromJson(x)));

String flashcardToJson(List<Flashcard> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Flashcard {
    int id;
    bool answerCorrect;
    String question;
    String answer;
    int? interval;
    int deck;
    int? answerTime;
    bool cardFavorite;

    Flashcard({
        required this.id,
        this.answerCorrect = false,
        required this.question,
        required this.answer,
        this.interval,
        required this.deck,
        this.answerTime,
        this.cardFavorite = false,
    });

    factory Flashcard.fromJson(Map<String, dynamic> json) => Flashcard(
        id: json["id"],
        answerCorrect: json["answerCorrect"],
        question: json["question"],
        answer: json["answer"],
        interval: json["interval"],
        deck: json["deck"],
        answerTime: json["answerTime"],
        cardFavorite: json["cardFavorite"],
    );

    Map<String, dynamic> toJson() => {
        //"id": id,
        "answerCorrect": answerCorrect,
        "question": question,
        "answer": answer,
        "interval": interval,
        "deck": deck,
        "answerTime": answerTime,
        "cardFavorite": cardFavorite,
    };
}

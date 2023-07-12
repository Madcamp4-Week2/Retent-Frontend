import 'package:flutter/material.dart';
import 'package:test_project/Models/deck.dart';
import 'package:test_project/Models/flashcard.dart';
import 'package:test_project/Services/base_client.dart';

// CARD

Future<List<Flashcard>> getMyCardsDB(int deckId) async {
  var responseBody = await BaseClient().get('/flash-card/cards/deck_cards/$deckId');
  print("getmyCards response is $responseBody");
  if (responseBody == null) {
    debugPrint("getMyCards unsuccessfull");
    return List.empty();
  }
  return flashcardFromJson(responseBody);
}

Future<Flashcard?> postCardDB(int deckId, String question, String answer) async {
  var responseBody = await BaseClient().post(
    '/flash-card/cards/',
    {"question" : question, "answer" : answer, "deck" : deckId}
  );
  if (responseBody == null) {
    debugPrint("getMyCards unsuccessfull");
    return null;
  }
  return Flashcard.fromJson(responseBody);
}

void deleteCardDB(int cardId) async {
  var responseBody = await BaseClient().delete('/flash-card/cards/$cardId');
  if (responseBody == null) {
    debugPrint("deleteCard unsuccessfull");
  }
  return;
}

Future<Flashcard?> patchCardDB(int deckId, String question, String answer) async {
  var responseBody = await BaseClient().patch(
    '/flash-card/cards/$deckId/',
    {"question" : question, "answer" : answer, "deck" : deckId}
  );
  if (responseBody == null) {
    debugPrint("getMyCards unsuccessfull");
    return null;
  }
  return Flashcard.fromJson(responseBody);
}





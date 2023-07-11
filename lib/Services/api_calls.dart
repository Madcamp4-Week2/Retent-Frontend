import 'package:flutter/material.dart';
import 'package:test_project/Models/deck.dart';
import 'package:test_project/Models/flashcard.dart';
import 'package:test_project/Models/tag.dart';
import 'package:test_project/Services/base_client.dart';

//DECK
Future<Deck?> getDeck(int deckId) async { //????
  var response = await BaseClient().get('/flash-card/decks/{$deckId}/');
  if (response == null) {
    debugPrint("getMyDecks unsuccessful");
    return null;
  }
  return deckFromJson(response.body)[0];
}

Future<Deck?> postDeck(String deckName, int userId) async {
  var responseBody = await BaseClient().put(
    '/flash-card/decks/',
    {"deckName" : deckName, "user" : userId, "deckFavorite" : false}
  );
  if (responseBody == null) {
    debugPrint("postDeck unsuccessful");
    return null;
  }
  return deckFromJson([responseBody] as String)[0];
}

//Card
Future<List<Flashcard>> getMyCardsDB(int deckId) async {
    var responseBody = await BaseClient().get('/flash-card/cards/deck_cards/$deckId/');
    if (responseBody == null) {
      debugPrint("getMyCards unsuccessfull");
      return List.empty();
    }
    return flashcardFromJson(responseBody);
  }

//TAGS
Future<List<Tag>> getMyTagsDB(int userId) async { //fix. MY tags
  var response = await BaseClient().get('/flash-card/tags');
  if (response == null) {
    debugPrint("getMyDecks unsuccessful");
    return List.empty();
  }
  return tagFromJson(response.body);
}
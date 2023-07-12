import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_project/Models/deck.dart';
import 'package:test_project/Models/flashcard.dart';
import 'package:test_project/Models/tag.dart';
import 'package:test_project/Services/base_client.dart';

//DECK

Future<List<Deck>> getMyDecksDB(int userId) async {
  var responseBody = await BaseClient().get('/flash-card/decks/user_decks/$userId');
  print("getmyDecks response is $responseBody");
  if (responseBody == null) {
    debugPrint("getMyDecks unsuccessful");
    return List.empty();
  }
  return deckFromJson(responseBody);
}

Future<Deck?> getDeckDB(int deckId) async {
  var responseBody = await BaseClient().get('/flash-card/decks/$deckId');
  if (responseBody == null) {
    debugPrint("getMyDecks unsuccessful");
    return null;
  }
  return Deck.fromJson(responseBody);
}

// Future<Deck?> postDeckDB(String deckName, int userId) async {
//   var responseBody = await BaseClient().post(
//     '/flash-card/decks/',
//     {"deckName" : deckName, "user" : userId}
//   );
//   if (responseBody == null) {
//     debugPrint("postDeck unsuccessful");
//     return null;
//   }
//   return Deck.fromJson(responseBody); // DeckId를 반환
// }

Future<Deck?> postDeckDB(String deckName, int userId) async {
  print(json.encode({"deckName" : deckName, "user" : userId}));
  var responseBody = await BaseClient().post(
    '/flash-card/decks/',
    {"deckName" : deckName, "user" : userId}, // Here, convert the map to a JSON string
  );
  if (responseBody == null) {
    debugPrint("postDeck unsuccessful");
    return null;
  }
  return Deck.fromJson(responseBody);
}

// 이름 바꾸기만 필요
Future<Deck?> patchDeckDB(int deckId, String deckName) async {
  var responseBody = await BaseClient().put(
    '/flash-card/decks/$deckId',
    {"deckName" : deckName, "deckFavorite" : false}
  );
  if (responseBody == null) {
    debugPrint("patchDeck unsuccessful");
    return null;
  }
  return Deck.fromJson(responseBody); // DeckId를 반환
}

void deleteDeckDB(int deckId) async {
  var responseBody = await BaseClient().delete('/flash-card/decks/$deckId');
  if (responseBody == null) {
    debugPrint("deleteDeck unsuccessfull");
  }
  return;
}

void bookmarkDeckDB(int deckId) async {
  var responseBody = await BaseClient().patch('/flash-card/decks/$deckId', {"deckFavorite" : true});
  if (responseBody == null) {
    debugPrint("bookmarkDeck unsuccessfull");
  }
  return;
}

void unbookmarkDeckDB(int deckId) async {
  var responseBody = await BaseClient().patch('/flash-card/decks/$deckId', {"deckFavorite" : false});
  if (responseBody == null) {
    debugPrint("unbookmarkDeck unsuccessfull");
  }
  return;
}


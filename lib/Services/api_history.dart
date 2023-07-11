import 'package:flutter/material.dart';
import 'package:test_project/Models/deck.dart';
import 'package:test_project/Models/flashcard.dart';
import 'package:test_project/Models/history.dart';
import 'package:test_project/Models/tag.dart';
import 'package:test_project/Services/base_client.dart';

void postHistoryDB(int deckId, double totalTime, double accuracy) async {
  var responseBody = await BaseClient().post(
    '/flash-card/deck-history/',
    {"deck" : deckId, "accurcacy" : accuracy, "deckAnswerTime" : totalTime}
  );
  if (responseBody == null) {
    debugPrint("postDeck unsuccessful");
  }
  return; // DeckId를 반환
}


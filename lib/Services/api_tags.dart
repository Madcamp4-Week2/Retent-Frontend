import 'package:flutter/material.dart';
import 'package:test_project/Models/deck.dart';
import 'package:test_project/Models/flashcard.dart';
import 'package:test_project/Models/tag.dart';
import 'package:test_project/Services/base_client.dart';

//TAGS
Future<List<Tag>> getTagsDB(int userId) async {
  var response = await BaseClient().get('/flash-card/tags');
  if (response == null) {
    debugPrint("getMyDecks unsuccessful");
    return List.empty();
  }
  return tagFromJson(response.body);
}
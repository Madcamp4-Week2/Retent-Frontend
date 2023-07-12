import 'dart:convert';

import 'package:test_project/Models/deck.dart';
import 'package:test_project/Models/flashcard.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'https://70d5-143-248-38-159.ngrok-free.app/retent';

class BaseClient {
  var client = http.Client();

  Future<dynamic> get(String api, {Map<String, String>? headers}) async {
    var uri = Uri.parse(baseUrl + api);

    var response = await client.get(uri, headers: headers);
    if (response.statusCode <= 300 && response.statusCode >= 200) {
      return response.body;
    } else {
      // Consider throwing an error if the status code is not 2xx
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> post(String api, dynamic object) async {
    var uri = Uri.parse(baseUrl + api); //fill uri
    var _payload = json.encode(object);

    var response = await client.post(uri,
        body: _payload, headers: {"Content-Type": "application/json"});
    if (response.statusCode <= 300 && response.statusCode >= 200) {
      return response.body;
    } else {}
  }

  Future<dynamic> put(String api, dynamic object) async {
    var uri = Uri.parse(baseUrl + api); //fill uri
    var _payload = json.encode(object);

    var response = await client.put(uri, body: _payload);
    if (response.statusCode <= 300 && response.statusCode >= 200) {
      return response.body;
    } else {}
  }

  Future<dynamic> patch(String api, dynamic object) async {
    var uri = Uri.parse(baseUrl + api); //fill uri
    var _payload = json.encode(object);

    var response = await client.patch(uri, body: _payload);
    if (response.statusCode == 200) {
      return response.body;
    } else {}
  }

  Future<dynamic> delete(String api) async {
    var uri = Uri.parse(baseUrl + api); //fill uri

    var response = await client.delete(uri);
    if (response.statusCode <= 300 && response.statusCode >= 200) {
      return response.body;
    } else {}
  }
}

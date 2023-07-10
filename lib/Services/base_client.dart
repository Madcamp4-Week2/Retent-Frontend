import 'dart:convert';

import 'package:test_project/Models/deck.dart';
import 'package:test_project/Models/flashcard.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://6a36-143-248-200-33.ngrok-free.app/retent/';

class BaseClient {
  var client = http.Client();

  Future<dynamic> get(String api) async { // TODO headers????
    var uri = Uri.parse(baseUrl + api); //fill uri

    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {

    }
  } 

  Future<dynamic> post(String api, dynamic object) async {
    var uri = Uri.parse(baseUrl + api); //fill uri
    var _payload = json.encode(object);

    var response = await client.post(uri, body: _payload);
    if (response.statusCode == 201) {
      return response.body;
    } else {
      
    }
  }

  Future<dynamic> put(String api, dynamic object) async {
    var uri = Uri.parse(baseUrl + api); //fill uri
    var _payload = json.encode(object);

    var response = await client.put(uri, body: _payload);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      
    }
  }

  Future<dynamic> delete(String api) async {
    var uri = Uri.parse(baseUrl + api); //fill uri

    var response = await client.delete(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      
    }
  }


}
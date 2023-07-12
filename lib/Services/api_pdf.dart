import 'package:flutter/material.dart';
import 'package:test_project/Models/deck.dart';
import 'package:test_project/Models/flashcard.dart';
import 'package:test_project/Services/base_client.dart';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'dart:io';

Future<List<Flashcard>> getCardsDB(int deckId) async {
  var responseBody = await BaseClient().get('/flash-card/cards/deck_cards/$deckId');
  print("getmyCards response is $responseBody");
  if (responseBody == null) {
    debugPrint("getMyCards unsuccessfull");
    return List.empty();
  }
  return flashcardFromJson(responseBody);
}




void generatePDFcards(BuildContext context, int deckId) async {
  Future<FilePickerResult?> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    return result;
  }

  Future<void> uploadPDF(File selectedFile) async {
    if (selectedFile == null) return;

    String fileName = p.basename(selectedFile!.path);
    String url = '$baseUrl/flash-card/uploading-pdf/'; // Replace with your server's URL + retent

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['deckId'] = deckId.toString();

    request.files.add(
      await http.MultipartFile.fromPath('file', selectedFile!.path, filename: fileName),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      // File uploaded successfully
      print('File uploaded');
    } else {
      // Error occurred while uploading the file
      print('Error uploading file');
    }
  }

  var result = await pickPDF();

  if (result != null) {
    var selectedFile = File(result.files.single.path!);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selected PDF'),
          content: Text(p.basename(selectedFile!.path)),
          actions: <Widget>[
            TextButton(
              child: Text('Upload'),
              onPressed: () {
                Navigator.of(context).pop();
                uploadPDF(selectedFile);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
} 

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:test_project/Models/deck.dart';
import 'package:test_project/Services/api_card.dart';
import 'package:test_project/Services/api_deck.dart';
import 'package:test_project/Services/api_pdf.dart';
import 'package:test_project/Services/base_client.dart';
import 'package:test_project/Views/Add/add_card_screen.dart';
import 'package:test_project/Views/Home/DecksScreen/edit_card_screen.dart';

import 'package:test_project/Models/flashcard.dart';
import 'package:test_project/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class AddDeckScreen extends StatefulWidget {
  const AddDeckScreen({super.key});

  @override
  State<AddDeckScreen> createState() => _AddDeckScreenState();
}

class _AddDeckScreenState extends State<AddDeckScreen>
    with SingleTickerProviderStateMixin {
  List<Flashcard> currentCardList = [];
  late int userId;

  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  Deck newDeck = Deck(id: 0, deckName: "임시", user: 0); // Temp value
  bool isDeckInitialized = false;

  final TextEditingController textEditingController = TextEditingController();

  void initNewDeck(int userId) async {
    final deck = await postDeckDB("name", userId);
    setState(() {
      if (deck != null) {
        newDeck = deck;
        isDeckInitialized = true; // Mark the newDeck as initialized
      }
    });
  }

  @override
  void initState() {
    super.initState();

    final loginState = Provider.of<LoginState>(context, listen: false);
    setState(() {
      userId = LoginState().userId; // TODO
    });
    initNewDeck(userId);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    File? selectedFile;

    void saveNewDeck() {
      patchDeckDB(newDeck.id, textEditingController.text);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("새로운 덱"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("저장사항 삭제")));
              deleteDeckDB(newDeck.id); //새로 만든 덱 삭제
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                saveNewDeck();
                Navigator.pop(context);
              },
            ),
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return const [
                  PopupMenuItem(
                    value: 'Option 1',
                    child: Text('Option 1'),
                  ),
                  PopupMenuItem(
                    value: 'Option 2',
                    child: Text('Option 2'),
                  ),
                  PopupMenuItem(
                    value: 'Option 3',
                    child: Text('Option 3'),
                  ),
                ];
              },
              onSelected: (value) {
                // Handle selected option
                // You can customize this action as per your requirements
              },
            ),
          ],
        ),
        body: (isDeckInitialized)
            ? Center(child: CircularProgressIndicator())
            : Container(
                //padding: const EdgeInsets.only(top: 20, left: 20, right: 0), //slidables을 위한 공간을 위해 0으로
                child: Column(children: [
                  Container(
                    height: 100,
                    padding: const EdgeInsets.all(16.0),
                    child: Row(children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: textEditingController,
                            style: const TextStyle(
                                color: Colors.black, // Text color
                                fontSize: 16.0, // Text size
                                fontFamily: 'Pretendard', // Custom font family
                                fontWeight: FontWeight.bold),
                            decoration:
                                const InputDecoration(hintText: '덱의 이름을 입력하세요'),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            const snackBar =
                                SnackBar(content: Text("배열 기준 변경"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          icon: const Icon(Icons.sort))
                    ]),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: currentCardList.length,
                        itemBuilder: flashcardItemBuilder),
                  )
                ]),
              ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          if (_isExpanded)
            buildCircularButton(Icons.picture_as_pdf, () {
              generatePDFcards(context, newDeck.id);
            }),
          if (_isExpanded) const SizedBox(height: 16.0),
          if (_isExpanded)
            buildCircularButton(Icons.add_box, () {
              moveToAddCardScreen(context);
            }),
          if (_isExpanded) const SizedBox(height: 16.0),
          FloatingActionButton(
            child: Icon(_isExpanded ? Icons.close : Icons.add),
            onPressed: _toggleExpanded,
          ),
        ]));
  }

  Widget buildCircularButton(IconData icon, VoidCallback onPressed) {
    return ScaleTransition(
      scale: _animation,
      child: FloatingActionButton(
        child: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }

  Widget flashcardItemBuilder(BuildContext context, int index) {
    final Flashcard flashcard = currentCardList[index];

    void editCard(BuildContext context, Flashcard card) async {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("editing card")));
      moveToEditCardScreen(context, card);
    }

    void deleteCard() async {
      // TODO 삭제 취소하기 버튼

      final snackBar = SnackBar(content: Text("deleted card $index"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      setState(() {
        currentCardList.removeAt(index);
      });

      deleteCardDB(flashcard.id);
    }

    return Slidable(
        key: Key(flashcard.id.toString()),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            Builder(//share button
                builder: (cont) {
              return ElevatedButton(
                onPressed: () {
                  Slidable.of(cont)!.close();
                  editCard(context, flashcard);
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(10),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.black,
                  size: 25,
                ),
              );
            }),
            Builder(//delete button
                builder: (cont) {
              return ElevatedButton(
                onPressed: () {
                  Slidable.of(cont)!.close();
                  deleteCard();
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(10),
                ),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 25,
                ),
              );
            }),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            editCard(context, flashcard);
          },
          child: Center(
            child: Container(
                margin: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 20, right: 20),
                child: Card(
                  elevation: 4.0,
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(flashcard.question,
                            style: const TextStyle(
                                color: Colors.white, // Text color
                                fontSize: 16.0, // Text size
                                fontFamily: 'Pretendard', // Custom font family
                                fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            color: Colors.grey[700],
                            thickness: 1.0,
                            height: 20,
                          ),
                        ),
                        Text(flashcard.answer,
                            style: const TextStyle(
                                color: Colors.white, // Text color
                                fontSize: 16.0, // Text size
                                fontFamily: 'Pretendard', // Custom font family
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )),
          ),
        ));
  }

  void moveToAddCardScreen(BuildContext context) async {
    print("move to add card");

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddCardScreen(
                newDeck: newDeck,
              )),
    );
  }

  void moveToEditCardScreen(BuildContext context, Flashcard card) {
    print("move to edit card");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditCardScreen(flashcard: card)),
    );
  }
}

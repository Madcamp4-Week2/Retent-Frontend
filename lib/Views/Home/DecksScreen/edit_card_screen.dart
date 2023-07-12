import 'package:flutter/material.dart';
import 'package:provider/provider.darts';
import 'package:test_project/Models/deck.dart';
import 'package:test_project/Models/tag.dart';
import 'package:test_project/Services/api_card.dart';
import 'package:test_project/Services/api_deck.dart';
import 'package:test_project/Services/api_tags.dart';
import 'package:test_project/Services/base_client.dart';
import 'package:test_project/Views/Home/DecksScreen/deck_screen.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:test_project/Models/flashcard.dart';
import 'package:test_project/auth_provider.dart';

class EditCardScreen extends StatefulWidget {
  final Flashcard flashcard;

  const EditCardScreen({super.key, required this.flashcard});

  @override
  State<EditCardScreen> createState() => _EditCardScreenState();
}

class _EditCardScreenState extends State<EditCardScreen> {
  late int userId;
  bool isBookmarked = false;
  int? selectedDeck;

//   Future<List<Deck>> getMyDecksDB(int userId) async {
//   var response = await BaseClient().get('/flash-card/decks/{$userId}/');
//   if (response == null) {
//     debugPrint("getMyDecks unsuccessful");
//     return List.empty();
//   }
//   return deckFromJson(response.body);
// }

  late List<Deck> myDeckList = [];

  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController questionEditingController =
      TextEditingController();
  final TextEditingController answerEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    questionEditingController.dispose();
    answerEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final loginState = Provider.of<LoginState>(context, listen: false);
    setState(() {
      selectedDeck = widget.flashcard.deck;
      userId = loginState.userId;
      //getMyDecks(userId);
      myDeckList = loginState.myDeckList;
    });
  }

  void getMyDecks(userId) async {
    myDeckList = await getMyDecksDB(userId);
  }

  @override
  Widget build(BuildContext context) {
    questionEditingController.text = widget.flashcard.question;
    answerEditingController.text = widget.flashcard.answer;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              saveEditedCard(); // 지금 변경사항을 저장
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("변경사항을 저장했습니다")));
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // display more options
            },
          ),
        ],
        title: const Text('카드 수정하기'),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 20),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  hint: const Text('덱을 고르세요  '),
                  value: selectedDeck,
                  items: myDeckList
                      .map((Deck item) => DropdownMenuItem(
                          value: item.id, child: Text(item.deckName)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDeck = value as int?;
                      print(
                          "----------selected value is $selectedDeck---------");
                    });
                  },
                  iconStyleData:
                      const IconStyleData(icon: Icon(Icons.expand_circle_down)),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 400,
                    width: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    offset: const Offset(-20, 0),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all(6),
                      thumbVisibility: MaterialStateProperty.all(true),
                    ),
                  ),
                  dropdownSearchData: DropdownSearchData(
                    searchController: textEditingController,
                    searchInnerWidgetHeight: 50,
                    searchInnerWidget: Container(
                      height: 50,
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 4,
                        right: 8,
                        left: 8,
                      ),
                      child: TextFormField(
                        expands: true,
                        maxLines: null,
                        controller: textEditingController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          //hintText: '무슨 덱으로 바꿀까요',
                          hintStyle: const TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      return item.value.toString().contains(searchValue);
                    },
                  ),
                  //This to clear the search value when you close the menu
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      textEditingController.clear();
                    }
                  },
                ),
              ),
            ),
            Expanded(
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
                      TextFormField(
                        controller: questionEditingController,
                        //initialValue: widget.flashcard.question,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter question',
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                        maxLines: null,
                        onChanged: (value) {
                          // Handle text changes
                          // You can update the flashcard question using setState or any other mechanism
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: answerEditingController,
                        //initialValue: widget.flashcard.answer,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter answer',
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                        maxLines: null,
                        onChanged: (value) {
                          // Handle text changes
                          // You can update the flashcard answer using setState or any other mechanism
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveEditedCard() async {
    final newQuestion = questionEditingController.text;
    final newAnswer = answerEditingController.text;
    final newDeck = selectedDeck;
    // TODO db로 현재 상태를 보냄 - patch

    if (newDeck == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("덱 안고름")));
    } else {
      patchCardDB(newDeck, newQuestion, newAnswer);
    }
  }
}

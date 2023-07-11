import 'package:flutter/material.dart';
import 'package:test_project/Models/deck.dart';
import 'package:test_project/Models/tag.dart';
import 'package:test_project/Services/api_calls.dart';
import 'package:test_project/Views/Home/deck_screen.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:test_project/Models/flashcard.dart';

class AddCardScreen extends StatefulWidget {
  final Deck? parentDeck;

  const AddCardScreen({super.key, required this.parentDeck});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  int? selectedDeckId;

  List<Tag> myTagList = [];
  List<Deck> myDeckList = []; // TODO db써서 가져오기

  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController questionEditingController = TextEditingController();
  final TextEditingController answerEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    questionEditingController.dispose();
    answerEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myDeckList = [
      Deck(id: 1, deckName: "Deck 1", user: 1, deckFavorite: true),
      Deck(id: 2, deckName: "Deck 2", user: 2, deckFavorite: false),
      Deck(id: 3, deckName: "Deck 3", user: 1, deckFavorite: true),
    ];

    return Scaffold(
      appBar: AppBar(
         actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              saveCreatedCard(); // 지금 변경사항을 저장
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // display more options
            },
          ),
        ],
        title: const Text('카드 만들기'),
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
                  value: selectedDeckId,
                  items: myDeckList.map((Deck item) => DropdownMenuItem(
                    value: item.id,
                    child: Text(item.deckName))
                    ).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDeckId = value as int?;
                    });
                    final snackBar = SnackBar(
                      content: Text("덱을 $selectedDeckId로 바꿨습니다")
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar); 
                  },
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.expand_circle_down)
                  ),
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
                      padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8,),
                      child: TextFormField(
                        expands: true,
                        maxLines: null,
                        controller: textEditingController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8,),
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
                  margin:const EdgeInsets.all(20),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: questionEditingController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: '질문을 입력하세요',
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                        maxLines: null,
                        onChanged: (value) {
                          // Handle text changes
                          // You can update the flashcard question using setState or any other mechanism
                        },
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        controller: answerEditingController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: '답을 입력하세요',
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

  void saveCreatedCard() async {
    final newQuestion = questionEditingController.text;
    final newAnswer = answerEditingController.text;
    
    // TODO db로 현재 상태를 보냄 - patch
    if(selectedDeckId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("덱 안고름")
      )); 
    } else {
      //saveEditedCardDB(newQuestion, newAnswer, newDeck);
      final newCard = Flashcard(
        id: 10, // TODO FIX!!!!!!
        question: newQuestion, 
        answer: newAnswer,
        deck: selectedDeckId!,
      );

      Navigator.pop(context, newCard);
    }
  }
}
import 'package:flutter/material.dart';
import 'package:test_project/Home/deck_screen.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:test_project/flashcard.dart';

class EditCardScreen extends StatefulWidget {
  final Flashcard flashcard;
  
  EditCardScreen({required this.flashcard});

  @override
  State<EditCardScreen> createState() => _EditCardScreenState();
}

class _EditCardScreenState extends State<EditCardScreen> {
  
  bool isBookmarked = false;
  String? selectedDeck;

  List<String> deckList = [
    '물리', '화학', '생물', '철학'
  ]; // TODO db써서 가져오기

  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         actions: [
          IconButton(
            onPressed: () {
              // Handle the okay button press
              setState(() {
                isBookmarked = !isBookmarked;
              });
            },
            icon: Icon(isBookmarked? Icons.bookmark: Icons.bookmark_border),
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              saveEditedCard(); // 지금 변경사항을 저장
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // display more options
            },
          ),
        ],
        title: Text('현재 덱 이름'), //CHANGE
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
                  items: deckList.map((String item) => DropdownMenuItem(
                    value: item,
                    child: Text(item))
                    ).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDeck = value as String?;
                    });
                    final snackBar = SnackBar(
                      content: Text("덱을 $selectedDeck로 바꿨습니다")
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
                        initialValue: widget.flashcard.question,
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
                      const SizedBox(height: 20,),
                      TextFormField(
                        initialValue: widget.flashcard.answer,
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
    // TODO db로 현재 상태를 보냄
  }
}
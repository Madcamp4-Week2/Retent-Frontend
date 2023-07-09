import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:test_project/Home/edit_card_screen.dart';

import 'package:test_project/flashcard.dart';


class DeckScreen extends StatefulWidget {
  final int deckIndex;
  
  const DeckScreen({super.key, required this.deckIndex});

  @override
  State<DeckScreen> createState() => _DeckScreenState();
}

class _DeckScreenState extends State<DeckScreen> {
  final String _deckName = 'Physics';

  final List<Flashcard> _flashcardDeck = [
    Flashcard(
      1,
      'What is Newton\'s first law of motion?',
      'An object at rest tends to stay at rest, and an object in motion tends to stay in motion with the same speed and in the same direction unless acted upon by an external force.',
    ),
    Flashcard(
      2,
      'What is the equation for calculating force?',
      'Force = mass x acceleration',
    ),
    Flashcard(
      3,
      'What is the unit of measurement for electric current?',
      'Ampere (A)',
    ),
    Flashcard(
      4,
      'What is the formula for calculating electrical power?',
      'Power = voltage x current',
    ),
    Flashcard(
      5,
      'What is the speed of light in a vacuum?',
      'Approximately 299,792,458 meters per second (m/s)',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('This deck is $_deckName'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final snackBar = SnackBar(
                content: Text("shared deck ${widget.deckIndex}") //TODO
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar); 
            },
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem(
                  child: Text('Option 1'),
                  value: 'Option 1',
                ),
                PopupMenuItem(
                  child: Text('Option 2'),
                  value: 'Option 2',
                ),
                PopupMenuItem(
                  child: Text('Option 3'),
                  value: 'Option 3',
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
      
      body: Container(
        //padding: const EdgeInsets.only(top: 20, left: 20, right: 0), //slidables을 위한 공간을 위해 0으로
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                  '${widget.deckIndex}-th deck의 정보', // Centered text
                  style: const TextStyle(
                    color: Colors.black, // Text color
                    fontSize: 16.0, // Text size
                    fontFamily: 'Pretendard', // Custom font family
                    fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      const snackBar = SnackBar(
                        content: Text("배열 기준 변경")
                      ); 
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }, 
                    icon: const Icon(Icons.sort))
                ]
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _flashcardDeck.length,
                itemBuilder: flashcardItemBuilder),
            )
          ]
        ),
      ),
    );
  }

  Widget flashcardItemBuilder(BuildContext context, int index) {
    final Flashcard flashcard = _flashcardDeck[index];

    bool isBookmarked = false;

    return Slidable(
      key: Key(flashcard.id.toString()),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          Builder( //share button
            builder: (cont) {
              return ElevatedButton(
                onPressed: () {
                  Slidable.of(cont)!.close();
                  editCard(context, index);
                },
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(10),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.black,
                  size: 25,
                ),
              );
            }
          ),
          Builder( //bookmark button
            builder: (cont) {
              return ElevatedButton(
                onPressed: () {
                  Slidable.of(cont)!.close();
                  bookmarkCard(context, index);
                  isBookmarked = !isBookmarked;
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(10),
                ),
                child: Icon(
                  isBookmarked? Icons.bookmark: Icons.bookmark_border,
                  color: Colors.black,
                  size: 25,
                ),
              );
            }
          ),
          Builder( //delete button
            builder: (cont) {
              return ElevatedButton(
                onPressed: () {
                  Slidable.of(cont)!.close();
                  deleteCard(context, index);
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
            }
          ),
        ],
      ),

      child: GestureDetector(
        onTap: () {
          moveToEditCardScreen(context, index);
        },
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Card(
              elevation: 4.0,
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Container(
                margin: EdgeInsets.all(20),
                width: double.infinity,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      flashcard.question,
                      style: const TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 16.0, // Text size
                        fontFamily: 'Pretendard', // Custom font family
                        fontWeight: FontWeight.bold)
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                        color: Colors.grey[700],
                        thickness: 1.0,
                        height: 20,
                      ),
                    ),
                    Text(
                      flashcard.answer,
                      style: const TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 16.0, // Text size
                        fontFamily: 'Pretendard', // Custom font family
                        fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ),
            )
          ),
        ),
      )

    );
  }

  void editCard(BuildContext context, int index) async {
    final snackBar = SnackBar(
      content: Text("editing card $index")
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar); 
  }

  void bookmarkCard(BuildContext context, int index) async {
    final snackBar = SnackBar(
      content: Text("bookmarked deck $index")
    ); 
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void deleteCard(BuildContext context, int index) async {
    // TODO 삭제 취소하기 버튼


    final snackBar = SnackBar(
      content: Text("deleted card $index")
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar); 

    setState(() {
      _flashcardDeck.removeAt(index);
    });
  }

  void moveToEditCardScreen(BuildContext context, int index) {
    Flashcard flashcard = _flashcardDeck[index];

    print("move to home");

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => EditCardScreen(flashcard: flashcard)
      ),
    );
  }
}


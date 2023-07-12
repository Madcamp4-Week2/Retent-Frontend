import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:test_project/Models/deck.dart';
import 'package:test_project/Services/api_card.dart';
import 'package:test_project/Services/api_deck.dart';
import 'package:test_project/Services/api_pdf.dart';
import 'package:test_project/Services/base_client.dart';
import 'package:test_project/Views/Add/add_card_screen.dart';
import 'package:test_project/Views/Home/DecksScreen/edit_card_screen.dart';

import 'package:test_project/Models/flashcard.dart';


class DeckScreen extends StatefulWidget {
  final Deck curDeck;

  const DeckScreen({super.key, required this.curDeck});

  @override
  State<DeckScreen> createState() => _DeckScreenState();
}

class _DeckScreenState extends State<DeckScreen> with SingleTickerProviderStateMixin {
  List<Flashcard> cardList = [];
  late Deck deck;

  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

  void getMyCards(deckId) async {
    cardList = await getMyCardsDB(deckId);
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    setState(() {
      deck = widget.curDeck;
      int deckId = deck.id;
      print(deckId);
      getMyCards(deckId);
    });
    
    print("the deck is a list of $deck");

    return Scaffold(
      appBar: AppBar(
        title: Text(deck.deckName),
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
                content: Text("${deck.deckName}를 공유했습니다") //TODO
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
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Text(
                  '${deck.deckName} 의 정보', // Centered text
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
            (widget.curDeck.description != null)?
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              height: 60,
              child: Text(
                widget.curDeck.description!,
                style: const TextStyle(
                    color: Colors.black, // Text color
                    fontSize: 16.0, // Text size
                    fontFamily: 'Pretendard', // Custom font family
                    fontWeight: FontWeight.bold
                ),
              )
            ) : const SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                itemCount: cardList.length,
                itemBuilder: flashcardItemBuilder),
            )
          ]
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_isExpanded) buildCircularButton(Icons.picture_as_pdf, () {
            generatePDFcards(context, deck.id);
          }),
          if (_isExpanded) const SizedBox(height: 16.0),
          if (_isExpanded) buildCircularButton(Icons.photo_library, () {
            moveToAddCardScreen(context);
          }),
          if (_isExpanded) const SizedBox(height: 16.0),
          FloatingActionButton(
            child: Icon(_isExpanded ? Icons.close : Icons.add),
            onPressed: _toggleExpanded,
          ),
          ]
        )  ,
    );
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
    final Flashcard flashcard = cardList[index];

    return Slidable(
      key: Key(flashcard.id.toString()),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
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
    moveToEditCardScreen(context, index);
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
      cardList.removeAt(index);
    });
  }

  void addPDF(BuildContext context) {
    

  }

  void moveToAddCardScreen(BuildContext context) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => AddCardScreen(
          newDeck: widget.curDeck,
        )
      ),
    );
  }

  void moveToEditCardScreen(BuildContext context, int index) {
    Flashcard flashcard = cardList[index];

    print("move to home");

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => EditCardScreen(flashcard: flashcard)
      ),
    );
  }
}


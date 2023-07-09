import 'package:flutter/material.dart';
import 'package:test_project/Home/learn_finish_screen.dart';
import 'package:test_project/flashcard.dart';

import 'package:flip_card/flip_card.dart';

class LearnDeckScreen extends StatefulWidget {
  final int deckIndex;

  const LearnDeckScreen({super.key, required this.deckIndex});

  @override
  State<LearnDeckScreen> createState() => _LearnDeckScreenState();
}

class _LearnDeckScreenState extends State<LearnDeckScreen> {

  int currentCardIdx = 0;

  int rightCount = 0;
  int wrongCount = 0;

  //db에서 불러오기
  final List<Flashcard> deck = [
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
        actions: [],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: currentCardIdx/deck.length,
            color: Colors.red,
          ),
          Padding( // TODO 꾸미기
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Right: $rightCount'),
                Text('Wrong: $wrongCount'),   
              ],
            ),
          ),
          DraggableCard(
            cardData: deck[currentCardIdx],
            onCardDragged: (result) {
              setState(() {
                if (result == CardDragResult.right) {
                  rightCount++;
                } else if (result == CardDragResult.wrong) {
                  wrongCount++;
                }

                currentCardIdx++;
                if (currentCardIdx == deck.length) {
                  endOfDeck(); // infinite loop
                  currentCardIdx = 0;
                }
              });
            },
          ),
        ]
      ),
    );
  }

  void endOfDeck() {
    //move to end page
    const snackBar = SnackBar(
      content: Text("학습이 끝났습니다")
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar); 
  
  }
}

class DraggableCard extends StatefulWidget {
  final Flashcard cardData;
  final Function(CardDragResult) onCardDragged;

  const DraggableCard({super.key, 
    required this.cardData,
    required this.onCardDragged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DraggableCardState createState() => _DraggableCardState();
}

enum CardDragResult {
  right,
  wrong,
}

class _DraggableCardState extends State<DraggableCard> {
  bool isFront = true;
  bool isDraggedRight = false;
  bool isDraggedWrong = false;

  @override
  Widget build(BuildContext context) {
    return Draggable(
      feedback: CardFace(
        content: (isFront ? widget.cardData.question : widget.cardData.answer),
        isDraggedRight: isDraggedRight, 
        isDraggedWrong: isDraggedWrong,),
      childWhenDragging: const CardFace(content: ""),
      onDragEnd: (details) {
        if (details.offset.dx < -10) {
          widget.onCardDragged(CardDragResult.right);
        } else if (details.offset.dx > 10) {
          widget.onCardDragged(CardDragResult.wrong);
        }
        setState(() {
          isDraggedRight = false;
          isDraggedWrong = false;
        });
      },
      onDragUpdate: (details) {
        setState(() {
          if(details.delta.dx > 5) {
            isDraggedWrong = true;
          } else if (details.delta.dx < -5) {
            isDraggedRight = true;
          }
        });        
      },
      child: FlipCard(
        onFlipDone: (status) {
          print(status);
          setState(() {
            isFront = !isFront;
          });
        },
        front: CardFace(content: widget.cardData.question),
        back: CardFace(content: widget.cardData.answer),
      ),
    );
  }
}

class CardFace extends StatelessWidget {
  final String content;
  final bool isDraggedRight;
  final bool isDraggedWrong;

  const CardFace({
    super.key,
    required this.content,
    this.isDraggedRight = false,
    this.isDraggedWrong = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: isDraggedRight ? Colors.green : (isDraggedWrong ? Colors.red : Colors.transparent),
          width: 2.0,
        ),
      ),
      child: Container(
        width: 300,
        height: 200,
        padding: EdgeInsets.all(40),
        alignment: Alignment.center,
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

void moveToHomePage(BuildContext context) async {
    print("move to home");

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => LearnFinishScreen()
      ),
    );
  }

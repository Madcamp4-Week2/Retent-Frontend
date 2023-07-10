import 'package:flutter/material.dart';
import 'package:test_project/Views/Home/deck_list_screen.dart';
import 'package:test_project/Views/Home/learn_finish_screen.dart';
import 'package:test_project/Models/flashcard.dart';

import 'package:flip_card/flip_card.dart';

import 'package:rxdart/rxdart.dart';

class LearnDeckScreen extends StatefulWidget {
  final int deckIndex;

  const LearnDeckScreen({super.key, required this.deckIndex});

  @override
  State<LearnDeckScreen> createState() => _LearnDeckScreenState();
}

class _LearnDeckScreenState extends State<LearnDeckScreen> {
  late BehaviorSubject<CardDragAction> willAcceptStream;

  @override
  void initState() {
    willAcceptStream = BehaviorSubject<CardDragAction>();
    willAcceptStream.add(CardDragAction.none);
    super.initState();
  }

  @override
  void dispose() {
    willAcceptStream.close();
    super.dispose();
  }

  int currentCardIdx = 0;

  int rightCount = 0;
  int wrongCount = 0;

  double answerTime = 0;

  //db에서 불러오기
  final List<Flashcard> flashcardDeck = [
    Flashcard(
      id: 1,
      answerCorrect: true,
      question: "What is the capital of France?",
      answer: "Paris",
      interval: 5,
      deck: 1,
      answerTime: 10,
      cardFavorite: false,
    ),
    Flashcard(
      id: 2,
      answerCorrect: true,
      question: "What is the chemical symbol for gold?",
      answer: "Au",
      interval: 5,
      deck: 1,
      answerTime: 15,
      cardFavorite: true,
    ),
    Flashcard(
      id: 3,
      answerCorrect: false,
      question: "Who wrote the novel 'Pride and Prejudice'?",
      answer: "Jane Austen",
      interval: 5,
      deck: 2,
      answerTime: 12,
      cardFavorite: false,
    ),
    Flashcard(
      id: 4,
      answerCorrect: true,
      question: "What is the capital of Japan?",
      answer: "Tokyo",
      interval: 5,
      deck: 1,
      answerTime: 8,
      cardFavorite: true,
    ),
    Flashcard(
      id: 5,
      answerCorrect: true,
      question: "What is the largest planet in our solar system?",
      answer: "Jupiter",
      interval: 5,
      deck: 3,
      answerTime: 10,
      cardFavorite: false,
    ),
    Flashcard(
      id: 6,
      answerCorrect: false,
      question: "What is the chemical symbol for iron?",
      answer: "Fe",
      interval: 5,
      deck: 1,
      answerTime: 12,
      cardFavorite: true,
    ),
    Flashcard(
      id: 7,
      answerCorrect: true,
      question: "Who painted the Mona Lisa?",
      answer: "Leonardo da Vinci",
      interval: 5,
      deck: 4,
      answerTime: 15,
      cardFavorite: false,
    ),
    Flashcard(
      id: 8,
      answerCorrect: false,
      question: "What is the largest ocean in the world?",
      answer: "Pacific Ocean",
      interval: 5,
      deck: 3,
      answerTime: 10,
      cardFavorite: true,
    ),
    Flashcard(
      id: 9,
      answerCorrect: true,
      question: "What is the capital of Brazil?",
      answer: "Brasília",
      interval: 5,
      deck: 1,
      answerTime: 12,
      cardFavorite: false,
    ),
    Flashcard(
      id: 10,
      answerCorrect: true,
      question: "Who wrote the play 'Romeo and Juliet'?",
      answer: "William Shakespeare",
      interval: 5,
      deck: 2,
      answerTime: 10,
      cardFavorite: true,
    ),
    Flashcard(
      id: 11,
      answerCorrect: false,
      question: "What is the chemical symbol for sodium?",
      answer: "Na",
      interval: 5,
      deck: 1,
      answerTime: 8,
      cardFavorite: false,
    ),
    Flashcard(
      id: 12,
      answerCorrect: true,
      question: "Who painted the 'Starry Night'?",
      answer: "Vincent van Gogh",
      interval: 5,
      deck: 4,
      answerTime: 15,
      cardFavorite: true,
    ),
    Flashcard(
      id: 13,
      answerCorrect: false,
      question: "What is the largest continent in the world?",
      answer: "Asia",
      interval: 5,
      deck: 3,
      answerTime: 12,
      cardFavorite: false,
    ),
    Flashcard(
      id: 14,
      answerCorrect: true,
      question: "What is the capital of Australia?",
      answer: "Canberra",
      interval: 5,
      deck: 1,
      answerTime: 10,
      cardFavorite: true,
    ),
    Flashcard(
      id: 15,
      answerCorrect: false,
      question: "Who wrote the novel 'To Kill a Mockingbird'?",
      answer: "Harper Lee",
      interval: 5,
      deck: 2,
      answerTime: 12,
      cardFavorite: false,
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
            value: currentCardIdx/flashcardDeck.length,
            color: Colors.red,
          ),
          Padding( // TODO 꾸미기
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  color: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$rightCount', // Centered text
                      style: const TextStyle(
                        color: Colors.black, // Text color
                        fontSize: 16.0, // Text size
                        fontFamily: 'Pretendard', // Custom font family
                        fontWeight: FontWeight.bold)
                    ),
                  ),
                ),
                Card(
                  color: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$wrongCount', // Centered text
                      style: const TextStyle(
                        color: Colors.black, // Text color
                        fontSize: 16.0, // Text size
                        fontFamily: 'Pretendard', // Custom font family
                        fontWeight: FontWeight.bold)
                    ),
                  ),
                ), 
              ],
            ),
          ),
          SizedBox(height: 20,),
          Center(
            child: DraggableCard(
              cardData: flashcardDeck[currentCardIdx],
              onCardDragged: (result) {
                setState(() {
                  if (result == CardDragAction.right) {
                    rightCount++;
                    currentCardIdx++;
                  } else if (result == CardDragAction.wrong) {
                    wrongCount++;
                    currentCardIdx++;
                  } 
          
                  if (currentCardIdx == flashcardDeck.length) {
                    endOfDeck(); // infinite loop
                    currentCardIdx = 0;
                  }
                });
              },
              willAcceptStream: willAcceptStream,
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  gotoPreviousCard();
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(10),
                ),
                child: const Icon(
                  Icons.undo,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(10),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.greenAccent,
                  size: 30,
                ),
              ),
            ],
          ),
          Spacer(),
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

    moveToLearnFinishScreen();
  }

  void gotoPreviousCard() {
    // setState(() {
    //   if(currentCardIdx >= 1) {
    //     currentCardIdx -= 1;
    //   }
    //   else {
    //     print("move to DeckListScreen");
    //     Navigator.push(
    //       context, 
    //       MaterialPageRoute(
    //         builder: (context) => DeckListScreen()
    //       ),
    //     );
    // //   }
      
    // });
  }

  void moveToLearnFinishScreen() async {
    print("move to home");

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => LearnFinishScreen(
          rightCount: rightCount,
          wrongCount: wrongCount,
        )
      ),
    );
  }
}

class DraggableCard extends StatefulWidget {
  final Flashcard cardData;
  final Function(CardDragAction) onCardDragged;
  final BehaviorSubject<CardDragAction> willAcceptStream;

  const DraggableCard({super.key, 
    required this.cardData,
    required this.onCardDragged,
    required this.willAcceptStream,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DraggableCardState createState() => _DraggableCardState();
}

// enum CardDragResult {
//   right,
//   wrong,
// }

enum CardDragAction {
  right, 
  wrong,
  none,
}

class DragStreamData {
  final bool isDraggedRight;
  final bool isDraggedWrong;

  DragStreamData(this.isDraggedRight, this.isDraggedWrong);
}

class _DraggableCardState extends State<DraggableCard> {
  bool isFront = true;
  bool isDraggedRight = false;
  bool isDraggedWrong = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      child: Draggable(
        feedback: StreamBuilder(
          initialData: CardDragAction.none,
          stream: widget.willAcceptStream,
          builder:(context, snapshot) {
            CardDragAction streamData = snapshot.data!;
      
            return CardFace(
              content: (isFront ? widget.cardData.question : widget.cardData.answer),
              cardDragAction: streamData,
            );
            },  
        ),
          
        childWhenDragging: const CardFace(content: ""),
        onDragEnd: (details) {
          final position = details.offset.dx - 51.71;
      
          if (position < -20) {
            widget.onCardDragged(CardDragAction.right);
            print("is right");
          } else if (position > 20) {
            widget.onCardDragged(CardDragAction.wrong);
            print("is wrong");
          } else {
            widget.onCardDragged(CardDragAction.none);
            print("is nothing");
          }
          print("moved ${position}");
        },
        onDragUpdate: (details) {
          setState(() {
            if (details.delta.dx < -3) {
              isDraggedRight = true;
              widget.willAcceptStream.add(CardDragAction.right);
              print("is dragging to right");
            } else if(details.delta.dx > 3) {
              isDraggedWrong = true;
              widget.willAcceptStream.add(CardDragAction.wrong);
              print("is dragging to wrong");
            } 
          }); 
          //print("moved ${details.delta.dx}");       
        },
        child: FlipCard(
          onFlipDone: (status) {
            setState(() {
              isFront = !isFront;
            });
          },
          front: CardFace(content: widget.cardData.question),
          back: CardFace(content: widget.cardData.answer),
        ),
      ),
    );
  }
}

class CardFace extends StatelessWidget {
  final String content;
  final CardDragAction cardDragAction;

  const CardFace({
    super.key,
    required this.content,
    this.cardDragAction = CardDragAction.none,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor = Colors.transparent;
    if (cardDragAction == CardDragAction.right) {
      cardColor = Colors.green;
    } else if (cardDragAction == CardDragAction.wrong) {
      cardColor = Colors.red;
    }

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: cardColor,
          width: 2.0,
        ),
      ),
      child: Container(
        width: 300,
        height: 500,
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



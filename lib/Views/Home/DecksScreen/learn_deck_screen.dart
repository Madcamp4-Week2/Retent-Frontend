import 'package:flutter/material.dart';
import 'package:test_project/Models/deck.dart';
import 'package:test_project/Services/api_card.dart';
import 'package:test_project/Views/Home/DecksScreen/deck_list_screen.dart';
import 'package:test_project/Views/Home/DecksScreen/learn_finish_screen.dart';
import 'package:test_project/Models/flashcard.dart';

import 'package:flip_card/flip_card.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:test_project/Views/Home/home_screen.dart';

class LearnDeckScreen extends StatefulWidget {
  final Deck deck;

  const LearnDeckScreen({super.key, required this.deck});

  @override
  State<LearnDeckScreen> createState() => _LearnDeckScreenState();
}

class _LearnDeckScreenState extends State<LearnDeckScreen> {
  late BehaviorSubject<CardDragAction> willAcceptStream;
  late Timer cardTimer;

  double totalTime = 0;

  void startCardTimer() {
    cardTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        totalTime += 1;
      });
    });
  }
  
  int currentCardIdx = 0;

  int rightCount = 0;
  int wrongCount = 0;
  List<bool> log = [];

  double answerTime = 0;

  late List<Flashcard> cardList;

  bool listInitialized = false;

  void getMyCards(deckId) async {
    cardList = await getMyCardsDB(deckId);
    setState(() {
      listInitialized = true;
    });
  }

  @override
  void initState() {
    super.initState();
    willAcceptStream = BehaviorSubject<CardDragAction>();
    willAcceptStream.add(CardDragAction.none);
    print(widget.deck.id);
    getMyCards(widget.deck.id);
    startCardTimer();

    setState(() {
      currentCardIdx = 0;
      rightCount = 0;
      wrongCount = 0;
      log = [];
    });
  }

  @override
  void dispose() {
    willAcceptStream.close();
    cardTimer.cancel();
    super.dispose();
  }  
  //db에서 불러오기
  
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
      body: (listInitialized == false)? const Center(child: CircularProgressIndicator()):
      Column(
        children: [
          LinearProgressIndicator(
            value: currentCardIdx/cardList.length,
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
                  color: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$totalTime', // Centered text
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
          const SizedBox(height: 20,),
          Center(
            child: DraggableCard(
              cardData: cardList[currentCardIdx],
              onCardDragged: (result) {
                setState(() {
                  if (result == CardDragAction.right) {
                    rightCount++;
                    currentCardIdx++;
                    log.add(true);
                  } else if (result == CardDragAction.wrong) {
                    wrongCount++;
                    currentCardIdx++;
                    log.add(false);
                  } 
                  if (currentCardIdx == cardList.length) {
                    endOfDeck();
                  }
                });
              },
              willAcceptStream: willAcceptStream,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  gotoPreviousCard();
                  print("go back");
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
          const Spacer(),
        ]
      ),
    );
  }

  void endOfDeck() {
    cardTimer.cancel();
    //move to end page
    const snackBar = SnackBar(
      content: Text("학습이 끝났습니다")
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar); 

    moveToLearnFinishScreen();
  }

  void gotoPreviousCard() {
    setState(() {
      if(currentCardIdx >= 1) {
        print(currentCardIdx);
        if(log[currentCardIdx-1] == true) rightCount--;
        else wrongCount--;
        log.removeLast();
        currentCardIdx--;
      }
      else {
        print("move to DeckListScreen");
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => HomeScreen()
          ),
        );
      }
      
    });
  }

  void moveToLearnFinishScreen() async {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => LearnFinishScreen(
          rightCount: rightCount,
          wrongCount: wrongCount,
          totalTime: totalTime,
          deck: widget.deck,
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
        padding: const EdgeInsets.all(40),
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



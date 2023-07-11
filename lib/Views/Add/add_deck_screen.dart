import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:test_project/Models/deck.dart';
import 'package:test_project/Services/api_card.dart';
import 'package:test_project/Services/api_deck.dart';
import 'package:test_project/Services/base_client.dart';
import 'package:test_project/Views/Add/add_card_screen.dart';
import 'package:test_project/Views/Home/edit_card_screen.dart';

import 'package:test_project/Models/flashcard.dart';
import 'package:test_project/auth_provider.dart';


class AddDeckScreen extends StatefulWidget {
  const AddDeckScreen({super.key});

  @override
  State<AddDeckScreen> createState() => _AddDeckScreenState();
}

class _AddDeckScreenState extends State<AddDeckScreen> {
  List<Flashcard> currentCardList = [];
  late int userId;

  Deck newDeck = Deck(id: 0, deckName: "임시", user: 0); // Temp value
  bool isDeckInitialized = false; 

  final TextEditingController textEditingController = TextEditingController();

  // void addNewDeckDB(Deck newDeck) async {
  //   var response = await BaseClient().post('/flash-card/decks', newDeck);
  //   if (response == null) {
  //     debugPrint("addNewDeck unsuccessful");
  //   }
  // }

  void initNewDeck(int userId) async {
    final deck = await postDeckDB("name", userId);
    setState(() {
      if (deck != null) {
        newDeck = deck;
        isDeckInitialized = true; // Mark the newDeck as initialized
    }
    else isDeckInitialized = false;
    });
  }

  @override
  void initState() {
    super.initState();

    final loginState = Provider.of<LoginState>(context, listen: false);
    setState(() {
      userId = loginState.userId; // TODO
    });
    initNewDeck(userId);
  }

  @override
  Widget build(BuildContext context) {
    // final loginState = Provider.of<LoginState>(context, listen: false);
    // setState(() {
    //   userId = loginState.userId; // TODO
    // });

    initNewDeck(userId);

    void saveNewDeck() {
      patchDeckDB(newDeck.id, textEditingController.text);
    }

  //   //currentCardList = [
  //   Flashcard(
  //     id: 1,
  //     answerCorrect: true,
  //     question: "What is the capital of France?",
  //     answer: "Paris",
  //     interval: 5,
  //     deck: 1,
  //     answerTime: 10,
  //     cardFavorite: false,
  //   ),
  //   Flashcard(
  //     id: 2,
  //     answerCorrect: true,
  //     question: "What is the chemical symbol for gold?",
  //     answer: "Au",
  //     interval: 5,
  //     deck: 1,
  //     answerTime: 15,
  //     cardFavorite: true,
  //   ),
  //   Flashcard(
  //     id: 3,
  //     answerCorrect: false,
  //     question: "Who wrote the novel 'Pride and Prejudice'?",
  //     answer: "Jane Austen",
  //     interval: 5,
  //     deck: 2,
  //     answerTime: 12,
  //     cardFavorite: false,
  //   ),
  //   Flashcard(
  //     id: 4,
  //     answerCorrect: true,
  //     question: "What is the capital of Japan?",
  //     answer: "Tokyo",
  //     interval: 5,
  //     deck: 1,
  //     answerTime: 8,
  //     cardFavorite: true,
  //   ),
  //   Flashcard(
  //     id: 5,
  //     answerCorrect: true,
  //     question: "What is the largest planet in our solar system?",
  //     answer: "Jupiter",
  //     interval: 5,
  //     deck: 3,
  //     answerTime: 10,
  //     cardFavorite: false,
  //   ),
  //   Flashcard(
  //     id: 6,
  //     answerCorrect: false,
  //     question: "What is the chemical symbol for iron?",
  //     answer: "Fe",
  //     interval: 5,
  //     deck: 1,
  //     answerTime: 12,
  //     cardFavorite: true,
  //   ),
  //   Flashcard(
  //     id: 7,
  //     answerCorrect: true,
  //     question: "Who painted the Mona Lisa?",
  //     answer: "Leonardo da Vinci",
  //     interval: 5,
  //     deck: 4,
  //     answerTime: 15,
  //     cardFavorite: false,
  //   ),
  //   Flashcard(
  //     id: 8,
  //     answerCorrect: false,
  //     question: "What is the largest ocean in the world?",
  //     answer: "Pacific Ocean",
  //     interval: 5,
  //     deck: 3,
  //     answerTime: 10,
  //     cardFavorite: true,
  //   ),
  //   Flashcard(
  //     id: 9,
  //     answerCorrect: true,
  //     question: "What is the capital of Brazil?",
  //     answer: "Brasília",
  //     interval: 5,
  //     deck: 1,
  //     answerTime: 12,
  //     cardFavorite: false,
  //   ),
  //   Flashcard(
  //     id: 10,
  //     answerCorrect: true,
  //     question: "Who wrote the play 'Romeo and Juliet'?",
  //     answer: "William Shakespeare",
  //     interval: 5,
  //     deck: 2,
  //     answerTime: 10,
  //     cardFavorite: true,
  //   ),
  //   Flashcard(
  //     id: 11,
  //     answerCorrect: false,
  //     question: "What is the chemical symbol for sodium?",
  //     answer: "Na",
  //     interval: 5,
  //     deck: 1,
  //     answerTime: 8,
  //     cardFavorite: false,
  //   ),
  //   Flashcard(
  //     id: 12,
  //     answerCorrect: true,
  //     question: "Who painted the 'Starry Night'?",
  //     answer: "Vincent van Gogh",
  //     interval: 5,
  //     deck: 4,
  //     answerTime: 15,
  //     cardFavorite: true,
  //   ),
  //   Flashcard(
  //     id: 13,
  //     answerCorrect: false,
  //     question: "What is the largest continent in the world?",
  //     answer: "Asia",
  //     interval: 5,
  //     deck: 3,
  //     answerTime: 12,
  //     cardFavorite: false,
  //   ),
  //   Flashcard(
  //     id: 14,
  //     answerCorrect: true,
  //     question: "What is the capital of Australia?",
  //     answer: "Canberra",
  //     interval: 5,
  //     deck: 1,
  //     answerTime: 10,
  //     cardFavorite: true,
  //   ),
  //   Flashcard(
  //     id: 15,
  //     answerCorrect: false,
  //     question: "Who wrote the novel 'To Kill a Mockingbird'?",
  //     answer: "Harper Lee",
  //     interval: 5,
  //     deck: 2,
  //     answerTime: 12,
  //     cardFavorite: false,
  //   ),
  // ];
    // if (!isDeckInitialized) {
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: const Text("새로운 덱"),
    //     ),
    //     body: const Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text("새로운 덱"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("저장사항 삭제")
            )); 
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
      body: Container(
        //padding: const EdgeInsets.only(top: 20, left: 20, right: 0), //slidables을 위한 공간을 위해 0으로
        child: Column(
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
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
                        decoration: const InputDecoration(
                          hintText: '덱의 이름을 입력하세요'
                        ),
                      ),
                    ),
                  ),
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
                itemCount: currentCardList.length,
                itemBuilder: flashcardItemBuilder),
            )
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          moveToAddCardPage(context);
        }
      ),
    );
  }

  Widget flashcardItemBuilder(BuildContext context, int index) {
    final Flashcard flashcard = currentCardList[index];

    void editCard(BuildContext context, Flashcard card) async {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("editing card")
      )); 
      moveToEditCardScreen(context, card);
    }

    void deleteCard() async {
      // TODO 삭제 취소하기 버튼

      final snackBar = SnackBar(
        content: Text("deleted card $index")
      );
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
          Builder( //share button
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
            }
          ),
          Builder( //delete button
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
            }
          ),
        ],
      ),

      child: GestureDetector(
        onTap: () {
          editCard(context, flashcard);
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
                margin: const EdgeInsets.all(20),
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

  void moveToAddCardPage(BuildContext context) async {
    print("move to add card");

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => AddCardScreen(
          newDeck: newDeck,
        )
      ),
    );
  }

  void moveToEditCardScreen(BuildContext context, Flashcard card) {
    print("move to edit card");

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => EditCardScreen(flashcard: card)
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:test_project/Home/deck_screen.dart';
import 'package:test_project/Home/learn_deck_screen.dart';

class DeckListScreen extends StatefulWidget {
  const DeckListScreen({super.key});

  @override
  State<DeckListScreen> createState() => _DeckListScreenState();
}

class _DeckListScreenState extends State<DeckListScreen> {
  final List<String> _decks = [
    'Deck 1',
    'Deck 2',
    'Deck 3','Deck 1',
    'Deck 2',
    'Deck 3','Deck 1',
    'Deck 2',
    'Deck 3','Deck 1',
    'Deck 2',
    'Deck 3',
  ]; //dummy data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _decks.length,
        itemBuilder: deckItemBuilder
      ),
    );
  }

  Widget deckItemBuilder(BuildContext context, int index) {
    final deck = _decks[index];

    return Slidable(
      key: Key(deck),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Builder( //share button
            builder: (cont) {
              return ElevatedButton(
                onPressed: () {
                  Slidable.of(cont)!.close();
                  shareDeck(context, index);
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(10),
                ),
                child: const Icon(
                  Icons.share,
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
                  bookmarkDeck(context, index);
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(10),
                ),
                child: const Icon(
                  Icons.bookmark_border,
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
                  deleteDeck(context, index);
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
          moveToDeckScreen(context, index);
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          height: 80,
          child: Card(
            elevation: 4.0,
            color: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    //width: double.infinity,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      deck,
                      style: const TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 16.0, // Text size
                        fontFamily: 'Pretendard', // Custom font family
                        fontWeight: FontWeight.bold)
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      moveToLearnScreen(context, index);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(2),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.greenAccent,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
          )
        ),
      )

    );
  }

  void shareDeck(BuildContext context, int index) async {
    final snackBar = SnackBar(
      content: Text("shared deck $index")
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar); 
  }

  void bookmarkDeck(BuildContext context, int index) async {
    final snackBar = SnackBar(
      content: Text("bookmarked deck $index")
    ); 
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void deleteDeck(BuildContext context, int index) async {
    final snackBar = SnackBar(
      content: Text("deleted deck $index")
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar); 

    setState(() {
      _decks.removeAt(index);
    });
  }

  void moveToDeckScreen(BuildContext context, int index) {
    print("move to home");

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => DeckScreen(deckIndex: index)
      ),
    );
  }

  void moveToLearnScreen(BuildContext context, int index) {
    print("move to home");

    final snackBar = SnackBar(
      content: Text("Learn deck $index")
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar); 

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => LearnDeckScreen(deckIndex: index)
      ),
    );
  }
}
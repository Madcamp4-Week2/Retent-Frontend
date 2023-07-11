import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:test_project/Models/deck.dart';
import 'package:test_project/Services/api_deck.dart';
import 'package:test_project/Services/base_client.dart';
import 'package:test_project/Views/Add/add_deck_screen.dart';
import 'package:test_project/Views/Home/deck_screen.dart';
import 'package:test_project/Views/Home/learn_deck_screen.dart';
import 'package:test_project/auth_provider.dart';

class DeckListScreen extends StatefulWidget {
  const DeckListScreen({super.key});

  @override
  State<DeckListScreen> createState() => _DeckListScreenState();
}

class _DeckListScreenState extends State<DeckListScreen> with SingleTickerProviderStateMixin {

  List<Deck> myDeckList = [];
  late int userId;

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

  // void getMyDeck(userId) async {
  //   myDeckList = await getMyDecksDB(userId);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final loginState = Provider.of<LoginState>(context, listen: false);
    setState(() {
      userId = loginState.userId; // TODO
      getMyDecksDB(userId).then((decks) {
        myDeckList = decks;
      });
    });

    debugPrint("UserId is $userId!!!!!!!!!!!!!");
    
    print("the total list is $myDeckList");

    return Scaffold(
      body: myDeckList.isEmpty?
        const Center(
          child: Text(
            '덱을 추가하세요',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ) :
        ListView.builder(
        itemCount: myDeckList.length,
        itemBuilder: deckItemBuilder
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // if (_isExpanded) buildCircularButton(Icons.camera_alt, () {
          //   moveToAddDeckScreen(context);
          // }),
          if (_isExpanded) const SizedBox(height: 16.0),
          if (_isExpanded) buildCircularButton(Icons.photo_library, () {
            moveToAddDeckScreen(context);
          }),
          if (_isExpanded) const SizedBox(height: 16.0),
          FloatingActionButton(
            child: Icon(_isExpanded ? Icons.close : Icons.add),
            onPressed: _toggleExpanded,
          ),
        ],
      ),
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

  Widget deckItemBuilder(BuildContext context, int index) {
    final deck = myDeckList[index];

    bool isBookmarked = deck.deckFavorite;

    void shareDeck() async {
      final snackBar = SnackBar(
        content: Text("shared deck $index")
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar); 
    }

    void bookmarkDeck() async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("bookmarked deck ${deck.deckName}")));
      isBookmarked = true;
      bookmarkDeckDB(deck.id);
    }

    void unbookmarkDeck() async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("unbookmarked deck ${deck.deckName}")));
      isBookmarked = false;
      unbookmarkDeckDB(deck.id);
    }

    void deleteDeck() async {
      final confirmed = await showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: Theme.of(context).copyWith(
              dialogTheme: DialogTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ), 
            child: AlertDialog(
              //title: Text('Delete Deck'),
              contentPadding: const EdgeInsets.all(16.0),
              content: const Text('덱을 정말 삭제하시겠습니까'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false to indicate cancel
                  },
                  child: const Text('아니오'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true to indicate confirmation
                  },
                  child: const Text('예'),
                ),
              ],
            )
          );
        },
      );

      if (confirmed == true) {
        final snackBar = SnackBar(
          content: Text("Deleted card $index"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        setState(() {
          myDeckList.removeAt(index);
        });
        deleteDeckDB(deck.id);
      }
    }

    return Slidable(
      key: Key(deck.deckName),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Builder( //share button
            builder: (cont) {
              return ElevatedButton(
                onPressed: () {
                  Slidable.of(cont)!.close();
                  shareDeck();
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
                  isBookmarked? unbookmarkDeck: bookmarkDeck;
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
                  deleteDeck();
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
          moveToDeckScreen(context, deck);
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
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      deck.deckName,
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
                      moveToLearnScreen(context, deck);
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


  void moveToDeckScreen(BuildContext context, Deck deck) {
    print("move to home");

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => DeckScreen(deck : deck)
      ),
    );
  }

  void moveToLearnScreen(BuildContext context, Deck deck) {
    print("move to home");

    final snackBar = SnackBar(
      content: Text("Learn deck ${deck.deckName}")
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar); 

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => LearnDeckScreen(deck: deck)
      ),
    );
  }

  void moveToAddDeckScreen(BuildContext context) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => const AddDeckScreen()
      ),
    );
  }
}
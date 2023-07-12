import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:test_project/Models/deck.dart';
import 'package:test_project/Services/api_deck.dart';
import 'package:test_project/Services/base_client.dart';
import 'package:test_project/Views/Add/add_deck_screen.dart';
import 'package:test_project/Views/Home/DecksScreen/deck_screen.dart';
import 'package:test_project/Views/Home/DecksScreen/learn_deck_screen.dart';
import 'package:test_project/auth_provider.dart';
import 'package:textfield_tags/textfield_tags.dart';

class DeckListScreen extends StatefulWidget {
  const DeckListScreen({super.key});

  @override
  State<DeckListScreen> createState() => _DeckListScreenState();
}

class _DeckListScreenState extends State<DeckListScreen> with SingleTickerProviderStateMixin {

  List<Deck> myDeckList = [];
  List<Deck> shownDeckList = [];
  late int userId;

  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  TextEditingController deckSearchController = TextEditingController();
  TextfieldTagsController tagsController = TextfieldTagsController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  
    final loginState = Provider.of<LoginState>(context, listen: false);
    setState(() {
      userId = loginState.userId;
    });
    getMyDeck(userId);
    loginState.updateDeckList(); //다른개에서도 업대이트하기
    shownDeckList = myDeckList;
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

  void getMyDeck(userId) async {
    myDeckList = await getMyDecksDB(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
        ):
        Column(
          children: [
            deckSearchBar(),
            Expanded(
              child: ListView.builder(
              itemCount: shownDeckList.length,
              itemBuilder: deckItemBuilder
                  ),
            ),
          ],
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

  Widget deckSearchBar() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextFieldTags(
            textfieldTagsController: tagsController,
            initialTags: [],
            textSeparators: const [' ', ','],
            letterCase: LetterCase.normal,
            validator: (String tag) {
              if (tag == 'taboo') {
                return 'nope';
              } else if (tagsController.getTags!.contains(tag)) {
                return '이미 사용하셨습니다';
              }
            },
            inputfieldBuilder:
              (context, tec, fn, error, onChanged, onSubmitted) {
            return ((context, sc, tags, onTagDelete) {
              double _distanceToField;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: tec,
                  focusNode: fn,
                  decoration: InputDecoration(
                    isDense: true,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 74, 137, 92),
                        width: 3.0,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 74, 137, 92),
                        width: 3.0,
                      ),
                    ),
                    helperText: '태그를 입력하세요',
                    helperStyle: const TextStyle(
                      color: Color.fromARGB(255, 74, 137, 92),
                    ),
                    //hintText: tagsController.hasTags ? '' : "태그를 입력하세요",
                    errorText: error,
                    prefixIconConstraints:
                        BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.74),
                    prefixIcon: tags.isNotEmpty
                        ? SingleChildScrollView(
                            controller: sc,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: tags.map((String tag) {
                              return Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                  color: Color.fromARGB(255, 74, 137, 92),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: Text(
                                        '#$tag',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      onTap: () {
                                        print("$tag 선택");
                                      },
                                    ),
                                    const SizedBox(width: 4.0),
                                    InkWell(
                                      child: const Icon(
                                        Icons.cancel,
                                        size: 14.0,
                                        color: Colors.grey,
                                      ),
                                      onTap: () {
                                        onTagDelete(tag);
                                      },
                                    )
                                  ],
                                ),
                              );
                            }).toList()),
                          )
                        : null,
                  ),
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                ),
              );
            });
                  },
                ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () {
            tagsController.clearTags();
          },
          child: const Text('태그 지우기'),
        )
        ],
      ),
    );
  }

  void filterSearchResults(String query) {
    setState(() {
      shownDeckList = myDeckList
        .where((item) => item.deckName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    });
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
    final deck = shownDeckList[index];

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
          shownDeckList.removeAt(index);
        });
        deleteDeckDB(deck.id);
      }
    }

    return Slidable(
      key: Key(deck.id.toString()),
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
        builder: (context) => DeckScreen(curDeck : deck)
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
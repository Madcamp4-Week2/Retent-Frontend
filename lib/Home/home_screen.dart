import 'package:flutter/material.dart';
import 'deck_list_screen.dart';
import 'stats_screen.dart';
import 'market_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>  _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MarketScreen(),
    DeckListScreen(),
    StatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retent'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: '장터',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.style),
            label: '카드',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.equalizer),
            label: '분석',
          ),
        ],
        selectedItemColor: Colors.blue, // Selected item color
        unselectedItemColor: Colors.grey, // Unselected item color
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
        ), // Selected item label style
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w200,
        ), // Unselected item label style
      ),
    );
  }
}




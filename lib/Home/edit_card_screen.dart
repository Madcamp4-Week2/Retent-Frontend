import 'package:flutter/material.dart';

class EditCardScreen extends StatelessWidget {
  final int cardIndex;
  
  EditCardScreen({required this.cardIndex});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Market',
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}
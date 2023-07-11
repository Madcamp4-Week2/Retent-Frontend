import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:test_project/Services/api_history.dart';
import 'package:test_project/Views/Home/deck_list_screen.dart';

class LearnFinishScreen extends StatefulWidget {
  final int rightCount;
  final int wrongCount;
  final double totalTime;
  final int deckId;

  LearnFinishScreen({super.key,
    required this.rightCount,
    required this.wrongCount,
    required this.totalTime,
    required this.deckId,
  });

  @override
  State<LearnFinishScreen> createState() => _LearnFinishScreenState();
}

class _LearnFinishScreenState extends State<LearnFinishScreen> {
  late double accuracy;

  @override
  void initState() {
    super.initState();
    accuracy = widget.rightCount/ (widget.rightCount + widget.wrongCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Spacer(flex: 1,),
            Container(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: accuracy,
                    strokeWidth: 30,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    backgroundColor: Colors.red,
                  ),
                  Center(
                    child: Text(
                      "${(accuracy*100).round()}%",
                      style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                    )
                  ),
                ]
              ),
            ),
            const Spacer(flex: 1,),
            Center(
              child: Row(
                children: [
                  const Spacer(),
                  Column(
                    children: [
                      buildTextWithStyle("총 시간", Colors.grey),
                      buildTextWithStyle("평균 시간", Colors.grey),
                      const SizedBox(height: 20,),
                      buildTextWithStyle("총 카드 수", Colors.grey),
                      buildTextWithStyle("맞은 카드 수", Colors.green),
                      buildTextWithStyle("틀린 카드 수", Colors.red),
                    ],
                  ),
                  const SizedBox(width: 30),
                  Column(
                    children: [
                      buildTextWithStyle("${widget.totalTime}", Colors.grey),
                      buildTextWithStyle("${(widget.totalTime/(widget.rightCount+widget.wrongCount)).round()}", Colors.grey),
                      const SizedBox(height: 20,),
                      buildTextWithStyle("${widget.rightCount+widget.wrongCount}", Colors.grey),
                      buildTextWithStyle("${widget.rightCount}", Colors.green),
                      buildTextWithStyle("${widget.wrongCount}", Colors.red),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Spacer(flex: 1,),
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.all(5),
              child: ElevatedButton(
                onPressed: () {
                  moveToDeckListScreen();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  elevation: 4.0,
                ),
                child: const Text(
                  '덱으로 돌아가기',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.all(5),
              child: OutlinedButton(
                onPressed: () {
                  restartLearn();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  elevation: 4.0,
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  '다시 학습',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }

  Widget buildTextWithStyle(String content, Color color) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Text(
        content,
        style: TextStyle(
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void saveHistory() {
    postHistoryDB(widget.deckId, widget.totalTime, accuracy);
  }

  void moveToDeckListScreen() {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => DeckListScreen()
      ),
    );
  }

  void restartLearn() {

  }
}

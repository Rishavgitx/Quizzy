import 'package:flutter/material.dart';

class ResultsScreen extends StatefulWidget {
  final int correctCount;
  final int totalQuestions;
  final int wrongCount;
  final List<Map<String, dynamic>> questionList;
  final List<Map<String, dynamic>> userAnswers;

  const ResultsScreen({
    required this.correctCount,
    required this.totalQuestions,
    required this.wrongCount,
    required this.questionList,
    required this.userAnswers,
  });

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late int skippedCount;

  @override
  void initState() {
    super.initState();
    skippedCount = widget.totalQuestions - widget.correctCount - widget.wrongCount;
  }

  String getSummaryMessage() {
    double percentage = (widget.correctCount / widget.totalQuestions) * 100;
    if (percentage >= 70) {
      return 'Great job! You did well!';
    } else if (percentage >= 40) {
      return 'Not bad! You can improve!';
    } else {
      return 'Keep practicing! You can do better!';
    }
  }

  IconData getSummaryIcon() {
    double percentage = (widget.correctCount / widget.totalQuestions) * 100;
    if (percentage >= 70) {
      return Icons.check; // Icon for great job
    } else if (percentage >= 40) {
      return Icons.my_library_books_sharp; // Icon for not bad
    } else {
      return Icons.error; // Icon for keep practicing
    }
  }

  List<Widget> buildQuestionResults() {
    List<Widget> questionResults = [];
    for (int i = 0; i < widget.totalQuestions; i++) {
      final question = widget.questionList[i];
      final userAnswer = i < widget.userAnswers.length ? widget.userAnswers[i]['Selected Answer'] : null;
      final correctAnswer = question['Correct Answer'];
      bool isCorrect = userAnswer == correctAnswer;
      bool isSkipped = userAnswer == null;

      questionResults.add(
        ListTile(
          leading: Icon(
            isCorrect ? Icons.check : (isSkipped ? Icons.not_interested : Icons.close),
            color: isCorrect ? Colors.green : (isSkipped ? Colors.blue[900] : Colors.red),
          ),
          title: Text(
            question['Question'] ?? '',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              if (isSkipped)
                Text(
                  'Skipped',
                  style: TextStyle(
                    color: Colors.blue[900],
                  ),
                )
              else
                Text(
                  'Your Answer: $userAnswer',
                  style: TextStyle(
                    color: userAnswer == correctAnswer ? Colors.green : Colors.red,
                  ),
                ),
              SizedBox(height: 5),
              Text(
                'Correct Answer: $correctAnswer',
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),
        ),
      );
      questionResults.add(Divider(thickness: 2, color: Colors.grey)); // Add a line break
    }
    return questionResults;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results'),
        elevation: 0,
        backgroundColor: Color(0xFFFF8800),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3 - 7,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFF8800), Colors.white], // Specify the gradient colors here
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.translate(
                        offset: Offset(0, -100),
                        child: Card(
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${widget.correctCount} ',
                                          style: TextStyle(fontSize: 25, color: Colors.green[900], fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Correct ',
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 95),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ' ${widget.totalQuestions} ',
                                          style: TextStyle(fontSize: 25, color: Colors.orange[900], fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Total Questions',
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ' ${widget.wrongCount} ',
                                          style: TextStyle(fontSize: 25, color: Colors.red[900], fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Wrong ',
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 99),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ' $skippedCount ',
                                          style: TextStyle(fontSize: 25, color: Colors.blue[900], fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Skipped ',
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -70),
                        child: Column(
                          children: [
                            Text(
                              'Summary:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    getSummaryIcon(),
                                    size: 50,
                                    color: Colors.blue, // Adjust the color as needed
                                  ),
                                  Text(
                                    getSummaryMessage(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Transform.translate(
                          offset: Offset(0, -20),
                          child: Expanded(
                            child: Card(
                              elevation: 0,
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Question Results:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Expanded(
                                    // Add an Expanded widget
                                    child: Container(
                                      height: 200, // Adjust the height as needed
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: buildQuestionResults(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

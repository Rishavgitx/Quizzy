import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shimmer/shimmer.dart';
import 'Timer.dart';
import 'package:flutter/services.dart';
import 'ResultScreen.dart';

class QuestionScreen extends StatefulWidget {
  final String groupKey;

  const QuestionScreen({required this.groupKey, Key? key}) : super(key: key);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  late DatabaseReference dbRef;
  List<Map<String, dynamic>> questionList = [];
  int currentIndex = 0; // Track the index of the current question
  int correctCount = 0;
  int wrongCount = 0;
  List<Map<String, dynamic>> userAnswers = []; // Add this line


  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance
        .reference()
        .child('Questions')
        .child(widget.groupKey);

    // Fetch questions from Firebase
    dbRef.once().then((DatabaseEvent snapshot) {
      Map<dynamic, dynamic>? data =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;
      print(
          'Data from Firebase: $data'); // Add this line to check the retrieved data
      if (data != null) {
        data.forEach((key, value) {
          setState(() {
            questionList
                .add(Map<String, dynamic>.from(value as Map<dynamic, dynamic>));
          });
        });
        print(
            'Question List: $questionList'); // Add this line to check the populated questionList
      }
    });
  }

  void showNextQuestion() {
    setState(() {
      if (currentIndex < questionList.length - 1) {
        currentIndex++;
      } else {
        showResults();
      }
    });
  }

  void checkAnswer(String selectedAnswer) {
    final correctAnswer = questionList[currentIndex]['Correct Answer'];

    if (selectedAnswer == correctAnswer) {
      setState(() {
        correctCount++;
      });
      showNextQuestion();
    } else {
      showNextQuestion();
      setState(() {
        wrongCount++; //
      });
      HapticFeedback.heavyImpact();
      HapticFeedback.vibrate();
      Future.delayed(Duration(milliseconds: 500), () {
        HapticFeedback.vibrate();
      });
    }
      userAnswers.add({
    'Question': questionList[currentIndex]['Question'],
    'Selected Answer': selectedAnswer,
    'Correct Answer': correctAnswer,
  });
  }
  void showResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          questionList: questionList,
          userAnswers: userAnswers,
          correctCount: correctCount,
          totalQuestions: questionList.length,
          wrongCount: wrongCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA42FC1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: questionList.isEmpty // Check if questionList is empty
          ? Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3 - 7,
                      decoration: BoxDecoration(
                        color: Color(0xFFA42FC1),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                    ),
                    SizedBox(height: 300), // Adjust the size as needed
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child:Expanded(child:
                        Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 20),
                                Container(
                                  width: 40,
                                  height: 20,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 230),
                                Container(
                                  width: 40,
                                  height: 20,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Container(
                              width: double.infinity,
                              height: 20,
                              color: Colors.white,
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              height: 40,
                              color: Colors.white,
                            ),
                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3 - 7,
                      decoration: BoxDecoration(
                        color: Color(0xFFA42FC1),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * .45 -
                      300, // Adjust the top position as needed
                  left: 30,
                  right: 30,
                  child: Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                " $correctCount",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(width: 5),
                              SizedBox(
                                width: 40,
                                height: 10,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  // Adjust the radius value as needed
                                  child: LinearProgressIndicator(
                                    value: correctCount / questionList.length,
                                    backgroundColor: Colors.transparent,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.lightGreen),
                                  ),
                                ),
                              ),
                              SizedBox(width: 170),
                              SizedBox(
                                width: 40,
                                height: 10,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: RotationTransition(
                                    turns: AlwaysStoppedAnimation(0.5),
                                    // Adjust the value to control the rotation (0.5 means 180 degrees)
                                    child: LinearProgressIndicator(
                                      value: wrongCount / questionList.length,
                                      backgroundColor: Colors.transparent,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                " $wrongCount",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          Text(
                            'Question ${currentIndex + 1}/${questionList.length}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.lightGreen,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            questionList[currentIndex]['Question'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * .45 -
                      330, // Adjust the top position as needed
                  left: 30,
                  right: 30,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: TweenAnimationBuilder(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(seconds: 30),
                        builder: (context, value, _) => SizedBox(
                          height: 72,
                          width: 72,
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 72,
                                width: 72,
                                child: CircularProgressIndicator(
                                  value: value,
                                  strokeWidth: 8,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: TimerWidget(
                                    showNextQuestionCallback: showNextQuestion,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 220),
                      ElevatedButton(
                        onPressed: () =>
                            checkAnswer(questionList[currentIndex]['Option1']),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFD61A3C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          minimumSize: Size(310,
                              70), // Adjust the width and height as desired
                        ),
                        child: Text(
                          questionList[currentIndex]['Option1'] ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () =>
                            checkAnswer(questionList[currentIndex]['Option2']),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF0954E8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          minimumSize: Size(310,
                              70), // Adjust the width and height as desired
                        ),
                        child: Text(
                          questionList[currentIndex]['Option2'] ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () =>
                            checkAnswer(questionList[currentIndex]['Option3']),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFF9C70C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          minimumSize: Size(310,
                              70), // Adjust the width and height as desired
                        ),
                        child: Text(
                          questionList[currentIndex]['Option3'] ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () =>
                            checkAnswer(questionList[currentIndex]['Option4']),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF07A512),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          minimumSize: Size(310,
                              70), // Adjust the width and height as desired
                        ),
                        child: Text(
                          questionList[currentIndex]['Option4'] ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

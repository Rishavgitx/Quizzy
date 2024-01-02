import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'PreviousQuestion.dart';
import 'GradientBorderPainter.dart';

class Teacher extends StatefulWidget {
  const Teacher({Key? key}) : super(key: key);

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {

  String OPTION1 = 'Option 1';
  String OPTION2 = 'Option 2';
  String OPTION3 = 'Option 3';
  String OPTION4 = 'Option 4';
  final questionController = TextEditingController();
  final option1Controller = TextEditingController();
  final option2Controller = TextEditingController();
  final option3Controller = TextEditingController();
  final option4Controller = TextEditingController();
  late String selectedOption;

  late DatabaseReference dbRef;
  String? warningMessage;
  List<Map<String, dynamic>> questionList = []; // Added questionList variable



  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.reference().child('Questions');
    selectedOption = OPTION1; // Set initial selected option
  }

  @override
  void dispose() {
    questionController.dispose();
    option1Controller.dispose();
    option2Controller.dispose();
    option3Controller.dispose();
    option4Controller.dispose();
    super.dispose();
  }


  void submitForm() {
    if (_validateFields()) {
      String correctOption = selectedOption; // Assign selectedOption to correctOption
      if (selectedOption == OPTION1) {
        correctOption = option1Controller.text;
      } else if (selectedOption == OPTION2) {
        correctOption = option2Controller.text;
      } else if (selectedOption == OPTION3) {
        correctOption = option3Controller.text;
      } else if (selectedOption == OPTION4) {
        correctOption = option4Controller.text;
      }

      Map<String, dynamic> question = {
        'Question': questionController.text,
        'Option1': option1Controller.text,
        'Option2': option2Controller.text,
        'Option3': option3Controller.text,
        'Option4': option4Controller.text,
        'Correct Answer': correctOption,
      };

      questionList.add(question);

      questionController.clear();
      option1Controller.clear();
      option2Controller.clear();
      option3Controller.clear();
      option4Controller.clear();
      setState(() {
        warningMessage = null;
      });
    } else {
      setState(() {
        warningMessage = 'Please fill in all fields.';
      });
    }
  }

  void submitAllQuestions() {
    if (questionList.isNotEmpty) {
      String key = generateKey(); // Generate a key
      for (var question in questionList) {
        dbRef
            .child(key)
            .push()
            .set(question); // Use the generated key as the child node
      }
      questionList.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All questions submitted successfully')),
      );

      // Display the generated key to the teacher
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: <Widget>[
                SizedBox(width: 60),
                Text('Test Key'),
                SizedBox(width: 20),
                Image.asset(
                  'icons/icon/alert (1).png',
                  height: 34,
                  width: 34,
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Share the following key with students: $key'),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      width: double.infinity, // Adjust the width as needed
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.green], // Adjust the colors as needed
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No questions to submit')),
      );
    }
  }

  String generateKey() {
    final random = Random();
    const int keyLength = 6;
    const String chars = '0123456789';
    String key = '';

    for (int i = 0; i < keyLength; i++) {
      key += chars[random.nextInt(chars.length)];
    }

    return key;
  }
  void deleteData() {
    dbRef.remove().then((_) {
      setState(() {
        questionController.clear();
        option1Controller.clear();
        option2Controller.clear();
        option3Controller.clear();
        option4Controller.clear();
        selectedOption = OPTION1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data deleted successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete data: $error')),
      );
    });
  }

  bool _validateFields() {
    return questionController.text.isNotEmpty &&
        option1Controller.text.isNotEmpty &&
        option2Controller.text.isNotEmpty &&
        option3Controller.text.isNotEmpty &&
        option4Controller.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00CC66),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Questions',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CustomPaint(
                            painter: GradientBorderPainter(
                              gradientColors: [
                                Color(0xFF00CC66),
                                Color(0xFFA2FFC4)
                              ], // Gradient colors for the border
                              strokeWidth: 5.0,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextField(
                                controller: questionController,
                                decoration: InputDecoration(
                                  hintText: 'Type your question here.....',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Option 1:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CustomPaint(
                                painter: GradientBorderPainter(
                                  gradientColors: [
                                    Color(0xFFD61A3C),
                                    Color(0xFFFF9999)
                                  ], // Gradient colors for the border
                                  strokeWidth: 5.0,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: TextField(
                                    controller: option1Controller,
                                    decoration: InputDecoration(
                                      hintText: 'Type your option here',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Option 2
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Option 2:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CustomPaint(
                                painter: GradientBorderPainter(
                                  gradientColors: [
                                    Color(0xFF0954E8),
                                    Color(0xFF6CBBF9)
                                  ], // Gradient colors for the border
                                  strokeWidth: 5.0,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: TextField(
                                    controller: option2Controller,
                                    decoration: InputDecoration(
                                      hintText: 'Type your option here',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Option 3:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CustomPaint(
                                painter: GradientBorderPainter(
                                  gradientColors: [
                                    Color(0xFFFF9900),
                                    Color(0xFFF9C70C)
                                  ], // Gradient colors for the border
                                  strokeWidth: 5.0,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: TextField(
                                    controller: option3Controller,
                                    decoration: InputDecoration(
                                      hintText: 'Type your option here',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Option 2
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Option 4:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CustomPaint(
                                painter: GradientBorderPainter(
                                  gradientColors: [
                                    Color(0xFF285D34),
                                    Color(0xFFAED581)
                                  ], // Gradient colors for the border
                                  strokeWidth: 5.0,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: TextField(
                                    controller: option4Controller,
                                    decoration: InputDecoration(
                                      hintText: 'Type your option here',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Correct Option:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(width: 45),
                      DropdownButton<String>(
                        value: selectedOption,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedOption = newValue!;
                          });
                        },
                        items: <String>[
                          OPTION1,
                          OPTION2,
                          OPTION3,
                          OPTION4,
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: submitForm,
                    child: Text('Next'),
                  ),
                ),

                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PreviousQuestions(
                            questionList: questionList,
                          ),
                        ),
                      );
                    },
                    child: Text('View Previous Questions'),
                  ),
                ),
                if (warningMessage != null)
                  Text(
                    warningMessage!,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: submitAllQuestions,
                    // New button to submit all questions
                    child: Text('Submit All Questions'),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: deleteData,
                    child: const Text(
                      'Delete Data',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

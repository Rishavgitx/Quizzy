import 'package:flutter/material.dart';

class PreviousQuestions extends StatefulWidget {
  final List<Map<String, dynamic>> questionList;

  const PreviousQuestions({Key? key, required this.questionList}) : super(key: key);

  @override
  _PreviousQuestionsState createState() => _PreviousQuestionsState();
}

class _PreviousQuestionsState extends State<PreviousQuestions> {
  void deleteQuestion(int index) {
    setState(() {
      widget.questionList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Questions'),
      ),
      body: ListView.builder(
        itemCount: widget.questionList.length,
        itemBuilder: (context, index) {
          final question = widget.questionList[index];
          final questionText = question['Question'];
          final option1 = question['Option1'];
          final option2 = question['Option2'];
          final option3 = question['Option3'];
          final option4 = question['Option4'];
          final correctOption = question['Correct Answer'];

          return Card(
            child: ListTile(
              title: Text(questionText),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Option 1: $option1'),
                  Text('Option 2: $option2'),
                  Text('Option 3: $option3'),
                  Text('Option 4: $option4'),
                  Text('Correct Answer: $correctOption'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Call the deleteQuestion function when the delete button is pressed
                  deleteQuestion(index);

                  // Update the UI by rebuilding the widget
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Question deleted'),
                    ),
                  );

                  // You can also perform any additional actions or update Firebase here
                },
              ),
            ),
          );
        },
      ),
    );
  }
}


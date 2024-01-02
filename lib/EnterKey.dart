import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'QuestionScreen.dart';

class EnterKey extends StatefulWidget {
  @override
  _EnterKeyState createState() => _EnterKeyState();
}

class _EnterKeyState extends State<EnterKey> {
  late String enteredKey;
  final FocusNode _focusNode = FocusNode();
  bool shouldShowButton = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _focusNode.unfocus();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              _focusNode.unfocus();
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 22),
              Expanded(child:

              Container(
                width: double.infinity,
                height: 250.0,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Image.asset(
                          'icons/icon/numeric.png',
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(height: 50),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                enteredKey = value;
                                shouldShowButton = value.length >= 6;
                              });
                            },
                            focusNode: _focusNode,
                            keyboardType: TextInputType.number,
                            showCursor: false,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              FilteringTextInputFormatter.deny(RegExp('[\\ ]')),
                            ],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'KEY',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'FontMain1',
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ),
              const SizedBox(height: 16.0),
              if (shouldShowButton)
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size(150, 50)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.indigoAccent),
                  ),
                  onPressed: () {
                    checkIfValidKey(enteredKey);
                  },
                  child: Text('Submit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void checkIfValidKey(String key) {
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('Questions').child(key);

    dbRef.once().then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionScreen(groupKey: enteredKey),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            content: Text('Invalid key. Please enter a valid key.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }
}

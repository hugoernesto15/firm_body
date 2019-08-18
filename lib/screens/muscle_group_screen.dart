import 'package:flutter/material.dart';
import 'package:firm_body_flutter/services/constants.dart';
import 'package:firm_body_flutter/screens/detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MuscleGroupPage extends StatefulWidget {
  MuscleGroupPage({this.path, this.firestore});

  final String path;
  final Firestore firestore;

  @override
  _MuscleGroupPageState createState() => _MuscleGroupPageState();
}

class _MuscleGroupPageState extends State<MuscleGroupPage> {
  Future _data;
  Firestore _firestore;
  TextEditingController _textFieldController = TextEditingController();

  Future _getExercises(String path) async {
    QuerySnapshot exercises = await _firestore.collection(path).getDocuments();
    return exercises.documents;
  }

  Future _addWorkout(String exerciseName) async {
    await _firestore.collection(widget.path).add({'exercises': exerciseName});
    _data = _getExercises(widget.path);
    setState(() {});
  }

  _showDisplayDialog(BuildContext context) {
    String exerciseTyped;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New Exercise'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Exercise Name"),
              onChanged: (value) {
                exerciseTyped = value;
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('ADD'),
                onPressed: () {
                  _addWorkout(exerciseTyped);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    print(widget.path);
    _firestore = widget.firestore;
    _data = _getExercises(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          _showDisplayDialog(context);
        },
        backgroundColor: Colors.tealAccent,
      ),
      appBar: AppBar(
        title: Text(
          'Firm Body',
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Loading...'),
              );
            } else {
              return ListView.builder(
                padding: EdgeInsets.only(bottom: 2.0),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 100,
                      color: listColor[index],
                      child: Center(
                        child: Text(
                          snapshot.data[index].data["exercises"],
                          style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w200),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

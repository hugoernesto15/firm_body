import 'package:flutter/material.dart';
import 'package:firm_body_flutter/services/constants.dart';
import 'package:firm_body_flutter/screens/muscle_group_screen.dart';
import 'package:firm_body_flutter/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isEmailVerified = false;
  Future _data;
  final Firestore _firestore = Firestore.instance;

  List<String> muscleGroups = [
    'Forearms',
    'Chest',
    'Shoulders',
    'Legs',
    'Triceps',
    'Biceps',
    'Lower Back',
    'Upper Back'
  ];

  Map<String, List<String>> initialExercises = {
    'Forearms': ['Forearm exercise'],
    'Chest': ['Flat Bench Press', 'Inclined Bench Press', 'Flyers'],
    'Shoulders': ['Military Press', 'Back Military Press', 'Lateral Raises'],
    'Legs': ['Squad'],
    'Triceps': ['Scull Crusher', 'Dumbell Kickbcack'],
    'Biceps': ['Concentration Curl', 'Bar Curl', 'Reverse Curl'],
    'Lower Back': ['Dead Lift'],
    'Upper Back': [
      'Lateral Pull Down',
      'Back Lateral Pull Down',
      'Supine Narrow Pull Down'
    ],
  };

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  Future _getExercises() async {
    QuerySnapshot musclesGroups = await _firestore
        .collection("users/${widget.userId}/muscleGroups")
        .getDocuments();
    return musclesGroups.documents;
  }

  void _createUserDocument() async {
    DocumentSnapshot sp =
        await _firestore.collection("users").document(widget.userId).get();
    print(sp.data);
    if (sp.data == null) {
      await _firestore
          .collection("users")
          .document(widget.userId)
          .setData({'userID': widget.userId});
      for (var muscleGroup in initialExercises.keys.toList()) {
        _firestore
            .collection("users/${widget.userId}/muscleGroups")
            .document(muscleGroup)
            .setData({'muscleGroup': muscleGroup});
        for (var exercise in initialExercises[muscleGroup]) {
          _firestore
              .collection(
                  "users/${widget.userId}/muscleGroups/$muscleGroup/exercises")
              .document(exercise)
              .setData({'exercises': exercise});
        }
      }
    } else {
      print('user ${widget.userId} already exists');
    }
  }

  Future navigateToExercises(String muscleGroup) async {
    String path = "users/${widget.userId}/muscleGroups/$muscleGroup/exercises";
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MuscleGroupPage(
                  path: path,
                  firestore: _firestore,
                )));
  }

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
    _createUserDocument();
    _data = _getExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.close), onPressed: _signOut)
        ],
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
                      navigateToExercises(
                          snapshot.data[index].data["muscleGroup"]);
                    },
                    child: Container(
                      height: 100,
                      color: listColor[index],
                      child: Center(
                        child: Text(
                          snapshot.data[index].data["muscleGroup"],
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

import 'package:flutter/material.dart';
import 'package:firm_body_flutter/services/constants.dart';

class NewEntryPage extends StatefulWidget {
  final String exercise;
  NewEntryPage({this.exercise});

  @override
  _NewEntryPageState createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  String exType;
  String exWeight;
  String exUnit;
  String repSeries;
  String reps;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                exWeight = value;
              },
              decoration: kInputDecoration.copyWith(hintText: 'Add Weight'),
            ),
            SizedBox(
              height: 50,
            ),
            MaterialButton(
                child: Text('Update'),
                color: Colors.red,
                elevation: 30,
                onPressed: () {})
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firm_body_flutter/screens/new_entry.dart';

class DetailPage extends StatefulWidget {
//  DetailPage({this.exercise});
//  final DocumentSnapshot exercise;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String exType = 'Olympic';
  String exWeight = '80';
  String exUnit = 'lb';
  String repSerie = '4';
  String reps = '10';

  navigateToEditPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewEntryPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HARDCORDED'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                navigateToEditPage();
              })
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      exType,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          exWeight,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 100.0,
                              fontWeight: FontWeight.w900),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          exUnit,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w100),
                        )
                      ],
                    ),
                    Text(
                      'Weight',
                      style: TextStyle(fontWeight: FontWeight.w200),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0),
              child: Divider(
                color: Colors.white,
                height: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          repSerie,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 100.0,
                              fontWeight: FontWeight.w900),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'x',
                          style: TextStyle(
                              fontSize: 50.0, fontWeight: FontWeight.w100),
                        ),
                        Text(
                          reps,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 100.0,
                              fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                    Text(
                      'Repetitions',
                      style: TextStyle(fontWeight: FontWeight.w200),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

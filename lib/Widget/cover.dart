import 'package:flutter/material.dart';

class Cover extends StatefulWidget {
  const Cover({Key key}) : super(key: key);

  @override
  _CoverState createState() => _CoverState();
}

class _CoverState extends State<Cover> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.lightBlue, Colors.blue])),
      child: Image(
        image: AssetImage("assets/cover.jpg"),
        fit: BoxFit.cover,
      ),
    );
  }
}

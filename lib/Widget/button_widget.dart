import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key key,
    this.text,
    this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(30.0),
            primary: Colors.green,
            elevation: 10.0),
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
        onPressed: onClicked,
      );
}

import 'dart:io';

import 'package:accounter/pages/extractpage.dart';

import 'package:flutter/material.dart';

class ShowImage extends StatefulWidget {
  final File imported;

  const ShowImage({Key key, this.imported}) : super(key: key);

  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Your Image"),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                //onPrimary: Color(0xfe5e5e5),
                primary: Colors.blue[900],
                elevation: 0.0),
            child: Icon(
              Icons.done,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ExtractPage(
                          imported: widget.imported,
                        )),
              );
            },
          )
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
            child: Center(
              child: Container(
                child: Image.file(
                  File(widget.imported.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

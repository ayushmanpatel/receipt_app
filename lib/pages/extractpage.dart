import 'dart:async';
import 'dart:io';

import 'package:accounter/Widget/submitbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class ExtractPage extends StatefulWidget {
  const ExtractPage({Key key, this.imported}) : super(key: key);
  final File imported;
  @override
  _ExtractPageState createState() => _ExtractPageState();
}

class _ExtractPageState extends State<ExtractPage> {
  bool _isloading;
  List<String> textList;
  var textRecognizer = GoogleMlKit.vision.textDetector();
  var entityExtractor =
      GoogleMlKit.nlp.entityExtractor(EntityExtractorOptions.ENGLISH);
  final _languageModelManager = GoogleMlKit.nlp.entityModelManager();

  Future<void> getAvailableModels() async {
    await _languageModelManager.getAvailableModels();
    //print('Available models: $result');
  }

  var upiId = "loading...";
  var timedate = "loading...";

  @override
  void initState() {
    super.initState();
    _isloading = false;
    textList = [];
    getAvailableModels();
    displayText();
  }

  displayText() async {
    RecognisedText recognisedText = await textRecognizer
        .processImage(InputImage.fromFilePath(widget.imported.path));
    bool isDateTimegot = false;
    bool isUpiIdgot = false;
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        //print(line.text);
        textList.add(line.text);
        var result = await entityExtractor.extractEntities(line.text);
        result.forEach((element) {
          var elementtype = element.entities.toString();
          if (elementtype == "[DateTimeEntity{type=2}]" ||
              element.text.contains(RegExp(
                  r'^(?=\d)(?:(?:31(?!.(?:0?[2469]|11))|(?:30|29)(?!.0?2)|29(?=.0?2.(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00)))(?:\x20|$))|(?:2[0-8]|1\d|0?[1-9]))([-./])(?:1[012]|0?[1-9])\1(?:1[6-9]|[2-9]\d)?\d\d(?:(?=\x20\d)\x20|$))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\x20[AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$'))) {
            if (element.text.contains(DateTime.march.toString()) ||
                element.text.contains(DateTime.january.toString()) ||
                element.text.contains(DateTime.february.toString()) ||
                element.text.contains(DateTime.april.toString()) ||
                element.text.contains(DateTime.may.toString()) ||
                element.text.contains(DateTime.june.toString()) ||
                element.text.contains(DateTime.july.toString()) ||
                element.text.contains(DateTime.august.toString()) ||
                element.text.contains(DateTime.september.toString()) ||
                element.text.contains(DateTime.october.toString()) ||
                element.text.contains(DateTime.november.toString()) ||
                element.text.contains(DateTime.december.toString())) {
              timedate = line.text;
              //print(line.text);
              isDateTimegot = true;
            }
          }
        });
        for (TextElement word in line.elements) {
          //print(word.text);
          if (word.text.startsWith("UTR:")) {
            upiId = word.text;
            upiId = upiId.substring(4, upiId.length);
            isUpiIdgot = true;
          } else if ((word.text.contains(RegExp('[0-9]'))) &&
              word.text.length == 12.0) {
            upiId = word.text;
            isUpiIdgot = true;
          }
        }
      }
    }
    if (isUpiIdgot && isDateTimegot) {
      setState(() {
        _isloading = true;
      });
    } else {
      Timer(Duration(seconds: 5), () {
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                const AlertDialog(title: Text('Unable To Fetch Credentials')));
      });
      setState(() {
        _isloading = false;
      });
    }
  }

  TextStyle textStyle = TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
  @override
  void dispose() {
    entityExtractor.close();
    super.dispose();
  }

  final userid = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text("Transaction Details"),
        ),
        body: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    height: 240.0,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        ColoredBox(
                          color: Colors.blue[900],
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            height: 40.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "UID:001",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Divider(
                                    height: 10.0,
                                  ),
                                  Text("UPI Reference ID"),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    height: 38.0,
                                    width: 190.0,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: _isloading
                                        ? Text(
                                            upiId,
                                            style: textStyle,
                                          )
                                        : LinearProgressIndicator(
                                            backgroundColor: Colors.blue[900],
                                          ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text("Date and Time"),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                      height: 32.0,
                                      width: 190.0,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: _isloading
                                          ? Text(
                                              timedate,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : LinearProgressIndicator(
                                              minHeight: 20.0,
                                              backgroundColor: Colors.blue[900],
                                            )),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await await showDialog(
                                          context: context,
                                          builder: (_) => Dialog(
                                                backgroundColor:
                                                    Colors.blue[900],
                                                child: Card(
                                                  child: Image.file(
                                                    File(widget.imported.path),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ));
                                    },
                                    child: Container(
                                        height: 135.0,
                                        width: 110.0,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black,
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.center,
                                                colors: [
                                                  Colors.black,
                                                  Colors.black12
                                                ])),
                                        child: Image.file(
                                          File(
                                            widget.imported.path,
                                          ),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "More Info",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[600]),
                                      ),
                                      Icon(Icons.keyboard_arrow_up)
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))),
            _isloading
                ? SubmitButton(
                    userid: userid,
                    upiId: upiId,
                    timedate: timedate,
                    refimg: widget.imported,
                  )
                : CircularProgressIndicator(
                    strokeWidth: 7.0,
                    backgroundColor: Colors.blue[900],
                  )
          ],
        ));
  }
}

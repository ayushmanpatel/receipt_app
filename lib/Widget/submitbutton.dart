import 'package:accounter/pages/homepage.dart';
import 'package:accounter/provider/checkUpiId.dart';
import 'package:accounter/provider/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  const SubmitButton(
      {Key key, this.userid, this.upiId, this.timedate, this.refimg})
      : super(key: key);
  final userid, upiId, timedate, refimg;
  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool isuploaded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      child: ElevatedButton(
          onPressed: () async {
            setState(() {
              isuploaded = true;
            });
            final _storage = FirebaseStorage.instance;
            //final _firestore = FirebaseFirestore.instance;

            var _downloadurl;
            int docNum;
            var collection = FirebaseFirestore.instance
                .collection('kosh')
                .doc(widget.userid.uid)
                .collection('userData');
            var querySnapshots = await collection.get();
            if (querySnapshots.docs.isEmpty) {
              docNum = 1;
            } else {
              for (var snapshot in querySnapshots.docs) {
                docNum = snapshot.data()['docNumber'] + 1;
              }
            }

            if (widget.refimg != null) {
              //upload to firebase
              var snapshot = await _storage
                  .ref(widget.userid.uid)
                  .child("uploadedImage$docNum")
                  .putFile(widget.refimg);
              _downloadurl = await snapshot.ref.getDownloadURL();
            }
            bool isvalid = await CheckUpiId().checkUpiId(widget.upiId);
            await DatabaseService(uid: widget.userid.uid).updateUserData(
                widget.upiId, widget.timedate, _downloadurl, docNum, isvalid);

            await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        upiid: widget.upiId,
                        datetime: widget.timedate,
                        refimglink: _downloadurl,
                        userId: widget.userid,
                      )),
              (Route<dynamic> route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue[900],
          ),
          child: isuploaded
              ? CircularProgressIndicator()
              : Text(
                  "Submit",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
    );
  }
}

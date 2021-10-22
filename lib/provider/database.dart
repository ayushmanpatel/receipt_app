import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService {
  final String uid;
  DatabaseService({@required this.uid});

  final CollectionReference koshCollection =
      FirebaseFirestore.instance.collection('kosh');

  Future updateUserData(String _upiRefId, String paytime, String _imageurl,
      int _docNumber, bool isVerified) async {
    return await koshCollection
        .doc(uid)
        .collection('userData')
        .doc("Upload_$_docNumber")
        .set({
      'upiRefId': _upiRefId,
      'paytime': paytime,
      'imageurl': _imageurl,
      'docNumber': _docNumber,
      'isVerified': isVerified
    });
  }

  Future checkData() async {
    if (await koshCollection.doc(uid).collection('userData').get() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future deleteUserData(int docnum) async {
    return await koshCollection
        .doc(uid)
        .collection('userData')
        .doc("Upload_$docnum")
        .delete();
  }

  Future updateisverified(int docnum) async {
    return await koshCollection
        .doc(uid)
        .collection('userData')
        .doc("Upload_$docnum")
        .update({'isVerified': true});
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class CheckUpiId {
  final CollectionReference bankapi =
      FirebaseFirestore.instance.collection('bankapi');

  bool isvalid = false;
  Future<bool> checkUpiId(String _upiid) async {
    String currentUpiId = _upiid;
    //var collection = FirebaseFirestore.instance.collection('bankapi');
    var querySnapshots =
        await bankapi.where('id', isEqualTo: currentUpiId).get();
    for (var snapshot in querySnapshots.docs) {
      if (snapshot.get('id') == currentUpiId) {
        isvalid = true;
      } else {
        isvalid = false;
      }
    }
    return isvalid;
  }

  Future updateVerified(String _upiid) async {
    var docId;
    var querySnapshots = await bankapi.where('id', isEqualTo: _upiid).get();
    for (var snapshot in querySnapshots.docs) {
      docId = snapshot.id;
    }
    return await bankapi.doc(docId).update({'verified': true});
  }
}

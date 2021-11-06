import 'package:accounter/Widget/button_widget.dart';
import 'package:accounter/api/pdf_api.dart';
import 'package:accounter/api/pdf_invoice_api.dart';
import 'package:accounter/model/ReceiptInfo.dart';
import 'package:accounter/model/invoice.dart';
import 'package:accounter/model/schoolinfo.dart';
import 'package:accounter/provider/checkUpiId.dart';
import 'package:accounter/provider/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReceiptStatus extends StatefulWidget {
  const ReceiptStatus({Key key, this.upiid, this.refimglink, this.userId})
      : super(key: key);
  final upiid, refimglink, userId;
  @override
  _ReceiptStatusState createState() => _ReceiptStatusState();
}

class _ReceiptStatusState extends State<ReceiptStatus> {
  TextStyle textStyle = TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("kosh")
            .doc(widget.userId)
            .collection("userData")
            .orderBy("docNumber", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Center(child: Text('Something went wrong')),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return ListBody(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              handleClick(String value) {
                switch (value) {
                  case 'Delete':
                    DatabaseService(uid: widget.userId)
                        .deleteUserData(data['docNumber']);
                }
              }

              DateTime now = DateTime.now();
              bool isVerified = data['isVerified'];
              bool refresh = false;
              return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Material(
                    elevation: 10.0,
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.indigo,
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        height: 200.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 40.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.receipt_long_rounded,
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                      SizedBox(width: 4.0),
                                      Text(
                                        'Reg-0${data['docNumber']}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                    ),
                                    color: Colors.redAccent,
                                    onSelected: handleClick,
                                    itemBuilder: (BuildContext context) {
                                      return {'Delete'}.map((String choice) {
                                        return PopupMenuItem<String>(
                                          value: choice,
                                          child: Text(choice),
                                        );
                                      }).toList();
                                    },
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              height: 0.0,
                              color: Colors.white,
                              thickness: 1.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0, vertical: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Upi Ref Id : ${data['upiRefId']}",
                                        maxLines: 1,
                                        softWrap: true,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        "Date : ${now.day}-${now.month}-${now.year}",
                                        maxLines: 1,
                                        softWrap: true,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      isVerified
                                          ? Text(
                                              "Paid : ₹ ${data['amount']}",
                                              maxLines: 1,
                                              softWrap: true,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.white),
                                            )
                                          : Text(
                                              "Paid : ₹ - - - - - -",
                                              maxLines: 1,
                                              softWrap: true,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.white),
                                            )
                                    ],
                                  ),
                                  GestureDetector(
                                      onTap: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (_) => Dialog(
                                                  backgroundColor:
                                                      Colors.blue[900],
                                                  child: Card(
                                                      child: Image(
                                                    image: NetworkImage(
                                                        data['imageurl']),
                                                    fit: BoxFit.cover,
                                                  )),
                                                ));
                                      },
                                      child: Container(
                                        width: 75.0,
                                        height: 75.0,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Image(
                                          image: NetworkImage(data['imageurl']),
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            isVerified
                                ? Container(
                                    width: 100.0,
                                    padding: EdgeInsets.all(0.0),
                                    child: ButtonWidget(
                                      text: 'Download',
                                      onClicked: () async {
                                        // final date = DateTime.now();
                                        // final dueDate = date.add(Duration(days: 7));

                                        final invoice = Invoice(
                                          schoolname: SchoolName(
                                            name: 'GIET UNIVERSITY',
                                            address:
                                                'At Gunupur,Rayagada 765022 , Odisha',
                                            contactInfo:
                                                'E-Mail : admin@giet.edu',
                                          ),
                                          receiptinfo: ReceiptInfo(
                                              name: widget.userId.displayName,
                                              pdfname:
                                                  'Reg-0${data['docNumber']}',
                                              amount: "${data['amount']}",
                                              paymode: "online",
                                              remarks: "Towards fees",
                                              reference: data["upiRefId"],
                                              time: data["paytime"]),
                                        );

                                        final pdfFile =
                                            await PdfInvoiceApi.generate(
                                                invoice);

                                        PdfApi.openFile(pdfFile);
                                      },
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Unable to fetch payment details",
                                        style:
                                            TextStyle(color: Colors.redAccent),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          bool isvalid = await CheckUpiId()
                                              .checkUpiId(data['upiRefId']);
                                          if (isvalid == true) {
                                            DatabaseService(uid: widget.userId)
                                                .updateisverified(
                                                    data['docNumber']);
                                          }
                                          setState(() {
                                            refresh = true;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            refresh
                                                ? CircularProgressIndicator()
                                                : Icon(
                                                    Icons.refresh_outlined,
                                                    color: Colors.white,
                                                  ),
                                            SizedBox(
                                              width: 6.0,
                                            ),
                                            Text(
                                              "Refresh",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                          ],
                        )),
                  ));
            }).toList(),
          );
        });
  }
}

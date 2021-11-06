import 'dart:io';
import 'package:accounter/Widget/displaystatus.dart';
import 'package:accounter/Widget/floatingbutttons.dart';
import 'package:accounter/Widget/profile.dart';
import 'package:accounter/pages/showImage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  final upiid, refimglink, userId;

  const HomePage({Key key, this.upiid, this.refimglink, this.userId})
      : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File pickedImage;
  var imageFile;
  ImagePicker _picker = ImagePicker();
  bool isImageLoaded = false;
  bool isCameraSelected;
  TextStyle textStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
  //final _languageModelManager = GoogleMlKit.nlp.entityModelManager();

  // @override
  // void initState() {
  //   super.initState();
  //   //isModelDownloaded();
  // }

  // Future<void> downloadModel() async {
  //   CircularProgressIndicator();
  //   await _languageModelManager.downloadModel(EntityExtractorOptions.ENGLISH,
  //       isWifiRequired: false);
  // }

  // Future<void> isModelDownloaded() async {
  //   var result = await _languageModelManager
  //       .isModelDownloaded(EntityExtractorOptions.ENGLISH);
  //   if (!result) {
  //     downloadModel();
  //   }
  // }

  Future getImageFromGallery() async {
    isCameraSelected = false;
    var tempStore = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    imageFile = await tempStore.readAsBytes();
    imageFile = await decodeImageFromList(imageFile);
    setState(() {
      pickedImage = File(tempStore.path);
      isImageLoaded = true;
      imageFile = imageFile;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ShowImage(
                  imported: pickedImage,
                )),
      );
    });
  }

  Future getImageFromCamera() async {
    isCameraSelected = true;
    var camstore = await _picker.pickImage(source: ImageSource.camera);
    imageFile = await camstore.readAsBytes();
    setState(() {
      pickedImage = File(camstore.path);
      isImageLoaded = true;
      imageFile = imageFile;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ShowImage(
                  imported: pickedImage,
                )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("FeePay"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (_) => Dialog(
                          clipBehavior: Clip.hardEdge,
                          child: Profile(),
                        ));
              },
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Image(
                  image: NetworkImage(user.photoURL),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: Row(
              children: [
                Text(
                  "Your Receipts",
                  style: textStyle,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Icon(Icons.receipt_long_rounded)
              ],
            ),
          ),
          Divider(
            color: Colors.blueGrey,
            indent: 10.0,
            endIndent: 10.0,
            thickness: 0.8,
          ),
          ReceiptStatus(
            refimglink: widget.refimglink,
            userId: user.uid,
            upiid: widget.upiid,
          )
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 82.0,
        children: [
          ActionButton(
            onPressed: () => getImageFromCamera(),
            icon: const Icon(Icons.camera_alt_outlined),
          ),
          ActionButton(
            onPressed: () => getImageFromGallery(),
            icon: const Icon(Icons.image),
          ),
        ],
      ),
    );
  }
}

import 'package:accounter/pages/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Profile extends StatelessWidget {
  const Profile({Key key}) : super(key: key);

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignUpPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user2 = FirebaseAuth.instance.currentUser;

    return Container(
      padding: EdgeInsets.all(10.0),
      height: 320.0,
      child: ListView(
        children: <Widget>[
          Center(
            child: Text(
              "Kosh Banks",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            thickness: 1.5,
          ),
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(user2.photoURL),
              ),
              SizedBox(
                width: 12.0,
              ),
              Text(user2.displayName,
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 12.0,
              ),
              Text("view profile",
                  style: TextStyle(fontSize: 14.0, color: Colors.blue[900])),
            ],
          ),
          Divider(
            thickness: 1.0,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 12.0,
              ),
              Icon(Icons.receipt_rounded),
              SizedBox(
                width: 20.0,
              ),
              Text("My Receipts",
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            ],
          ),
          Divider(
            thickness: 1.0,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 12.0,
              ),
              Icon(Icons.download_rounded),
              SizedBox(
                width: 20.0,
              ),
              Text("Downloads",
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            ],
          ),
          Divider(
            thickness: 1.0,
          ),
          ElevatedButton(
            onPressed: () async {
              final FirebaseAuth _auth = FirebaseAuth.instance;
              final googleSignIn = GoogleSignIn();
              await googleSignIn.signOut();
              await _auth.signOut();
              Navigator.of(context).pushReplacement(_routeToSignInScreen());
            },
            child: Text('Logout'),
          ),
          Divider(
            thickness: 1.0,
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(practice());
}

class practice extends StatefulWidget {
  practice({Key? key}) : super(key: key);

  @override
  _practiceState createState() => _practiceState();
}

class _practiceState extends State<practice> {
  bool show = false;
  bool login = false;

  List movienames = ['baaghi3', 'hero'];
  List directornames = ['bhushan', 'vikram'];
  TextEditingController moviename = TextEditingController();
  TextEditingController directorname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("movielist")),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 300,
              width: double.infinity,
              child: ListView.builder(
                  itemCount: movienames.length,
                  itemBuilder: (BuildContext context, int index) {
                    return moviecontainer(
                        movienames[index], directornames[index]);
                  }),
            ),
            login
                ? Center(
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            show = true;
                            login = true;
                          });
                        },
                        child: Container(
                          height: 30,
                          width: 80,
                          color: Colors.yellow,
                          child: Center(child: Text("Add movie")),
                        )))
                : Center(
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            initiateSignIn();
                          });
                        },
                        child: Container(
                          height: 30,
                          width: 100,
                          color: Colors.yellow,
                          child: Center(child: Text("Google login")),
                        ))),
            SizedBox(height: 40),
            (show & login)
                ? detailscontainer("moviename", moviename)
                : Text(""),
            SizedBox(height: 20),
            (show & login)
                ? detailscontainer("directorname", directorname)
                : Text(""),
            SizedBox(height: 50),
            (show & login)
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        movienames.add(moviename.text);
                        directornames.add(directorname.text);
                        show = false;
                      });
                    },
                    child: Container(
                      child: Center(
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.yellow),
                      width: double.infinity,
                      height: 40,
                      margin: EdgeInsets.only(right: 50, left: 50, bottom: 100),
                    ),
                  )
                : Text("")
          ],
        ),
      ),
    );
  }

  Widget detailscontainer(String text, TextEditingController control) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(color: Colors.grey)),
      width: 280,
      height: 40,
      margin: EdgeInsets.only(right: 50, left: 50),
      child: Row(
        children: [
          SizedBox(width: 20),
          Text(
            "",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          SizedBox(width: 15),
          Container(
              width: 200,
              height: 30,
              child: TextField(
                controller: control,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: text,
                  contentPadding: EdgeInsets.only(bottom: 17),
                  border: InputBorder.none,
                ),
              )),
        ],
      ),
    );
  }

  Widget moviecontainer(String Moviename, String Directorname) {
    return ListTile(
      title: Row(
        children: [
          SizedBox(
            width: 100,
            child: Image.network(
                "https://m.media-amazon.com/images/M/MV5BMTdjZTliODYtNWExMi00NjQ1LWIzN2MtN2Q5NTg5NTk3NzliL2ltYWdlXkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_SX300.jpg"),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Moviename:' + Moviename),
                  Text('Directorname:' + Directorname),
                  SizedBox(height: 5),
                  deletebutton(Moviename, Directorname)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget deletebutton(String movietype, String directortype) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      child: Center(
        child: IconButton(
          padding: EdgeInsets.all(5),
          icon: Icon(Icons.delete),
          color: Colors.white,
          onPressed: () {
            setState(() {
              movienames.remove(movietype);
              directornames.remove(directortype);
              show = false;
            });
          },
        ),
      ),
    );
  }

  Future<int> SocialhandleSignIn() async {
    var firebaseAuth = FirebaseAuth.instance;

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final user = await firebaseAuth.signInWithCredential(credential);

      return 1;
    } catch (error) {
      return 0;
    }

    return 0;
  }

  void initiateSignIn() {
    SocialhandleSignIn().then((result) {
      if (result == 1) {
        setState(() {
          show = true;
          login = true;
        });
      } else {
        setState(() {
          show = false;
          login = false;
        });
      }
    });
  }
}

import 'dart:convert';
import 'apidata.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(practice());
}

class practice extends StatefulWidget {
  practice({Key? key}) : super(key: key);

  @override
  _practiceState createState() => _practiceState();
}

class _practiceState extends State<practice> {
  bool isloading = true;

  List usernames = [];
  List companynames = [];

  void fetchdata() async {
    final response = await http.get(Uri.parse(
        "https://run.mocky.io/v3/f3feef1c-9bfa-43fd-b2a0-bbe9abadb4f6"));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      List username = [];
      List companyname = [];

      for (var u in result["clients"]) {
        var name = u["name"];
        var company = u["company"];
        username.add(name);
        companyname.add(company);
      }
      setState(() {
        usernames = username;
        isloading = false;
        companynames = companyname;
      });
    } else {
      throw Exception("failed to load");
    }
  }

  void initState() {
    fetchdata();
    isloading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              appBar: AppBar(title: Text("ListExample")),
              body: ListView.builder(
                  itemCount: usernames.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        height: 60,
                        margin: EdgeInsets.all(15),
                        child: Text(
                          "Name : " +
                              usernames[index] +
                              '\n' +
                              "Company : " +
                              companynames[index],
                          style: TextStyle(fontSize: 20),
                        ));
                  }),
            ),
    );
  }
}

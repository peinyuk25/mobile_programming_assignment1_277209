import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movie Searcher Application",
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MovieAppHome(title: 'Movie Seacher'),
    );
  }
}

class MovieAppHome extends StatefulWidget {
  const MovieAppHome({super.key, required this.title});
  final String title;

  @override
  State<MovieAppHome> createState() => _MovieAppState();
}

class _MovieAppState extends State<MovieAppHome> {
  String foundResult = "Search result will display here: ";

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Movie Searcher",
                    style: GoogleFonts.poppins(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    )),
                TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                      hintText: 'Input Movie Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                  style: const TextStyle(fontSize: 20),
                ),
                MaterialButton(
                  onPressed: () {
                    _getMovie(textEditingController.text);
                  },
                  color: Colors.teal,
                  child: const Text(
                    "Search Movie",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                // Image(image: NetworkImage(poster)),
                Text(
                  foundResult,
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  var poster = "";

  Future<void> _getMovie(String searchVideo) async {
    ProgressDialog dialog = ProgressDialog(context,
        message: const Text("Progressing..."), title: const Text("Searching"));
    dialog.show(); //loading dialogBox start

    //  apiid  = c8190544;
    var url =
        Uri.parse('https://www.omdbapi.com/?t=$searchVideo&apikey=c8190544');
    var response = await http.get(url);
    var rescode = response.statusCode;

    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);

      //poster = parsedJson['Poster'];

      setState(() {
        var title = parsedJson['Title'];
        var year = parsedJson['Year'];
        var country = parsedJson['Country'];
        var genre = parsedJson['Genre'];
        var plot = parsedJson['Plot'];

        foundResult = 'Title: $title\n'
            'Year Released: $year\n'
            'Genre: $genre\n'
            'Country: $country\n'
            'Plot: $plot\n';

        Fluttertoast.showToast(
          msg: "Result Found!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.teal,
          fontSize: 16.0,
        );
      });
    } else {
      setState(() {
        foundResult = "Please try again";
        Fluttertoast.showToast(
          msg: "Result is not found!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.teal,
          fontSize: 16.0,
        );
      });
    }
    dialog.dismiss(); //loading dialogBox end
  }
}

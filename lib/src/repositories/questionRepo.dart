import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:questionairre/src/models/question.dart';

//This is a dedicated class to deal with accessing our JSON file
class QuestionRepository {
  Questionairre questionairre;

  Future<void> loadQuestions() async {
    String jsonString;
    try {
      //Attempt to load a questions.json which isn't included in git because unknown copyrights
      jsonString = await rootBundle.loadString('assets/questions.json');
    } on FlutterError
    // It throws a FlutterError if it can't but also so do other flutter problems. May erraneously happen here!!!
    {
      print("Custom questions not found. loading example questions");
      jsonString = await rootBundle.loadString('assets/examplequestions.json');
    }
    questionairre = Questionairre.fromJson(jsonDecode(jsonString));
  }
}

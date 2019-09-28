import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:questionairre/src/models/question.dart';

class QuestionRepository {
  Questionairre questionairre;

  Future<void> loadQuestions() async {
    String jsonString;
    try {
      jsonString = await rootBundle.loadString('assets/questions.json');
    } on FlutterError {
      print("Custom questions not found. loading example questions");
      jsonString = await rootBundle.loadString('assets/examplequestions.json');
    }
    questionairre = Questionairre.fromJson(jsonDecode(jsonString));
  }
}

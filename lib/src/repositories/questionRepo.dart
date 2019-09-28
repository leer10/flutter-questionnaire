import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:questionairre/src/models/question.dart';

class QuestionRepository {
  Questionairre questionairre;

  Future<void> loadQuestions() async {
    String jsonString = await rootBundle.loadString('assets/questions.json');
    questionairre = Questionairre.fromJson(jsonDecode(jsonString));
  }
}

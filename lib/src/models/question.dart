import 'dart:convert';
//import 'dart:io'; // for running plain

import 'package:json_annotation/json_annotation.dart';
part 'question.g.dart';

@JsonSerializable()
class QuestionModel {
  String question;
  Map<Tendency, String> answers;

  QuestionModel({this.question, this.answers});

  @override
  String toString() {
    String tostring;
    tostring = "${this.question}\n";
    answers.forEach((Tendency tendency, String string) {
      tostring = tostring + "${tendency.toString()}: $string\n";
    });
    return tostring;
  }

  QuestionModel.example() {
    this.question = "This is a test question";
    this.answers = {
      Tendency.driver: "This is the answer for a driver",
      Tendency.amiable: "This is the answer for an amiable",
      Tendency.analytical: "This is the answer for an analytical",
      Tendency.expressive: "This is the answer for an expressive"
    };
  }

  QuestionModel.example2() {
    this.question = "This is a second test question";
    this.answers = {
      Tendency.driver: "This is the answer for a driver!",
      Tendency.amiable: "This is the answer for an amiable!",
      Tendency.analytical: "This is the answer for an analytical!",
      Tendency.expressive: "This is the answer for an expressive!"
    };
  }
  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Questionairre {
  List<QuestionModel> questions = [];
  Questionairre(this.questions);

  factory Questionairre.fromJson(Map<String, dynamic> json) =>
      _$QuestionairreFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionairreToJson(this);
}

enum Tendency { driver, amiable, analytical, expressive }

main() {
  /*
  // From first development, and generating first test JSON
  QuestionModel question = QuestionModel.example();
  print(question);
  print(
    question.toJson(),
  );
  QuestionModel question2 = QuestionModel.example2();
  Questionairre questionairre = Questionairre([question, question2]);
  print(
    questionairre.toJson(),
  );

  String jsonString = jsonEncode(questionairre.toJson());
  print("Printing to string");
  print(jsonString);
  print("DECODING FROM STRING");
  Questionairre questionairrefromjson =
      Questionairre.fromJson(jsonDecode(jsonString));
  print(questionairrefromjson.questions[0].question);
  */

  /*
  // For testing IO just as a one-shot
  String jsonDataString = File('./assets/questions.json').readAsStringSync();
  var jsonData = jsonDecode(jsonDataString);
  Questionairre questionairrefromJson = Questionairre.fromJson(jsonData);
  questionairrefromJson.questions
      .forEach((question) => print(question.question));
  */
}

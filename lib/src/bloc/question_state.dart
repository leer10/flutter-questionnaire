import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:questionairre/src/models/question.dart';

@immutable
abstract class QuestionState extends Equatable {
  QuestionState([List props = const <dynamic>[]]) : super(props);
}

class QuestionUninitalized extends QuestionState {
  @override
  String toString() => 'QuestionUninitalized';
}

class QuestionError extends QuestionState {
  @override
  String toString() => 'QuestionError';
}

class QuestionLoaded extends QuestionState {
  @override
  String toString() => 'QuestionLoaded';
  final QuestionModel questionmodel;
  final int totalQuestions;
  final int currentQuestion;

  QuestionLoaded(
      {this.questionmodel, this.totalQuestions, this.currentQuestion});
}

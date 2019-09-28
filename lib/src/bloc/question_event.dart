import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:questionairre/src/models/question.dart';

@immutable
abstract class QuestionEvent extends Equatable {
  QuestionEvent([List props = const <dynamic>[]]) : super(props);
}

class AnswerSubmitted extends QuestionEvent {
  @override
  String toString() => "Answer submitted";
}

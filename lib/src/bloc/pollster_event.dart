import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:questionairre/src/models/question.dart';

@immutable
abstract class PollsterEvent extends Equatable {
  PollsterEvent([List props = const <dynamic>[]]) : super(props);
}

class AppStarted extends PollsterEvent {
  @override
  String toString() => "App Started";
}

class QuestionsLoaded extends PollsterEvent {
  @override
  String toString() => "Questions Loaded";
}

class QuestionSubmitted extends PollsterEvent {
  final Tendency tendency;

  QuestionSubmitted({this.tendency}) : super([tendency]);

  @override
  String toString() => "Question Submitted";
}

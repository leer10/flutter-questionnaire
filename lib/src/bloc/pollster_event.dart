import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:questionairre/src/models/question.dart';

// See mapEventToState in pollster_bloc.dart for info on which does which
@immutable
abstract class PollsterEvent extends Equatable {
  PollsterEvent([List props = const <dynamic>[]]) : super();
}

class AppStarted extends PollsterEvent {
  @override
  String toString() => "App Started";

  @override
  List<Object> get props => [];
}

class ResumeResponse extends PollsterEvent {
  final bool wishToResume;
  ResumeResponse({this.wishToResume}) : super([wishToResume]);
  String toString() => "Resume response: $wishToResume";

  @override
  List<Object> get props => [wishToResume];
}

class LoadQuestions extends PollsterEvent {
  @override
  String toString() => "Loading Questions";

  @override
  List<Object> get props => [];
}

class QuestionSubmitted extends PollsterEvent {
  // This is the data (Amiable: 2, Driven: 3...) that comes from a submitted question
  final Map<Tendency, int> answers;

  QuestionSubmitted({this.answers}) : super([answers]);

  @override
  String toString() => "Question Submitted: $answers";

  @override
  List<Object> get props => [answers];
}

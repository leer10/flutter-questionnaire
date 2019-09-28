import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:questionairre/src/models/question.dart';

@immutable
abstract class PollsterState extends Equatable {
  PollsterState([List props = const <dynamic>[]]) : super(props);
}

class DataUninitalized extends PollsterState {
  @override
  String toString() => "Data not loaded";
}

class IntroScreen extends PollsterState {
  @override
  String toString() => "Intro Screen";
}

class ServingQuestions extends PollsterState {
  final QuestionModel questionmodel;
  final int totalQuestions;
  final int currentQuestion;

  ServingQuestions(
      {@required this.questionmodel,
      @required this.totalQuestions,
      @required this.currentQuestion})
      : assert(questionmodel != null),
        super([questionmodel, totalQuestions, currentQuestion]);

  @override
  String toString() => "Serving Question:\n $questionmodel";
}

class ServingResults extends PollsterState {
  final List<Tendency> order;
  final Map<Tendency, int> answers;
  ServingResults({@required this.answers, @required this.order});

  @override
  String toString() => "Serving Results: $answers";
}

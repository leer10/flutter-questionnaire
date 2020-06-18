import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:questionairre/src/models/question.dart';

@immutable
abstract class PollsterState {
  PollsterState();
}

//This is when the app is called but before we can access the JSON and get the questions
class DataUninitalized extends PollsterState {
  @override
  String toString() => "Data not loaded";
}

class PromptForContinue extends PollsterState {
  final int totalQuestions;
  final int currentQuestion;

  PromptForContinue(
      {@required this.totalQuestions, @required this.currentQuestion});

  @override
  String toString() => "Prompt for continue. ";
}

//Yet unused. For future such as if (un)finished data found
class IntroScreen extends PollsterState {
  @override
  String toString() => "Intro Screen";
}

//Prompting the user a question from the questionnaire
class ServingQuestions extends PollsterState {
  final QuestionModel questionmodel;
  final int totalQuestions;
  final int currentQuestion;

  ServingQuestions(
      {@required this.questionmodel,
      @required this.totalQuestions,
      @required this.currentQuestion})
      : assert(questionmodel != null),
        super();

  @override
  String toString() => "Serving Question:\n $questionmodel";
}

//Showing the user the tallies from all the answered questions
class ServingResults extends PollsterState {
  final List<Tendency> order;
  final Map<Tendency, int> answers;
  ServingResults({@required this.answers, @required this.order});

  @override
  String toString() => "Serving Results: $answers";
}

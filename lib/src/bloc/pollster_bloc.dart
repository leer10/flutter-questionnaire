import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:questionairre/src/models/question.dart';
import './bloc.dart';
import 'package:questionairre/src/repositories/questionRepo.dart';

class PollsterBloc extends Bloc<PollsterEvent, PollsterState> {
  QuestionRepository questionRepository;
  List<QuestionModel> unansweredQuestions = [];
  List<QuestionModel> answeredQuestions = [];

  int driver = 0;
  int amiable = 0;
  int analytical = 0;
  int expressive = 0;

  @override
  PollsterState get initialState => DataUninitalized();

  @override
  Stream<PollsterState> mapEventToState(
    PollsterEvent event,
  ) async* {
    if (event is AppStarted) {
      questionRepository = QuestionRepository();
      await questionRepository.loadQuestions();
      assert(questionRepository.questionairre.questions.isNotEmpty);
      unansweredQuestions = questionRepository.questionairre.questions.toList();
      yield newQuestion();
    }

    if (event is QuestionSubmitted) {
      driver = driver + event.answers[Tendency.driver];
      amiable = amiable + event.answers[Tendency.amiable];
      analytical = analytical + event.answers[Tendency.analytical];
      expressive = expressive + event.answers[Tendency.expressive];
      if (unansweredQuestions.isNotEmpty) {
        yield newQuestion();
      } else {
        throw ("not yet implemented: results page");
      }
    }
  }

  ServingQuestions newQuestion() {
    QuestionModel newQuestion;
    newQuestion = unansweredQuestions.removeAt(0);
    answeredQuestions.add(newQuestion);
    return ServingQuestions(
        questionmodel: newQuestion,
        currentQuestion: answeredQuestions.length,
        totalQuestions: answeredQuestions.length + unansweredQuestions.length);
  }
}

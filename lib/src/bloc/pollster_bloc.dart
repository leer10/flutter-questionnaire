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
      driver = driver +
          event.answers[Tendency
              .driver]; // we're adding each individual personality score to the total tally
      amiable = amiable + event.answers[Tendency.amiable];
      analytical = analytical + event.answers[Tendency.analytical];
      expressive = expressive + event.answers[Tendency.expressive];
      if (unansweredQuestions.isNotEmpty) {
        // haven't ran out of questions, so let's show a new one
        yield newQuestion();
      } else {
        //ran out of questions, so let's tally up the results and push a ServingResults state
        Map<Tendency, int> results =
            {}; // We're taking the individual int tallies and putting them into a neat map
        List<int> answerList = [
          driver,
          amiable,
          analytical,
          expressive
        ]; // we're putting the tallies into a list of ints so we can sort to show which is most
        answerList.sort();
        List<Tendency> ranking =
            []; //previous is raw numbers, but we'll put in here as the actual enums for ease of use
        answerList.forEach((element) {
          // we're going though each element (starting from the bottom which is the 'strongest') and adding it to the ranking list, and then while we're at it add it to the map
          if (element == driver && !results.containsKey(Tendency.driver)) {
            // making sure it doesn't already contain a key makes sure we don't accidentally add matching scores to the first one that matches for example if both analytical and driven get 22, analytical won't get both.
            ranking.add(Tendency.driver);
            results[Tendency.driver] = driver;
          } else if (element == amiable &&
              !results.containsKey(Tendency.amiable)) {
            ranking.add(Tendency.amiable);
            results[Tendency.amiable] = amiable;
          } else if (element == analytical &&
              !results.containsKey(Tendency.analytical)) {
            ranking.add(Tendency.analytical);
            results[Tendency.analytical] = analytical;
          } else if (element == expressive &&
              !results.containsKey(Tendency.expressive)) {
            ranking.add(Tendency.expressive);
            results[Tendency.expressive] = expressive;
          }
        });
        yield ServingResults(answers: results, order: ranking);
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

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:questionairre/src/models/question.dart';
import './bloc.dart';
import 'package:questionairre/src/repositories/questionRepo.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class PollsterBloc extends Bloc<PollsterEvent, PollsterState> {
  QuestionRepository questionRepository;
  List<QuestionModel> unansweredQuestions = [];
  List<QuestionModel> answeredQuestions = [];

  int driver = 0;
  int amiable = 0;
  int analytical = 0;
  int expressive = 0;

  Box box;

  @override
  PollsterState get initialState => DataUninitalized();

  @override
  Stream<PollsterState> mapEventToState(
    PollsterEvent event,
  ) async* {
    // We get this event as soon as the widget tree is initally built (AKA app start).
    if (event is AppStarted) {
      if (!kIsWeb) {
        var dir = await getApplicationDocumentsDirectory();
        Hive.init(dir.path);
      }
      box = await Hive.openBox("questionnaire");
//It requests we load the questions from a JSON file
      await initQuestions();
      if (box.isEmpty || box.get("answeredQuestions") == 1) {
        if (box.isNotEmpty) {
          box.clear();
        }
        //We then call this function that will generate a Question state with our fresh questions
        box.put("questionsHash", unansweredQuestions.hashCode);
        yield newQuestion();
      } else {
        print("Here's what's in the box");
        print(box.keys);
        print(box.values);
        yield PromptForContinue(
            currentQuestion: box.get("answeredQuestions"),
            totalQuestions: unansweredQuestions.length);
      }
    }

    if (event is ResumeResponse) {
      if (event.wishToResume == true) {
        driver = box.get("driver");
        amiable = box.get("amiable");
        analytical = box.get("analytical");
        expressive = box.get("expressive");
        if (box.get("answeredQuestions") <= unansweredQuestions.length) {
          try {
            for (var i = 2; i <= await box.get("answeredQuestions"); i++) {
              // I had to toy around with the loop numbering so that when you resume, you're at the question you last saw
              answeredQuestions.add(
                unansweredQuestions.removeAt(0),
              );
            }
            yield newQuestion();
          } catch (RangeError) {
            // an already completed questionairre causes this error. idc enough to properly process this
            Map results = _tallyResults();
            yield ServingResults(
                answers: results["results"], order: results["ranking"]);
          }
        } else {
          Map results = _tallyResults();
          yield ServingResults(
              answers: results["results"], order: results["ranking"]);
        }
      } else {
        box.clear();
        box.put("questionsHash", unansweredQuestions.hashCode);
        yield newQuestion();
      }
    }
    // This fires when a user presses "SUBMIT" and the stateful widget deems the input submittable
    if (event is QuestionSubmitted) {
      // we're adding each individual personality score to the total tally
      driver = driver + event.answers[Tendency.driver];
      amiable = amiable + event.answers[Tendency.amiable];
      analytical = analytical + event.answers[Tendency.analytical];
      expressive = expressive + event.answers[Tendency.expressive];
      box.put("driver", driver);
      box.put("amiable", amiable);
      box.put("analytical", analytical);
      box.put("expressive", expressive);
      if (unansweredQuestions.isNotEmpty) {
        // haven't ran out of questions yet, so let's show a new one
        yield newQuestion();
      } else {
        //ran out of questions, so let's tally up the results and push a ServingResults state
        // We're taking the individual int tallies and putting them into a neat map
        Map results = _tallyResults();

        // because the resume code keeps bringing us to the last question, we need to add another "answered" question
        box.put("answeredQuestions", answeredQuestions.length + 1);

        //Now that we have both a ranking of Tendencies, and the number that each Tendency has we can present it as a State
        yield ServingResults(
            answers: results["results"], order: results["ranking"]);
      }
    }
  }

  Map _tallyResults() {
    Map<Tendency, int> results = {};
    // we're putting the tallies into a list of ints so we can sort
    List<int> answerList = [driver, amiable, analytical, expressive];
    answerList.sort();
    //previous is only just numbers, so we'll also have a list of Tendencies to associate with the ints
    List<Tendency> ranking = [];
    answerList.forEach((element) {
      // we're going though each sorted number (starting from the bottom which is the 'strongest'), seeing which tendency it is and put it in, and then while we're at it add it to the map
      if (element == driver && !results.containsKey(Tendency.driver)) {
        // making sure it doesn't already match with an added key makes sure we don't accidentally add matching scores to the first one that matches for example if both analytical and driven get 22, analytical won't get both.
        ranking.add(Tendency.driver);
        results[Tendency.driver] = driver;
      } else if (element == amiable && !results.containsKey(Tendency.amiable)) {
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
    return {"results": results, "ranking": ranking};
  }

  Future initQuestions() async {
    //It requests we load the questions from a JSON file
    questionRepository = QuestionRepository();
    await questionRepository.loadQuestions();
    //We make double sure that the JSON is working correctly
    assert(questionRepository.questionairre.questions.isNotEmpty);
    //If all is in order, we put the loaded questions into our bag called unansweredQuestions
    unansweredQuestions = questionRepository.questionairre.questions.toList();
  }

  ServingQuestions newQuestion() {
    //We have unansweredQuestions, our bag of yet-to-be-answered questions
    QuestionModel newQuestion;
    //we're taking from the bag from the front, and putting it into the newQuestion slot
    newQuestion = unansweredQuestions.removeAt(0);
    //now we'll put that into a bag called answeredQuestions just in case they're needed later
    answeredQuestions.add(newQuestion);
    box.put("answeredQuestions", answeredQuestions.length);
    //then we'll present the new question as a new state, whilst also passing along current/total question quantities
    return ServingQuestions(
        questionmodel: newQuestion,
        currentQuestion: answeredQuestions.length,
        totalQuestions: answeredQuestions.length + unansweredQuestions.length);
  }
}

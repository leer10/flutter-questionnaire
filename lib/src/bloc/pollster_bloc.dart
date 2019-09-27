import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:questionairre/src/repositories/questionRepo.dart';

class PollsterBloc extends Bloc<PollsterEvent, PollsterState> {
  QuestionRepository questionRepository;

  @override
  PollsterState get initialState => DataUninitalized();

  @override
  Stream<PollsterState> mapEventToState(
    PollsterEvent event,
  ) async* {
    if (event is AppStarted) {
      try {
        questionRepository = QuestionRepository();
        questionRepository.loadQuestions();
        assert(questionRepository.questionairre.questions.isNotEmpty);
        yield ServingQuestions();
      } catch (e) {
        throw (e);
      }
    }
  }
}

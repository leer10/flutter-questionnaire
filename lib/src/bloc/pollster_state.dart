import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
  @override
  String toString() => "Serving Questions";
}

class ServingResults extends PollsterState {
  @override
  String toString() => "Serving Results";
}

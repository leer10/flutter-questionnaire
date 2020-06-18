import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import 'package:questionairre/src/ui/ui.dart';
import 'package:questionairre/src/bloc/bloc.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PollsterBloc>(
      create: (BuildContext context) => PollsterBloc()..add(AppStarted()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: BlocBuilder<PollsterBloc, PollsterState>(
          builder: (context, state) {
            if (state is DataUninitalized) {
              return new LoadingPage();
            } else if (state is ServingQuestions) {
              return new QuestionPage(
                servingQuestionsState: state,
              );
            } else if (state is ServingResults) {
              return new ResultsPage(
                servingResultsState: state,
              );
            } else if (state is PromptForContinue) {
              return new PromptContinuePage(
                promptForContinueState: state,
              );
            } else {
              return Placeholder();
            }
          },
        ),
      ),
    );
  }
}

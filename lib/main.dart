import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:questionairre/questionwidget.dart';

import 'package:questionairre/src/bloc/bloc.dart';
import 'package:questionairre/src/models/question.dart';

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
      builder: (context) {
        print("started pollsterbloc");
        return PollsterBloc()..dispatch(AppStarted());
      },
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
        home:
            BlocBuilder<PollsterBloc, PollsterState>(builder: (context, state) {
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
          } else {
            return Placeholder();
          }
        }),
      ),
    );
  }
}

class ResultsPage extends StatelessWidget {
  final ServingResults servingResultsState;
  ResultsPage({Key key, @required this.servingResultsState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Results"),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Card(
                child: Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "Your dominant style is ${namedTendency(servingResultsState.order.first)} with a score of ${servingResultsState.answers[servingResultsState.order.first]}.",
                        textAlign: TextAlign.center,
                      ),
                      if (servingResultsState
                              .answers[servingResultsState.order[1]] ==
                          servingResultsState
                              .answers[servingResultsState.order[2]])
                        Text(
                          "Your influencing style is a mixture of ${namedTendency(servingResultsState.order[1])} and ${namedTendency(servingResultsState.order[2])} with a score of ${servingResultsState.answers[servingResultsState.order[1]]}.",
                          textAlign: TextAlign.center,
                        )
                      else
                        Text(
                          "Your influencing style is ${namedTendency(servingResultsState.order[1])} with a score of ${servingResultsState.answers[servingResultsState.order[1]]}.",
                          textAlign: TextAlign.center,
                        ),
                      Text(
                        "Your area of need is ${namedTendency(servingResultsState.order.last)} with a score of ${servingResultsState.answers[servingResultsState.order.last]}.",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class QuestionPage extends StatelessWidget {
  final ServingQuestions servingQuestionsState;
  QuestionPage({Key key, @required this.servingQuestionsState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Questionnaire"),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Center(
          child: SingleChildScrollView(
            child: QuestionWidget(
                question: servingQuestionsState.questionmodel,
                currentQuestion: servingQuestionsState.currentQuestion,
                totalQuestions: servingQuestionsState.totalQuestions,
                key: ObjectKey(servingQuestionsState.questionmodel)),
          ),
        );
      }),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Questionnaire"),
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

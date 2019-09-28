import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import 'package:questionairre/src/bloc/bloc.dart';
import 'package:questionairre/src/models/question.dart';
import 'package:tuple/tuple.dart';

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
            return Scaffold(
              appBar: AppBar(
                title: Text("Questionnaire"),
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ServingQuestions) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Questionnaire"),
              ),
              body: Center(
                child: QuestionWidget(
                    question: state.questionmodel,
                    currentQuestion: state.currentQuestion,
                    totalQuestions: state.totalQuestions,
                    key: ObjectKey(state.questionmodel)),
              ),
            );
          } else {
            return Placeholder();
          }
        }),
      ),
    );
  }
}

class QuestionWidget extends StatefulWidget {
  final QuestionModel question;

  final int currentQuestion;
  final int totalQuestions;
  QuestionWidget(
      {@required this.question,
      @required Key key,
      this.currentQuestion,
      this.totalQuestions})
      : super(key: key);

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  List<Tuple2<Tendency, String>> responses = [];
  Map<Tendency, int> answers = {
    Tendency.driver: null,
    Tendency.amiable: null,
    Tendency.analytical: null,
    Tendency.expressive: null
  };

  @override
  void initState() {
    widget.question.answers.forEach((Tendency tendency, String string) =>
        responses.add(Tuple2<Tendency, String>(tendency, string)));
    responses.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 350,
        width: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(widget.question.question,
                      style: Theme.of(context).textTheme.headline),
                ],
              ),
            ),
            Divider(),
            Text(
              "Fill from 1-4: 1 describing you best and 4 the least",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            for (Tuple2<Tendency, String> response in responses)
              ListTile(
                title: Text(response.item2),
                leading: DropdownButton<int>(
                  value: answers[response.item1],
                  //icon: Icon(Icons.arrow_downward),
                  //hint: Text("Select"),
                  onChanged: (int newvalue) {
                    setState(
                      () {
                        if (answers.containsValue(newvalue)) {
                          print("$newvalue already exists");
                          answers.forEach((Tendency eachTendency, int value) {
                            if (value == newvalue) {
                              answers[eachTendency] = null;
                            }
                          });
                        }
                        answers[response.item1] = newvalue;
                      },
                    );
                  },
                  items: [
                    DropdownMenuItem(
                      value: 1,
                      child: Text("1"),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text("2"),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text("3"),
                    ),
                    DropdownMenuItem(
                      value: 4,
                      child: Text("4"),
                    ),
                  ],
                ),
              ),
            Stack(
              alignment: Alignment(0, 0),
              children: <Widget>[
                RaisedButton(
                    child: Text("SUBMIT"),
                    onPressed: () {
                      if (answers.values.every((element) => element != null)) {
                        BlocProvider.of<PollsterBloc>(context)
                            .dispatch(QuestionSubmitted(answers: answers));
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Please fill out all the responses"),
                          backgroundColor: Colors.red,
                        ));
                      }
                    }),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                      "${widget.currentQuestion}/${widget.totalQuestions}",
                      style: TextStyle(fontSize: 24)),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}

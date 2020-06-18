import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:questionairre/src/bloc/bloc.dart';
import 'package:questionairre/src/models/question.dart';
import 'package:tuple/tuple.dart';
import 'common.dart';

class QuestionPage extends StatelessWidget {
  final ServingQuestions servingQuestionsState;
  QuestionPage({Key key, @required this.servingQuestionsState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      titleText: "Questionnaire",
      //This allows a widget to sit in the middle of a screen (Web, big enough Mobile)
      //but if the viewport is too small then it will be scrollable and appear fullscreen
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Center(
            child: SingleChildScrollView(
              //This works with LayoutBuilder. Read the api docs for SingleChildScrollView
              child: QuestionWidget(
                  question: servingQuestionsState.questionmodel,
                  currentQuestion: servingQuestionsState.currentQuestion,
                  totalQuestions: servingQuestionsState.totalQuestions,
                  key: ObjectKey(servingQuestionsState.questionmodel)),
            ),
          );
        },
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
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(widget.question.question,
                      style: Theme.of(context).textTheme.headline5),
                ],
              ),
            ),
            Divider(),
            const Text(
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
                    const DropdownMenuItem(
                      value: 1,
                      child: Text("1"),
                    ),
                    const DropdownMenuItem(
                      value: 2,
                      child: Text("2"),
                    ),
                    const DropdownMenuItem(
                      value: 3,
                      child: Text("3"),
                    ),
                    const DropdownMenuItem(
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
                    child: const Text("SUBMIT"),
                    onPressed: () {
                      if (answers.values.every((element) => element != null)) {
                        BlocProvider.of<PollsterBloc>(context)
                            .add(QuestionSubmitted(answers: answers));
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

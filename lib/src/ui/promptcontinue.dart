import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:questionairre/src/bloc/bloc.dart';
import 'common.dart';

class PromptContinuePage extends StatelessWidget {
  const PromptContinuePage({Key key, @required this.promptForContinueState})
      : super(key: key);
  final PromptForContinue promptForContinueState;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppScaffold(
          titleText: "Resume",
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Do you want to resume?"),
              if (promptForContinueState.currentQuestion <=
                  promptForContinueState.totalQuestions)
                Text(
                    "You are on question ${promptForContinueState.currentQuestion} out of ${promptForContinueState.totalQuestions}"),
              if (promptForContinueState.currentQuestion >
                  promptForContinueState.totalQuestions)
                Text("You have already completed the test"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    child: Text("CONTINUE"),
                    color: Colors.green,
                    onPressed: () {
                      BlocProvider.of<PollsterBloc>(context)
                          .add(ResumeResponse(wishToResume: true));
                    },
                  ),
                  RaisedButton(
                    child: Text("ABORT"),
                    color: Colors.red,
                    onPressed: () {
                      BlocProvider.of<PollsterBloc>(context)
                          .add(ResumeResponse(wishToResume: false));
                    },
                  )
                ],
              )
            ],
          )),
    );
  }
}

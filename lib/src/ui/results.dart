import 'package:flutter/material.dart';
import 'package:questionairre/src/bloc/bloc.dart';
import 'package:questionairre/src/models/question.dart';

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

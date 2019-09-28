import 'package:flutter/material.dart';
import 'common.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      titleText: "Questionnaire",
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

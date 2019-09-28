import 'package:flutter/material.dart';

//Contains the scaffold that's used by all the apps. Maybe I should just instead move the BlocBuilder into the body and let them share a single Scaffold
class AppScaffold extends StatelessWidget {
  final String titleText;
  final Widget body;
  AppScaffold({Key key, @required this.titleText, @required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              showAboutDialog(
                  context: context,
                  applicationName: "Questionnaire App",
                  applicationLegalese:
                      "Created by Brandon Abbott. Licensed GPLv3");
            },
          )
        ],
      ),
      body: body,
    );
  }
}

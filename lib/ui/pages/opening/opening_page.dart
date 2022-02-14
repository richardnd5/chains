import 'package:chains/ui/pages/markov/markov_page.dart';
import 'package:flutter/material.dart';

class OpeningPage extends StatelessWidget {
  const OpeningPage({Key? key}) : super(key: key);

  _goToMarkovPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarkovPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: size.width / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome to the melody page! This is a work in progress. Click to button to go to the sequencer page.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _goToMarkovPage(context),
                child: Text("I've been here before."),
              )
            ],
          ),
        ),
      ),
    );
  }
}

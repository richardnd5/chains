import 'package:chains/markov_learning.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  // n gram
  // Continuous sequence of text
  /*
  
  "This rainbow"
Trigram:

  Thi
  his
  is_
  s_r
  
  */

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MarkovLearning()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var model = context.watch<MarkovLearning>();
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.all(16),
            child: ListView(
              shrinkWrap: true,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      Provider.of<MarkovLearning>(context, listen: false)
                          .makeIt(),
                  child: Text(
                    'Make it',
                    textAlign: TextAlign.center,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Clipboard.setData(
                        ClipboardData(text: model.generatedTexts[index]));
                    return SelectableText(model.generatedTexts[index]);
                  },
                  itemCount: model.generatedTexts.length,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

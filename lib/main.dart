import 'dart:convert';
import 'package:chains/create_note_object_service.dart';
import 'package:chains/js_function.dart';
import 'package:chains/markov_learning.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:js' as js;
import 'models.dart';
import 'package:js/js.dart';

void main() {
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
  String stringToPlay = '1';
  Color containerColor = Colors.blue;
  bool containerOn = false;
  String currentNote = '';

  int count = 0;
  @override
  void initState() {
    super.initState();
    triggerNoteEvent = allowInterop(triggerScreen);
    js.context
        .callMethod('loadSampler', ['Flutter is calling upon JavaScript!']);
  }

  triggerScreen(dynamic json) {
    var noodle = jsonDecode(json);
    print(noodle);
    setState(() {
      count++;
      containerColor = containerOn ? Colors.blue : Colors.teal;
      containerOn = !containerOn;
      currentNote = (noodle['notes'] as List).first;
    });
  }

  @override
  Widget build(BuildContext context) {
    var model = context.watch<MarkovLearning>();
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            color: containerColor,
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  currentNote,
                  style: TextStyle(fontSize: 64),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () {
                    CreateNoteObjectService.test();
                    var noteList =
                        CreateNoteObjectService.createNoteObjectArray(
                      stringToPlay,
                      62,
                      Modes.ionian,
                    );
                    List<Map<String, dynamic>> theMap = [];
                    noteList.forEach((element) {
                      theMap.add(element.toJson());
                    });
                    var json = jsonEncode(theMap);
                    js.context.callMethod('playSequencer', [json]);
                  },
                  child: Text(
                    'Console',
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<MarkovLearning>(context, listen: false)
                        .generateMarkovChain();
                    setState(() => stringToPlay = model.generatedTexts.last);
                  },
                  child: Text(
                    'Make it',
                    textAlign: TextAlign.center,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      SelectableText(model.generatedTexts[index]),
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

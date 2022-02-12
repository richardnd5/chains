import 'dart:convert';
import 'dart:js' as js;

import 'package:chains/constants/models.dart';
import 'package:chains/constants/pitches_with_octaves.dart';
import 'package:chains/extensions/rescale.dart';
import 'package:chains/jsFunctions/js_functions.dart';
import 'package:chains/models/note_object.dart';
import 'package:chains/services/create_note_object_service.dart';
import 'package:chains/services/markov_learning.dart';
import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:provider/provider.dart';

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
  double topPos = 40;

  GlobalKey canvasKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      triggerNoteEvent = allowInterop((json) => triggerScreen(json, context));
      generateChain(Provider.of<MarkovLearning>(context, listen: false));
    });
    js.context
        .callMethod('loadSampler', ['Flutter is calling upon JavaScript!']);
  }

  triggerScreen(dynamic json, BuildContext context) {
    var noodle = jsonDecode(json);

    double rescaledNumber = Rescale(
            from: ClosedRange(61, 76),
            to: ClosedRange(boxSize(context).height, 0))
        .rescale(noodle['noteNumber']);
    setState(() {
      containerColor = containerOn ? Colors.blue : Colors.teal;
      containerOn = !containerOn;
      currentNote = (noodle['notes'] as List).first;
      topPos = rescaledNumber;
    });
    print(currentNote);
  }

  void _createAndPlaySequencer() {
    var noteList = CreateNoteObjectService.createNoteObjectArray(
      stringToPlay,
      62,
      Modes.ionian,
    );
    List<Map<String, dynamic>> theMap = [];
    noteList.forEach((element) {
      theMap.add(element.toJson(90));
    });
    var json = jsonEncode(theMap);
    js.context.callMethod('playSequencer', [json]);
  }

  void generateChain(MarkovLearning model) {
    Provider.of<MarkovLearning>(context, listen: false).generateMarkovChain();
    setState(() => stringToPlay = model.generatedTexts.last);
  }

  Size boxSize(BuildContext context) {
    final box = canvasKey.currentContext?.findRenderObject() as RenderBox;
    return box.size;
  }

  @override
  Widget build(BuildContext context) {
    var model = context.watch<MarkovLearning>();
    var size = MediaQuery.of(context).size;

    var noteList = CreateNoteObjectService.createNoteObjectArray(
      stringToPlay,
      62,
      Modes.ionian,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Work in Progress'),
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 40),
        decoration: pageGradient(containerColor, Colors.black),
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height,
        child: ListView(
          shrinkWrap: true,
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 7,
              children: noteList.map((e) => NoteCell(e)).toList(),
            ),
            Container(
              key: canvasKey,
              color: Colors.blueGrey,
              width: size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: Stack(
                children: [
                  AnimatedPositioned(
                    left: size.width / 2 - 25,
                    top: topPos,
                    child: Container(
                      width: 25,
                      height: 25,
                      color: Colors.black,
                    ),
                    duration: Duration(milliseconds: 100),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        currentNote,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createAndPlaySequencer,
              child: Text(
                'Play Melody',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                generateChain(model);
              },
              child: Text(
                'Generate a Melody',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  pageGradient(Color color1, Color color2) => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [color1, color2],
        ),
      );
}

class NoteCell extends StatelessWidget {
  const NoteCell(this.e, {Key? key, required}) : super(key: key);

  final NoteObject e;
  final double squareWidth = 100;
  final double squareHeight = 40;

  playNote(int number) {
    var pitches = PitchesWithOctaves().pitchesWithOctaves;
    var letterName = pitches[number];
    var data = {
      "notes": [letterName],
      "noteNumber": number,
      "duration": 1,
      "position": 0
    };

    var json = jsonEncode(data);
    js.context.callMethod('playNote', [json]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => playNote(e.noteNumber),
      child: Card(
        child: Container(
          width: squareWidth,
          height: squareHeight,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${e.letterName}'),
              Text('${e.endPosition - e.startPosition}'),
            ],
          ),
        ),
      ),
    );
  }
}

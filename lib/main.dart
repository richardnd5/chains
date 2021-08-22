import 'dart:convert';
import 'package:chains/constants/pitches_with_octaves.dart';
import 'package:chains/services/create_note_object_service.dart';
import 'package:chains/extensions/rescale.dart';
import 'package:chains/jsFunctions/js_functions.dart';
import 'package:chains/services/markov_learning.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:js' as js;
import 'constants/models.dart';
import 'package:js/js.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MarkovLearning()),
      ],
      child: MaterialApp(home: MyApp()),
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
    var model = context.watch<MarkovLearning>();
    var size = MediaQuery.of(context).size;

    double squareWidth = 100;
    double squareHeight = 40;

    var noteList = CreateNoteObjectService.createNoteObjectArray(
      stringToPlay,
      62,
      Modes.ionian,
    );

    return SafeArea(
      child: Scaffold(
        body: AnimatedContainer(
          duration: Duration(milliseconds: 40),
          color: containerColor,
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height,
          child: ListView(
            shrinkWrap: true,
            children: [
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 7,
                children: noteList.map((e) {
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
                }).toList(),
              ),
              Container(
                key: canvasKey,
                color: Colors.blueGrey,
                width: size.width,
                height: MediaQuery.of(context).size.height / 2,
                child: LayoutBuilder(
                  builder: (_, __) => Stack(
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
                      )
                    ],
                  ),
                ),
              ),
              Text(
                currentNote,
                style: TextStyle(fontSize: 64),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: _createAndPlaySequencer,
                child: Text(
                  'Play Melody',
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  generateChain(model);
                },
                child: Text(
                  'Make it',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

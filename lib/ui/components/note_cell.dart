import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:chains/services/sequencer/constants/pitches_with_octaves.dart';
import 'package:chains/services/sequencer/models/note_object.dart';
import 'package:flutter/material.dart';

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

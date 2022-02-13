import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:chains/models/note_object.dart';
import 'package:flutter/material.dart';

class SequencerService extends ChangeNotifier {
  SequencerService() {
    init();
  }

  init() {
    loadSampler();
  }

  void loadSampler() {
    js.context.callMethod('loadSampler', ['Arguments can be passed here.']);
  }

  void playSequence(List<NoteObject> noteList, int tempo) {
    var json = _serializeNoteList(noteList, tempo);
    js.context.callMethod('playSequencer', [json]);
    notifyListeners();
  }

  String _serializeNoteList(List<NoteObject> noteList, int tempo) {
    List<Map<String, dynamic>> theMap = [];
    noteList.forEach((element) {
      theMap.add(element.toJson(tempo));
    });
    return jsonEncode(theMap);
  }
}

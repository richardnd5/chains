import 'dart:math';

import 'package:flutter/material.dart';

import '../models/gram.dart';

class MarkovLearningService extends ChangeNotifier {
  MarkovLearningService() {
    setup(
        "1;7,;2;3;4;7,;2;3;;;;;;;..2;3;5;6;3;2;3;5;;;;;;;..7;5;8;9;2';6;5;5;;;;;;;..5;2;4;3;1;3;2;1;;;;;;;..");
  }

  String text = '';
  var _order = 3;
  var _charCount = 21;

  Map<String, Gram> _ngramMap = {};
  List<String> _generatedTexts = [];

  void setup(String text) {
    this.text = text;
    text.split('').asMap().forEach((i, element) {
      int start = i;
      int? end = (i + _order) >= text.length ? null : (i + _order);

      String gram = text.substring(start, end);

      var currentGram = _ngramMap[gram];
      if (currentGram == null) {
        _ngramMap[gram] = Gram(gram: gram, count: 1, nextPossibleChars: []);
        int? endCount = end == null
            ? null
            : end + 1 >= text.length
                ? null
                : end;
        String? nextText = endCount != null ? text[endCount] : null;
        if (nextText != null) {
          _ngramMap[gram]!.nextPossibleChars!.add(nextText);
        }
      } else {
        List<String>? next = currentGram.nextPossibleChars;

        int? endCount = end == null
            ? null
            : end + 1 >= text.length
                ? null
                : end;
        String? nextText = endCount != null ? text[endCount] : null;
        if (nextText != null) {
          next?.add(nextText);
        }
        _ngramMap[gram] = Gram(
            gram: gram, count: currentGram.count + 1, nextPossibleChars: next);
      }
    });
  }

  List<String>? generateMarkovChainFrom(String melody) {
    try {
      setup(melody);
      var currentGram = text.substring(0, _order);
      String result = currentGram;
      for (var i = 0; i < _charCount; i++) {
        var possibilities = _ngramMap[currentGram]?.nextPossibleChars;

        var length = possibilities?.length;
        if (length != null && length != 0) {
          int randomNumber = new Random().nextInt(length > 0 ? length : 0);
          String? nextLetter = possibilities?[randomNumber];

          result = '$result$nextLetter';
          var len = result.length;
          currentGram = result.substring(len - _order, len);
        }
      }
      _generatedTexts.add(result);
      return _generatedTexts;
    } catch (e) {
      print(e);
    }
    return null;
  }
}

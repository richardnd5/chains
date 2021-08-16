import 'package:flutter/material.dart';
import 'dart:math';

import 'models/gram.dart';

class MarkovLearning extends ChangeNotifier {
  MarkovLearning() {
    setup();
  }

  var text =
      "1;7,;2;3;4;7,;2;3;;;;;;;..2;3;5;6;3;2;3;5;;;;;;;..7;5;8;9;2';6;5;5;;;;;;;..5;2;4;3;1;3;2;1;;;;;;;..";
  var order = 1;
  var charCount = 100;

  Map<String, Gram> ngramMap = {};
  List<String> generatedTexts = [];

  void setup() {
    text.split('').asMap().forEach((i, element) {
      var start = i;
      var end = (i + order) >= text.length ? null : (i + order);

      String gram = text.substring(start, end);

      var currentGram = ngramMap[gram];
      if (currentGram == null) {
        ngramMap[gram] = Gram(gram: gram, count: 1, nextPossibleChars: []);
        int? endCount = end == null
            ? null
            : end + 1 >= text.length
                ? null
                : end;
        String? nextText = endCount != null ? text[endCount] : null;
        if (nextText != null) {
          ngramMap[gram]!.nextPossibleChars!.add(nextText);
        }
      } else {
        var next = currentGram.nextPossibleChars;

        int? endCount = end == null
            ? null
            : end + 1 >= text.length
                ? null
                : end;
        String? nextText = endCount != null ? text[endCount] : null;
        if (nextText != null) {
          next?.add(nextText);
        }
        ngramMap[gram] = Gram(
            gram: gram, count: currentGram.count + 1, nextPossibleChars: next);
      }
    });
  }

  generateMarkovChain() {
    try {
      var currentGram = text.substring(0, order);
      String result = currentGram;
      for (var i = 0; i < charCount; i++) {
        var possibilities = ngramMap[currentGram]?.nextPossibleChars;

        var length = possibilities?.length;
        if (length != null && length != 0) {
          int randomNumber = new Random().nextInt(length > 0 ? length : 0);
          String? nextLetter = possibilities?[randomNumber];

          result = '$result$nextLetter';
          var len = result.length;
          currentGram = result.substring(len - order, len);
        }
      }
      generatedTexts.add(result);
      notifyListeners();
    } catch (e) {
      // print(e);
    }
  }
}

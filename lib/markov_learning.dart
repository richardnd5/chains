import 'package:flutter/material.dart';
import 'dart:math';

import 'models/gram.dart';

class MarkovLearning extends ChangeNotifier {
  MarkovLearning() {
    setup();
  }
  var text =
      "Seahorses range in size from 1.5 to 35.5 cm (5⁄8 to 14 in). They are named for their equine appearance, with bent necks and long snouted heads and a distinctive trunk and tail. Although they are bony fish, they do not have scales, but rather thin skin stretched over a series of bony plates, which are arranged in rings throughout their bodies. Each species has a distinct number of rings.The armor of bony plates also protects them against predators,and because of this outer skeleton, they no longer have ribs.] Seahorses swim upright, propelling themselves using the dorsal fin, another characteristic not shared by their close pipefish relatives, which swim horizontally. Razorfish are the only other fish that swim vertically. The pectoral fins, located on either side of the head behind their eyes, are used for steering. They lack the caudal fin typical of fishes. Their prehensile tail is composed of square-like rings that can be unlocked only in the most extreme conditions. They are adept at camouflage, and can grow and reabsorb spiny appendages depending on their habitat.";

  var order = 4;
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
      print(e);
    }
  }
}

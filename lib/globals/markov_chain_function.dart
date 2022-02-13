import 'dart:math';

import '../models/gram.dart';

/// This function will generate a Markov Chain from the provided text.
List<String>? generateMarkovChainFrom(
  String text, {
  int chainCharacterLength = 21,
  int orderLength = 3,
}) {
  print('start: ${DateTime.now()}');
  try {
    final _ngramMap = _createGramMap(text, orderLength);
    List<String> _generatedTexts = [];
    String currentGram = text.substring(0, orderLength);
    String result = currentGram;
    for (var i = 0; i < chainCharacterLength; i++) {
      final possibilities = _ngramMap[currentGram]?.nextPossibleChars;

      final length = possibilities?.length;
      if (length != null && length != 0) {
        int randomNumber = new Random().nextInt(length > 0 ? length : 0);
        String? nextLetter = possibilities?[randomNumber];

        result = '$result$nextLetter';
        int len = result.length;
        currentGram = result.substring(len - orderLength, len);
      }
    }
    _generatedTexts.add(result);
    return _generatedTexts;
  } catch (e) {
    print(e);
    return null;
  } finally {
    print('end: ${DateTime.now()}');
  }
}

Map<String, Gram> _createGramMap(String text, int orderLength) {
  Map<String, Gram> _ngramMap = {};
  // Go through each character of the text and create grams
  text.split('').asMap().forEach((i, element) {
    int start = i;
    int? end = (i + orderLength) >= text.length ? null : (i + orderLength);

    String gram = text.substring(start, end);

    final currentGram = _ngramMap[gram];
    if (currentGram == null) {
      _ngramMap[gram] = Gram(
        gram: gram,
        count: 1,
        nextPossibleChars: [],
      );
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
      List<String>? nextPossibleChars = currentGram.nextPossibleChars;

      int? endCount = end == null
          ? null
          : end + 1 >= text.length
              ? null
              : end;
      String? nextText = endCount != null ? text[endCount] : null;
      if (nextText != null) {
        nextPossibleChars?.add(nextText);
      }
      _ngramMap[gram] = Gram(
        gram: gram,
        count: currentGram.count + 1,
        nextPossibleChars: nextPossibleChars,
      );
    }
  });
  return _ngramMap;
}

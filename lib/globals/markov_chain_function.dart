import 'dart:math';

import '../models/gram.dart';

/// This function will generate a Markov Chain from the given text.
///
/// If the startingSeed is null, the function will use the first (n) characters of
/// the provided text, where n = orderLength
///
/// The chainCharacterLength is the total length to generate PLUS the startingSeed
String? generateMarkovChain(
  String text, {
  String? startingSeed,
  int chainCharacterLength = 21,
  int orderLength = 3,
}) {
  try {
    final _ngramMap = _createGramMap(text, orderLength);
    String currentGram = startingSeed ?? text.substring(0, orderLength);
    String result = currentGram;
    for (var i = 0; i < chainCharacterLength; i++) {
      final possibilities = _ngramMap[currentGram]?.nextPossibleChars;

      final length = possibilities?.length;
      if (length != null && length != 0) {
        int randomNumber = new Random().nextInt(length > 0 ? length : 0);
        String? nextLetter = possibilities?[randomNumber];
        result += nextLetter ?? '';
        int len = result.length;
        currentGram = result.substring(len - orderLength, len);
      }
    }
    return result;
  } catch (e) {
    print(e);
    return null;
  }
}

Map<String, Gram> _createGramMap(String text, int orderLength) {
  Map<String, Gram> _ngramMap = {};
  // Go through each character of the text and create grams
  text.split('').asMap().forEach((i, element) {
    int start = i;
    int? end = (i + orderLength) >= text.length ? null : (i + orderLength);
    String gram = text.substring(start, end);
    int? endCount = end == null
        ? null
        : end + 1 >= text.length
            ? null
            : end;

    String? nextText = endCount != null ? text[endCount] : null;
    final currentGram = _ngramMap[gram];
    bool newGram = currentGram == null;

    List<String>? nextPossibleCharsList = currentGram?.nextPossibleChars ?? [];

    _ngramMap[gram] = Gram(
      gram: gram,
      count: newGram ? 1 : currentGram.count + 1,
      nextPossibleChars: nextPossibleCharsList,
    );

    if (nextText != null) {
      nextPossibleCharsList.add(nextText);
    }
  });
  return _ngramMap;
}

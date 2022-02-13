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
    // Set the current gram to process, if a startingSeed was provided, use
    // that, else, use the first (n) characters of
    // the provided text, where n = orderLength
    String currentGram = startingSeed ?? text.substring(0, orderLength);
    // Start the generated text with the current gram
    String generatedText = currentGram;

    for (var i = 0; i < chainCharacterLength; i++) {
      // store the nextPossibleChars
      final possibilities = _ngramMap[currentGram]?.nextPossibleChars;
      // final possibilitiesCount = possibilities?.length;

      if (possibilities?.isNotEmpty == true) {
        // add a random letter from possibilities
        generatedText += _randomElementFrom(possibilities!) ?? '';

        // set the next gram to process
        int len = generatedText.length;
        currentGram = generatedText.substring(len - orderLength, len);
      }
    }
    return generatedText;
  } catch (e) {
    print(e);
    return null;
  }
}

String? _randomElementFrom(List<String> possibilities) {
  int randomNumber = new Random().nextInt(possibilities.length);
  return possibilities[randomNumber];
}

Map<String, Gram> _createGramMap(String text, int orderLength) {
  Map<String, Gram> _ngramMap = {};
  // Go through each character of the text and create grams
  text.split('').asMap().forEach((i, element) {
    int start = i;
    int? end = (i + orderLength) >= text.length ? null : (i + orderLength);
    //Set the next gram to process
    String gram = text.substring(start, end);

    final currentGram = _ngramMap[gram];

    // If the gram was already in the gramMap, set it's previous nextPossibleChars,
    // else, set an empty list
    List<String>? nextPossibleCharsList = currentGram?.nextPossibleChars ?? [];

    // Add the gram to the _ngramMap (upcert)
    _ngramMap[gram] = Gram(
      gram: gram,
      count: currentGram == null ? 1 : currentGram.count + 1,
      nextPossibleChars: nextPossibleCharsList,
    );

    // This gets the index of the next character after the current gram in the text,
    // if there isn't one, it is null.
    int? endCount = end == null
        ? null
        : end + 1 >= text.length
            ? null
            : end;
    // If there is a character following the current gram in the provided text,
    // add it to the grams, nextPossibleCharsList
    String? nextChar = endCount != null ? text[endCount] : null;
    if (nextChar != null) nextPossibleCharsList.add(nextChar);
  });
  return _ngramMap;
}

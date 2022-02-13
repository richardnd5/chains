import 'dart:convert';

import 'package:chains/extensions/rescale.dart';
import 'package:chains/jsFunctions/js_functions.dart';
import 'package:flutter/material.dart';
import 'package:js/js.dart';

class MovingNoteComponent extends StatefulWidget {
  const MovingNoteComponent({
    Key? key,
  }) : super(key: key);

  @override
  State<MovingNoteComponent> createState() => _MovingNoteComponentState();
}

class _MovingNoteComponentState extends State<MovingNoteComponent> {
  String stringToPlay = '1';
  Color containerColor = Colors.blue;
  bool containerOn = false;
  String currentNote = '';
  GlobalKey canvasKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      triggerNoteEvent = allowInterop((json) => triggerScreen(json, context));
    });
  }

  Size boxSize(BuildContext context) {
    final box = canvasKey.currentContext?.findRenderObject() as RenderBox;
    return box.size;
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
  }

  double topPos = 40;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
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
    );
  }
}

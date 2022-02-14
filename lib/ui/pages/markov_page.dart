import 'package:chains/services/sequencer/constants/models.dart';
import 'package:chains/ui/components/moving_note_component.dart';
import 'package:chains/ui/components/note_cell.dart';
import 'package:chains/ui/helpers/page_gradient.dart';
import 'package:chains/ui/pages/viewModel/mark_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarkovPage extends StatefulWidget {
  const MarkovPage({Key? key}) : super(key: key);

  @override
  _MarkovPageState createState() => _MarkovPageState();
}

class _MarkovPageState extends State<MarkovPage> {
  MarkovPageViewModel? vm;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<MarkovPageViewModel>(context, listen: false)
          .generateMarkovMelody('1;;2;;3;;4;;5;;6;;7;;8;;;;', 61, Modes.ionian);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    vm = context.watch<MarkovPageViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text('Work in Progress')),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 40),
        decoration: pageGradient(Colors.blue, Colors.black),
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height,
        child: ListView(
          shrinkWrap: true,
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 7,
              children: vm!.noteList.map((e) => NoteCell(e)).toList(),
            ),
            MovingNoteComponent(),
            SizedBox(height: 16),
            _buildButtonSection(context),
          ],
        ),
      ),
    );
  }

  Column _buildButtonSection(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: vm?.playSequence,
          child: Text(
            'Play Melody',
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => vm?.generateMarkovMelody(
              "1;7,;2;3;4;7,;2;3;;;;;;;..2;3;5;6;3;2;3;5;;;;;;;..7;5;8;9;2';6;5;5;;;;;;;..5;2;4;3;1;3;2;1;;;;;;;..",
              61,
              Modes.ionian),
          child: Text(
            'Generate a Melody',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

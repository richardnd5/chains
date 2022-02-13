import 'package:chains/globals/global_functions.dart';
import 'package:chains/ui/components/moving_note_component.dart';
import 'package:chains/ui/components/note_cell.dart';
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
          onPressed: vm?.generateChain,
          child: Text(
            'Generate a Melody',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

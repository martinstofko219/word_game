import 'package:flutter/material.dart';
import 'package:random_words/random_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Word Game', home: RandomSentences());
  }
}

class RandomSentences extends StatefulWidget {
  @override
  State<RandomSentences> createState() => _RandomSentences();
}

class _RandomSentences extends State<RandomSentences> {
  final _sentences = <String>[];
  final _funnies = Set<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Game'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _pushFunnies,
          ),
        ],
      ),
      body: _buildSentencesListView(),
    );
  }

  String _getSentence() {
    final noun = WordNoun.random();
    final adjective = WordAdjective.random();
    return 'The programmer wrote a ${adjective.asCapitalized} app in Flutter and showed it off to his ${noun.asCapitalized}.';
  }

  Widget _buildListTile(String sentence) {
    final isFunny = _funnies.contains(sentence);

    return ListTile(
      title: Text(sentence),
      trailing: Icon(
        Icons.thumb_up,
        color: isFunny ? Colors.blue : null,
      ),
      onTap: () {
        setState(() {
          if (!isFunny) {
            _funnies.add(sentence);
          } else {
            _funnies.remove(sentence);
          }
        });
      },
    );
  }

  Widget _buildSentencesListView() {
    // max number of sentences
    final maxNum = 100;

    // remove itemCount and maxNum check in itemBuilder to make the list view infinitely scrolling
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: maxNum,
      itemBuilder: (context, i) {
        // add divider between each row
        if (i.isOdd)
          return Divider(
            color: Color(Colors.black26.value),
          );

        // counts how many sentences are in the list view
        // dividing by 2 since we're adding divider between each sentence of the list view
        final index = i ~/ 2;
        // checks for end of list view
        if (index >= _sentences.length && _sentences.length < maxNum) {
          // generate more sentences
          for (int x = 0; x < 10; x++) {
            _sentences.add(_getSentence());
          }
        }
        return _buildListTile(_sentences[index]);
      },
    );
  }

  void _pushFunnies() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        final listTiles = _funnies.map((sentence) {
          return ListTile(
            title: Text(sentence),
          );
        });

        final dividedList =
            ListTile.divideTiles(context: context, tiles: listTiles).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Funny Sentences'),
          ),
          body: ListView(
            padding: EdgeInsets.all(16.0),
            children: dividedList,
          ),
        );
      }),
    );
  }
}

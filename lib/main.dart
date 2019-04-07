import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  ).then(
    (_) {runApp(App());}
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Travelling Numbers Game',
        theme: ThemeData.dark(),
        home: Board());
  }
}

class Board extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Board();
}

class _Board extends State<Board> {
  Game _game;
  _Board([int dim = 4]) {
    _game = Game(dim);
    _game.shuffle();
  }

  void restart() {
    setState(() {
      _game.shuffle();
    });
  }

  Widget _buildBody() => Center(
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(10.0),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _game.dim),
              itemBuilder: _buildNumPieces,
              itemCount: _game.blocks.length,
              scrollDirection: Axis.vertical,
            ),
          ),
        ),
      );

  void _restartPrompt(BuildContext context,String title, String message)  {
    showDialog(context: context, builder: (c) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(onPressed: () {Navigator.of(c).pop(); restart();}, child: Text('Restart'),),
        FlatButton(onPressed: () {Navigator.of(c).pop();}, child: Text('Cancel'),)
      ],
    )
    );
  }

  Widget _buildNumPieces(BuildContext context, int index) {
    var card = Card(
      child: Center(
        child: Text('${_game.blocks[index]}',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          )),
    ));
    if (_game.blocks[index] == 0) 
      return Text('');
    var moveFunc = ([dragdetail]) => setState(() {
      if (!_game.isSolved()) {
        _game.move(index);
        if (_game.isSolved()) {
          _restartPrompt(context, 'Congratuations!', 'Puzzle is solved.');
        }
      }
    });
    if (_game.moveablePieces().contains(index)) {
      return GestureDetector(
        child: card, 
        onTap: moveFunc,
        onHorizontalDragDown: moveFunc,
        onVerticalDragDown: moveFunc,
      );
    }
    return card;
  }

  Widget _successCard(context) {
    if (_game.isSolved()) {
      return Card(
        child: ListTile(leading: Icon(Icons.golf_course), title: Text('Congrats! Game is solved.'),)
      );
    } else {
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Travelling Numbers Game'),
    ),
    body: Stack(
      children: <Widget>[
        _successCard(context),
        Center(
          child: _buildBody(),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () {_restartPrompt(context, 'Restart', 'Would you like to restart?');},
      tooltip: 'restart',
      icon: Icon(Icons.refresh),
      label: Text('Restart'),
    ),
  );
}

class Game {
  List<int> blocks;
  int dim;
  final _random = Random();
  Game(this.dim) {
    blocks = List.generate(dim * dim, (i) => (i + 1) % (dim * dim));
  }

  List<int> moveablePieces() {
    int x = blocks.indexOf(0);
    return [
      x % dim == dim - 1 ? -1 : x + 1, // right
      x >= dim * (dim - 1) ? -1 : x + dim, // bottom
      x % dim == 0 ? -1 : x - 1, // left
      x < dim ? -1 : x - dim, // top
    ].where((i) => !i.isNegative).toList();
  }

  bool isSolved() {
    var solved = List.generate(blocks.length - 1, (i) => i + 1);
    return ListEquality()
        .equals(solved, blocks.take(blocks.length - 1).toList());
  }

  bool move(int pos) {
    int space = blocks.indexOf(0);
    if (moveablePieces().contains(pos)) {
      blocks[space] = blocks[pos];
      blocks[pos] = 0;
      return true;
    }
    return false;
  }

  void shuffle() {
    for (var i = 0; i < 999; i++) {
      var s = moveablePieces();
      move(s[_random.nextInt(s.length)]);
    }
    if (isSolved()) shuffle();
  }
}

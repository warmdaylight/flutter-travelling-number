import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _game.dim),
              itemBuilder: _buildNumPieces,
              itemCount: _game.blocks.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      );

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
    if (_game.moveablePieces().contains(index)) {
      return GestureDetector(child: card, onTap: () => setState(() {
        _game.move(index);
      }),);
    }
    return card;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Traveling Numbers'),
        ),
        body: Center(
          child: _buildBody(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: restart,
          tooltip: 'restart',
          child: Icon(Icons.refresh),
        ),
      );
}

class Game {
  List<int> blocks;
  int dim;
  final _random = Random();
  Game(this.dim) {
    blocks = List.generate(dim * dim, (i) => i);
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

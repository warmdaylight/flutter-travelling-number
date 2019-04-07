import 'package:flutter_test/flutter_test.dart';
import 'package:travelling_numbers/main.dart';

void main() {
  test('Generate 3x3', () {
    var game = Game(3);
    expect(game.blocks, [1, 2, 3, 4, 5, 6, 7, 8, 0]);
  });

  test('Generate 4x4', () {
    var game = Game(4);
    expect(game.blocks, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0]);
  });

  group('moveable sample check', () {
    test('moveable check (0)', () {
      var game = Game(3);
      game.blocks = [1, 2, 3, 4, 5, 6, 7, 8];
      game.blocks.insert(0, 0);
      var result = game.moveablePieces();
      expect(result, [1, 3]);
    });
    test('moveable check (1)', () {
      var game = Game(3);
      game.blocks = [1, 2, 3, 4, 5, 6, 7, 8];
      game.blocks.insert(1, 0);
      var result = game.moveablePieces();
      expect(result, [2, 4, 0]);
    });
    test('moveable check (2)', () {
      var game = Game(3);
      game.blocks = [1, 2, 3, 4, 5, 6, 7, 8];
      game.blocks.insert(2, 0);
      var result = game.moveablePieces();
      expect(result, [5, 1]);
    });
    test('moveable check (4)', () {
      var game = Game(3);
      game.blocks = [1, 2, 3, 4, 5, 6, 7, 8];
      game.blocks.insert(4, 0);
      var result = game.moveablePieces();
      expect(result, [5, 7, 3, 1]);
    });
  });

  group('length of moveablePieces', () {
    test('inner 3x3', () {
      var game = Game(3);
      var board = List.generate(8, (i) => i + 1);
      for (var pos in [4]) {
        game.blocks = List.of(board);
        game.blocks.insert(pos, 0);
        var result = game.moveablePieces();
        expect(result.length, 4);
      }
    });
    test('edge 3x3', () {
      var game = Game(3);
      var board = List.generate(8, (i) => i + 1);
      for (var pos in [1, 3, 5, 7]) {
        game.blocks = List.of(board);
        game.blocks.insert(pos, 0);
        var result = game.moveablePieces();
        expect(result.length, 3);
      }
    });
    test('corner 3x3', () {
      var game = Game(3);
      var board = List.generate(8, (i) => i + 1);
      for (var pos in [0, 2, 6, 8]) {
        game.blocks = List.of(board);
        game.blocks.insert(pos, 0);
        var result = game.moveablePieces();
        expect(result.length, 2);
      }
    });
    test('inner 4x4', () {
      var game = Game(4);
      var board = List.generate(15, (i) => i + 1);
      for (var pos in [5, 6, 9, 10]) {
        game.blocks = List.of(board);
        game.blocks.insert(pos, 0);
        var result = game.moveablePieces();
        expect(result.length, 4);
      }
    });
    test('edge 4x4', () {
      var game = Game(4);
      var board = List.generate(15, (i) => i + 1);
      for (var pos in [1, 2, 4, 7, 8, 11, 13, 14]) {
        game.blocks = List.of(board);
        game.blocks.insert(pos, 0);
        var result = game.moveablePieces();
        expect(result.length, 3);
      }
    });
    test('corner 4x4', () {
      var game = Game(4);
      var board = List.generate(15, (i) => i + 1);
      for (var pos in [0, 3, 12, 15]) {
        game.blocks = List.of(board);
        game.blocks.insert(pos, 0);
        var result = game.moveablePieces();
        expect(result.length, 2);
      }
    });
  });

  group('move', () {
    test('move false', () {
      var game = Game(3);
      final start = [1, 2, 3, 4, 0, 5, 6, 7, 8];
      for (var i in [0,2,6,8]) {
        game.blocks = List.of(start);
        expect(game.move(i), false);
        expect(game.blocks, start);
      }
    });
    test('move ok', () {
      var game = Game(3);
      final start = [1, 2, 3, 4, 0, 5, 6, 7, 8];
      for (var i in [1,3,5,7]) {
        game.blocks = List.of(start);
        expect(game.move(i), true);
        print('move $i: ${game.blocks}');
        expect(game.blocks[i], 0);
        expect(game.blocks[4], start[i]);
      }
    });
  });

  group('shuffle', () {
    test('shuffle 3x3', () {
      var game = Game(3);
      game.shuffle();
      print(game.blocks);
    });

    test('shuffle 4x4', () {
      var game = Game(4);
      game.shuffle();
      print(game.blocks);
    });
  });

  group('game solved', () {
    test('is solved 3x3', () {
      var game = Game(3);
      game.blocks = [1,2,3,4,5,6,7,8,0];
      expect(game.isSolved(), true);
    });

    test('is solved 4x4', () {
      var game = Game(4);
      game.blocks = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0];
      expect(game.isSolved(), true);
    });

    test('not solved 3x3', () {
      var game = Game(3);
      game.shuffle();
      expect(game.isSolved(), false);
    });

    test('not solved 4x4', () {
      var game = Game(4);
      game.shuffle();
      expect(game.isSolved(), false);
    });
  });
}

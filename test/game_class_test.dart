import 'package:flutter_test/flutter_test.dart';
import 'package:travelling_numbers/main.dart';

void main() {
  test('Generate Class', () {
    var game = Game(3);
    expect(game.blocks, [1,2,3,4,5,6,7,8,0]);
  });
}

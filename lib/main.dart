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

List<List<int>> generateList(int dim) =>
    List.generate(dim, (i) => List.generate(dim, (j) => i * dim + j));

class _Board extends State<Board> {
  List<List<int>> numbers;
  _Board([int dim = 4]) {
    numbers = generateList(dim);
  }

  List<NumberBox> getWidgetAt(List<int> x) =>
      x.map((i) => NumberBox(i)).toList();
  List<TableRow> getTableRow() =>
      numbers.map((i) => TableRow(children: getWidgetAt(i))).toList();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Traveling Numbers'),
        ),
        body: Center(
            child: Table(
          border: TableBorder.all(),
          children: getTableRow(),
        )),
      );
}

class NumberBox extends StatelessWidget {
  final int value;
  NumberBox(this.value);
  @override
  Widget build(BuildContext context) => InkWell(
        child: Container(
          padding: EdgeInsets.all(20.0),
          color: Theme.of(context).secondaryHeaderColor,
          child: Center(child: Text('$value')),
        ),
        onTap: () {print('Value $value is tapped');},
      );
}

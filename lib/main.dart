// import 'dart:async';
// import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(SudokuSolverApp());
}

class SudokuSolverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku Solver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SudokuSolverScreen(),
    );
  }
}

class SudokuSolverScreen extends StatefulWidget {
  @override
  _SudokuSolverScreenState createState() => _SudokuSolverScreenState();
}

class _SudokuSolverScreenState extends State<SudokuSolverScreen> {
  List<List<int>> sudokuGrid = List.generate(9, (_) => List.filled(9, 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sudoku Solver'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9,
                ),
                itemCount: 81,
                itemBuilder: (context, index) {
                  int row = index ~/ 9;
                  int col = index % 9;
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          // color: _getBoxColor(row, col),
                          // width: _getBorderWidth(row, col),
                          ),
                    ),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty &&
                              _isValidEntry(row, col, int.parse(value))) {
                            sudokuGrid[row][col] = int.parse(value);
                          } else {
                            sudokuGrid[row][col] = 0;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value!.isNotEmpty &&
                            !_isValidEntry(row, col, int.parse(value))) {
                          return 'Wrong input';
                        }
                        return null;
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isValidEntry(int row, int col, int value) {
    for (int i = 0; i < 9; i++) {
      if (sudokuGrid[row][i] == value || sudokuGrid[i][col] == value) {
        return false;
      }
    }

    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;
    for (int i = startRow; i < startRow + 3; i++) {
      for (int j = startCol; j < startCol + 3; j++) {
        if (sudokuGrid[i][j] == value) {
          return false;
        }
      }
    }

    return true;
  }
}

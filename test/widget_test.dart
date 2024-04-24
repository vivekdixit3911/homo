import 'dart:async';
import 'dart:math';

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
  List<List<GlobalKey<FormFieldState>>> _formFieldKeys = List.generate(
      9, (_) => List.generate(9, (_) => GlobalKey<FormFieldState>()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sudoku Solver'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Enter Sudoku Puzzle:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: List.generate(9, (row) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(9, (col) {
                    return Container(
                      width: 30,
                      height: 30,
                      margin: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _getBoxColor(row, col),
                          width: _getBorderWidth(row, col),
                        ),
                      ),
                      child: TextFormField(
                        key: _formFieldKeys[row][col],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty &&
                                !_isValidEntry(row, col, int.parse(value))) {
                              _formFieldKeys[row][col].currentState!.reset();
                              _formFieldKeys[row][col].currentState!.validate();
                            }
                            if (value.isNotEmpty) {
                              sudokuGrid[row][col] = int.parse(value);
                              if (_isSudokuSolved()) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Congratulations!'),
                                    content: Text(
                                        'You have solved the Sudoku puzzle!'),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
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
                  }).toList(),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    generateSudoku(0); // Easy mode
                  },
                  child: Text('Easy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    generateSudoku(1); // Medium mode
                  },
                  child: Text('Medium'),
                ),
                ElevatedButton(
                  onPressed: () {
                    generateSudoku(2); // Hard mode
                  },
                  child: Text('Hard'),
                ),
                ElevatedButton(
                  onPressed: () {
                    solveSudoku();
                  },
                  child: Text('Solve'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getBoxColor(int row, int col) {
    if ((row < 3 && col < 3) ||
        (row >= 3 && row < 6 && col >= 3 && col < 6) ||
        (row >= 6 && col >= 6)) {
      return Colors.black; // Color for bigger boxes
    } else {
      return Colors.grey; // Color for smaller boxes
    }
  }

  double _getBorderWidth(int row, int col) {
    if (row % 3 == 0 && row != 0) {
      return 2.0;
    } else if (col % 3 == 0 && col != 0) {
      return 2.0;
    }
    return 1.0;
  }

  bool _isValidEntry(int row, int col, int value) {
    if (value == 0) {
      return true; // Empty cell is always valid
    }
    // Check row and column
    for (int i = 0; i < 9; i++) {
      if (sudokuGrid[row][i] == value || sudokuGrid[i][col] == value) {
        return false;
      }
    }

    // Check 3x3 box
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

  void generateSudoku(int difficulty) {
    sudokuGrid = List.generate(9, (_) => List.filled(9, 0));
    setState(() {
      for (int i = 0; i < 20; i++) {
        int row = _getRandomNumber(0, 8);
        int col = _getRandomNumber(0, 8);
        int num = _getRandomNumber(1, 9);
        sudokuGrid[row][col] = num;
      }
    });
  }

  int _getRandomNumber(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }

  Future<void> solveSudoku() async {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        await Future.delayed(Duration(milliseconds: 100));
        setState(() {
          sudokuGrid[i][j] = _getRandomNumber(1, 9);
        });
      }
    }
  }

  bool _isSudokuSolved() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (sudokuGrid[i][j] == 0) {
          return false;
        }
        if (!_isValidEntry(i, j, sudokuGrid[i][j])) {
          return false;
        }
      }
    }
    return true;
  }

  final _random = Random();
}

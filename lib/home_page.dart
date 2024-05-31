import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake/food_pixel.dart';
import 'package:snake/snake_pixel.dart';

import 'blank_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_Direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  int rowSize = 10;
  int totalnumberofSquares = 100;

  int currentScore = 0;

  List<int> snakePos = [
    0,
    1,
    2,
  ];
  bool gameHasStarted = false;

  var currentDirection = snake_Direction.RIGHT;

  int foodPos = 55;
  void eatFood() {
    currentScore++;
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalnumberofSquares);
    }
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 400), (timer) {
      setState(() {
        moveSnake();

        if (gameOver()) {
          timer.cancel();
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Game Over'),
                  content: Column(
                    children: [
                      Text('Tu Puntuaje Es...' + currentScore.toString()),
                      TextField(
                        decoration: InputDecoration(
                            hintText: 'Introduce el nombre del jugador'),
                      )
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        submitScore();
                        newGame();
                      },
                      child: Text('Enviar puntuación'),
                      color: Colors.yellow,
                    )
                  ],
                );
              });
        }
      });
    });
  }

  void submitScore() {
    //
  }
  void newGame() {
    setState(() {
      snakePos = [
        0,
        1,
        2,
      ];
      foodPos = 55;
      currentDirection = snake_Direction.RIGHT;
      gameHasStarted = false;
      currentScore = 0;
    });
  }

  void moveSnake() {
    switch (currentDirection) {
      case snake_Direction.RIGHT:
        {
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            snakePos.add(snakePos.last + 1);
          }
        }
        break;
      case snake_Direction.LEFT:
        {
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            snakePos.add(snakePos.last - 1);
          }
        }
        break;
      case snake_Direction.UP:
        {
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalnumberofSquares);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;
      case snake_Direction.DOWN:
        {
          if (snakePos.last + rowSize > totalnumberofSquares) {
            snakePos.add(snakePos.last + rowSize - totalnumberofSquares);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;
      default:
    }
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      snakePos.removeAt(0);
    }
  }

  bool gameOver() {
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);
    if (bodySnake.contains(snakePos.last)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Puntuación actual'),
                Text(
                  currentScore.toString(),
                  style: TextStyle(fontSize: 25),
                ),
                Text('Puntuacion...')
              ],
            )),
            Expanded(
                flex: 4,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy < 0 &&
                        currentDirection != snake_Direction.DOWN) {
                      currentDirection = snake_Direction.UP;
                      print('mover hacia arriba');
                    } else if (details.delta.dy > 0 &&
                        currentDirection != snake_Direction.UP) {
                      currentDirection = snake_Direction.DOWN;
                      print('mover hacia abajo');
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 0 &&
                        currentDirection != snake_Direction.LEFT) {
                      currentDirection = snake_Direction.RIGHT;
                      print('mover a la derecha');
                    } else if (details.delta.dx < 0 &&
                        currentDirection != snake_Direction.RIGHT) {
                      currentDirection = snake_Direction.LEFT;
                      print('mover hacia la izquierda');
                    }
                  },
                  child: GridView.builder(
                      itemCount: totalnumberofSquares,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: rowSize),
                      itemBuilder: (context, index) {
                        if (snakePos.contains(index)) {
                          return const SnakePixel();
                        } else if (foodPos == index) {
                          return const FoodPixel();
                        } else {
                          return const BlankPixel();
                        }
                      }),
                )),
            Expanded(
                child: Container(
              child: Center(
                child: MaterialButton(
                  child: Text('Play'),
                  color: gameHasStarted ? Colors.grey : Colors.red,
                  onPressed: gameHasStarted ? () {} : startGame,
                ),
              ),
            )),
          ],
        ));
  }
}

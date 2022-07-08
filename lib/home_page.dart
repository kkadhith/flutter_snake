import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snake/snake_pixel.dart';
import 'blank_pixel.dart';
import 'food_pixel.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


enum snake_Direction { UP, DOWN, LEFT, RIGHT}


class _HomePageState extends State<HomePage> {
  // Grid dimensions.
  int rowSize = 10;
  int SquareNumbers = 100;

  int score = 0;
  // snake position
  List<int> snakePos = [
    0,
    1,
    2,
  ];
  int foodPos = 55;

  // snake Direction
  var currentDirection = snake_Direction.RIGHT;

  // start game.

  void startGame() {
    // Timer
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      setState((){

        moveSnake();

      });
    });
  }

  void moveSnake() {
    switch (currentDirection) {
      case snake_Direction.RIGHT:
        {
          if ((snakePos.last - 9) %10 == 0) {
            // 22 -> 22 / 10 = 2
            snakePos.add((snakePos.last ~/ 10) * 10);
            snakePos.removeAt(0);
          }
          else {
            snakePos.add(snakePos.last + 1);
            snakePos.removeAt(0);
          }
        }
        break;
      case snake_Direction.LEFT:
        {
          if (snakePos.last % 10 == 0) {
            // 22 -> 22 / 10 = 2
            snakePos.add(snakePos.last + 9);
            snakePos.removeAt(0);
          }
          else {
            snakePos.add(snakePos.last - 1);
            snakePos.removeAt(0);
          }
        }
        break;
      case snake_Direction.UP:
        {
          if (snakePos.last <= 10) {
            snakePos.add(snakePos.last + 90);
            snakePos.removeAt(0);
          }
          else {
            snakePos.add((snakePos.last - rowSize));
            snakePos.removeAt(0);
          }
        }
        break;
      case snake_Direction.DOWN:
        {
          if (snakePos.last >= 90) {
            snakePos.add(snakePos.last - 90);
            snakePos.removeAt(0);
          }
          else {
            snakePos.add(snakePos.last + rowSize);
            snakePos.removeAt(0);
          }
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(score.toString(), style: TextStyle(color: Colors.white, fontSize: 20)),
              ],
            ),
          ),

          Expanded(
            flex: 3, // <------ this makes the "expanded" 3x larger than the others
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  currentDirection = snake_Direction.DOWN;
                }
                else if (details.delta.dy < 0) {
                  currentDirection = snake_Direction.UP;
                }
                },
              onHorizontalDragUpdate: (details) {
                  if (details.delta.dx < 0) {
                    currentDirection = snake_Direction.LEFT;
                  }
                  else if (details.delta.dx > 0) {
                    currentDirection = snake_Direction.RIGHT;
                  }
                },
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: SquareNumbers,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: rowSize),
                  itemBuilder: (context, index) {
                if (snakePos.contains(index)) {
                  if (snakePos.last == foodPos) {
                    snakePos.insert(0, snakePos.first-1);
                    score++;
                    Random random = new Random();
                    int randomNumber = random.nextInt(100);
                    foodPos = randomNumber;
                  }

                  return const SnakePixel();
                }
                else if (index == foodPos) {

                  return const FoodPixel();
                }
                else {
                  return const BlankPixel();
                }
              }),
            ),
          ),

          Expanded(
            child: Container(
              child: Center(
                child: MaterialButton(
                  child: Text("Play", style: TextStyle(color: Colors.white, fontSize: 20)),
                  color: Colors.blue,
                  onPressed: () {startGame();},
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}

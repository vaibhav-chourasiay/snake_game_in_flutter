import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snakegame/direction.dart';
import 'package:snakegame/page/controls.dart';
import 'package:snakegame/piece.dart';

class GamePage extends StatefulWidget {
  static Direction direction = Direction.right;

  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  // declear variable that used
  int? upperBoundX, upperBoundY, lowerBoundX, lowerBoundY;
  double? screenWidth, screenHight;
  int step = 30;
  List<Offset> positions = [];
  int length_of_snake = 4;
  Timer? timer;
  Piece? food;
  Offset? randomfoodposition;
  int score = 0;
  int speed = 1000;
  Direction getRamdomDirection() {
    int r = Random().nextInt(4);
    return Direction.values[r];
  }

  // it help us to repeat the getlistofposition function
  void repeat() {
    positions = [];
    length_of_snake = 4;
    score = 0;
    speed = 1000;
    GamePage.direction = getRamdomDirection();
    // print(upperBoundX);

    // positions.add(getRandomPosition());
    timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();

    repeat();
  }

  // created nearset 10 function
  // getted value is always divid by 10 % =0
  int getNearestTen(double value) {
    // here ~/ give befor desimal value ex :10.77 it give 10
    int r = (value.toInt() ~/ step) * step;
    if (r == 0) {
      r = step;
    }
    return r;
  }

  // it return Offest with random x and y position
  Offset getRandomPosition() {
    int x = Random().nextInt(upperBoundX! + step);
    int y = Random().nextInt(upperBoundY! + step);
    x = getNearestTen(x.toDouble());
    y = getNearestTen(y.toDouble());

    Offset randomPosition = Offset(x.toDouble(), y.toDouble());
    return randomPosition;
  }

  bool collusionDetector(Offset position1) {
    if (position1.dx >= upperBoundX! && GamePage.direction == Direction.right) {
      return true;
    } else if (position1.dy >= upperBoundY! &&
        GamePage.direction == Direction.bottom) {
      return true;
    }
    if (position1.dx <= lowerBoundX! && GamePage.direction == Direction.left) {
      return true;
    }
    if (position1.dy <= lowerBoundY! && GamePage.direction == Direction.top) {
      return true;
    }
    return false;
  }

  AlertDialog ad(context) {
    print("alertdialog");

    return AlertDialog(
      content: Text(
        "game over",
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            Navigator.pop(context);

            repeat();
          },
          icon: Icon(Icons.restart_alt),
          label: Text("Restart"),
        ),
      ],
    );
  }

  Future<Offset> getNextPosition(Offset position1) async {
    if (GamePage.direction == Direction.right) {
      positions[0] = Offset(position1.dx + step, position1.dy);
    } else if (GamePage.direction == Direction.top) {
      positions[0] = Offset(position1.dx, position1.dy - step);
    } else if (GamePage.direction == Direction.left) {
      positions[0] = Offset(position1.dx - step, position1.dy);
    } else if (GamePage.direction == Direction.bottom) {
      positions[0] = Offset(position1.dx, position1.dy + step);
    }
    if (collusionDetector(position1) == true) {
      timer!.cancel();
      await Future.delayed(Duration(milliseconds: 200), () {
        return showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => ad(context));
      });
      return getRandomPosition();
    }
    // print("getnextposition ${positions[0]}");

    return positions[0];
  }

  // get random food
  void radomFood() {
    if (randomfoodposition == null) {
      randomfoodposition = getRandomPosition();
      // print(randomfoodposition);
    }
    if (randomfoodposition == positions[0]) {
      // print("toach");

      length_of_snake++;
      randomfoodposition = getRandomPosition();
      score += 5;
      print(score);
    }

    food = Piece(
      color: Colors.red,
      x: randomfoodposition!.dx,
      y: randomfoodposition!.dy,
      size: step.toDouble(),
      isAnimation: true,
    );
  }

  //
  void createlistofposition() async {
    if (positions.length == 0) {
      // if positon does not have value
      // then create random positon add then in positionlist
      positions.add(getRandomPosition());
    }
    // it help us to fill the position first time
    while (length_of_snake > positions.length) {
      positions.add(positions[positions.length - 1]);
    }
    for (var i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }

    positions[0] = await getNextPosition(positions[0]);
  }

  // this return a list of piece
  List<Piece> getPieces() {
    List<Piece> pieces = [];

    // this give list of position
    createlistofposition();
    radomFood();

    for (int i = 0; i < positions.length; i++) {
      pieces.add(
        Piece(
          color: (i.isEven) ? Colors.yellow : Colors.green,
          x: positions[i].dx,
          y: positions[i].dy,
          size: step.toDouble(),
        ),
      );
    }

    return pieces;
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //here we will get width and height of screen
    screenHight = MediaQuery.of(context).size.height; //408
    screenWidth = MediaQuery.of(context).size.width; //589
    //here we set the value of lowerBound
    lowerBoundX = step;
    lowerBoundY = step;

    // set the upperbound
    upperBoundX = getNearestTen(screenWidth! - step);
    upperBoundY = getNearestTen(screenHight! - step);

    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Stack(
        children: [
          Stack(
            children: getPieces(),
          ),
          ControlPanal(),
          Container(child: food),
          Positioned(
            top: 50.0,
            right: 10.0,
            child: Text(
              score.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

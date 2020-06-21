import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'customButton.dart';

void main() => runApp(IntelliMath());

class IntelliMath extends StatefulWidget {
  @override
  _IntelliMathState createState() => _IntelliMathState();
}

class _IntelliMathState extends State<IntelliMath> {
  Random random = new Random();

  List<CustomButton> buttons;
  double timerValue = 8.0;
  double progressBarValue = 0;
  int target;
  int currentScore = 0;
  int highScore = 0;
  bool animationRunning = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "HIGH\nSCORE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),
                            ),
                            Text(
                              highScore.toString(),
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35.0),
                            ),
                          ],
                        )),
                    Column(
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Center(
                              child: Text(
                                target.toString(),
                                style: TextStyle(
                                    color: progressBarValue > 7.5 ? Colors.red : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 37.0),
                              ),
                            ),
                            Transform.rotate(
                              angle: pi / 3,
                              child: Container(
                                height: 90,
                                width: 90,
                                child: CircularProgressIndicator(
                                  strokeWidth: 10,
                                  backgroundColor: Colors.black,
                                  value: (progressBarValue / 8.0) * 0.66,
                                  valueColor: progressBarValue > 7.5
                                      ? new AlwaysStoppedAnimation<Color>(Colors.red)
                                      : new AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 70),
                              child: Text(
                                "TARGET",
                                style: TextStyle(
                                    color: progressBarValue > 7.5 ? Colors.red : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "CURRENT\nSCORE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: getWinOrLoseIndicatorColor(),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0),
                            ),
                            Text(
                              currentScore.toString(),
                              style: TextStyle(
                                  color: getWinOrLoseIndicatorColor(),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35.0),
                            ),
                          ],
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buttons[0],
                        buttons[1],
                        buttons[2],
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buttons[3],
                        buttons[4],
                        buttons[5],
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buttons[6],
                        buttons[7],
                        buttons[8],
                      ],
                    )
                  ],
                ),
              ],
            )));
  }

  @override
  void initState() {
    super.initState();
    nextRound();
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        timerValue -= 0.1;
        progressBarValue += 0.1;
        if (checkWin()) {
          currentScore += (timerValue * 10).round();
          if (currentScore > highScore) {
            highScore = currentScore;
          }
          nextRound();
        }
        if (timerValue <= 0.0) {
          currentScore = 0;
          nextRound();
        }
      });
    });
  }

  void nextRound() {
    animateProgressBarToZero();
    timerValue = 8.0;
    var tmp = random.nextInt(10) + 10;
    while (target == tmp) {
      tmp = random.nextInt(10) + 10;
    }
    target = tmp;

    buttons = generateNewButtons(target, random.nextInt(4) + 2);
  }

  List<CustomButton> generateNewButtons(int target, int summandsNumber) {
    int quotient = (target / summandsNumber).round();
    List<int> summands = List.generate(summandsNumber, (index) => quotient);
    while (addUp(summands) != target) {
      if (addUp(summands) < target) {
        summands[random.nextInt(summandsNumber - 1)]++;
      } else {
        summands[random.nextInt(summandsNumber - 1)]--;
      }
    }
    List<int> buttonNumbers = List.generate(9, (index) => -1);

    for (int i = 0; i < summandsNumber; i++) {
      int index = random.nextInt(9);
      while (buttonNumbers[index] != -1) {
        index = random.nextInt(9);
      }
      buttonNumbers[index] = summands[i];
    }
    for (int i = 0; i < 9; i++) {
      if (buttonNumbers[i] == -1) {
        int randomNumber = random.nextInt(7) + (quotient - 3);
        buttonNumbers[i] = randomNumber < 1 ? 1 : randomNumber;
      }
    }
    return List.generate(9, (index) => CustomButton(buttonNumbers[index]));
  }

  int addUp(List<int> list) {
    int ret = 0;
    list.forEach((element) {
      ret += element;
    });
    return ret;
  }

  bool checkWin() {
    int value = 0;
    buttons.forEach((element) {
      if (element.isSelected) {
        value += element.number;
      }
    });
    return value == target;
  }

  void animateProgressBarToZero() {
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (progressBarValue > (8 - timerValue)) {
        animationRunning = true;
        setState(() {
          progressBarValue -= 0.1;
        });
      } else {
        timer.cancel();
        animationRunning = false;
      }
    });
  }

  Color getWinOrLoseIndicatorColor() {
    if (animationRunning) {
      if (currentScore > 0) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    } else {
      return Colors.white;
    }
  }
}

import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  int number;
  bool isSelected;

  CustomButton(int number) {
    this.number = number;
    this.isSelected = false;
  }

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  Image buttonNotSelected = Image(image: AssetImage('res/button_not_selected.png'), width: 100, fit: BoxFit.cover, height: 100);
  Image buttonSelected = Image(image: AssetImage('res/button_selected.png'), width: 100, fit: BoxFit.cover, height: 100);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleSelectedState,
      child: Stack(alignment: Alignment.center, children: <Widget>[
        Container(alignment: Alignment.center, padding: EdgeInsets.all(5.0), child: widget.isSelected ? buttonSelected : buttonNotSelected),
        Center(
            child: Text(
          widget.number.toString(),
          style: TextStyle(color: widget.isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 37.0),
        ))
      ]),
    );
  }

  void toggleSelectedState() {
    setState(() {
      widget.isSelected = !widget.isSelected;
    });
  }
}

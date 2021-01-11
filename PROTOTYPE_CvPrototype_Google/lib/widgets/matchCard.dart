import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  final Color _color;
  final Color _fontColor;
  final int _margin;
  final String _text;
  final IconData _icon;
  final Function _removeCard;
  final int index;

  MatchCard(this._color, this._fontColor, this._icon, this._margin, this._text,
      this.index, this._removeCard);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _margin.toDouble(),
      child: Draggable(
        onDragEnd: (drag) {
          _removeCard(index);
        },
        childWhenDragging: Container(),
        feedback: Card(
          elevation: 12,
          color: _color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: 240,
            height: 300,
          ),
        ),
        child: Card(
          elevation: 12,
          color: _color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: 240,
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Icon(
                        _icon,
                        size: 70,
                        color: _fontColor,
                      ),
                    ),
                  ),
                  Center(
                      child: Text(
                    _text,
                    style: TextStyle(fontSize: 20, color: _fontColor),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

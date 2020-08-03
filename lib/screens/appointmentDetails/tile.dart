import 'package:flutter/material.dart';

import '../../utils.dart';

class Tile extends StatelessWidget {
  final String date;
  final String message;
  final Color color;
  final Widget buttonBar;
  final bool reverse;

  Tile({
    @required this.date,
    @required this.message,
    @required this.color,
    this.reverse = false,
    this.buttonBar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Text(
            date,
            textAlign: TextAlign.center,
            style: XS,
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(right: 5.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5.0),
                bottomLeft: Radius.circular(5.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 5.0,
                      top: 15.0,
                      bottom: 15.0,
                    ),
                    child: Text(
                      message,
                      style: M.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                buttonBar != null ? buttonBar : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

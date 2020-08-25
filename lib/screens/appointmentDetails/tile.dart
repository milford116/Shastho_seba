import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils.dart';
import '../../models/timeline.dart';

class Tile extends StatelessWidget {
  final Timeline timeline;
  final void Function() onCancelAppointment;
  final void Function() onViewTransactions;
  final void Function() onShowPrescription;

  Tile({
    this.timeline,
    this.onCancelAppointment,
    this.onViewTransactions,
    this.onShowPrescription,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Text(
            DateFormat('MMM dd\nyyyy').format(timeline.appointmentDate),
            textAlign: TextAlign.center,
            style: XS,
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: Column(
            children: [
              SideTile(
                message:
                    'You created the appointment on ${DateFormat.yMMMMd('en_US').format(timeline.appointmentCreatedAt)}.',
                color: lightBlue,
                buttonVisible: !timeline.hasTransaction,
                buttonText: 'Cancel',
                buttonColor: blue,
                onPressed: onCancelAppointment,
              ),
              SizedBox(
                height: 5.0,
              ),
              SideTile(
                message: 'You have ${timeline.due}/- due.',
                color: timeline.due > 0 ? lightRed : lightMint,
                buttonVisible: true,
                buttonText: 'View',
                buttonColor: timeline.due > 0 ? red : mint,
                onPressed: onViewTransactions,
              ),
              SizedBox(
                height: 5.0,
              ),
              if (timeline.hasPrescription)
                SideTile(
                  message: 'The Doctor has given you a prescription.',
                  color: lightPurple,
                  buttonVisible: true,
                  buttonText: 'View',
                  onPressed: onShowPrescription,
                  buttonColor: purple,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class SideTile extends StatelessWidget {
  final String message;
  final Color color;
  final bool buttonVisible;
  final Color buttonColor;
  final String buttonText;
  final void Function() onPressed;

  SideTile({
    @required this.message,
    @required this.color,
    @required this.buttonVisible,
    @required this.buttonColor,
    @required this.buttonText,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(5.0),
          bottomLeft: Radius.circular(5.0),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              message,
              style: M.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 2.0,
          ),
          if (buttonVisible)
            FlatButton(
              color: buttonColor,
              visualDensity: VisualDensity.compact,
              onPressed: onPressed,
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

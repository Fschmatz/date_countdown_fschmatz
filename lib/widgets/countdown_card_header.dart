import 'package:flutter/material.dart';

import '../classes/countdown.dart';

class CountdownCardHeader extends StatelessWidget {
  final Countdown countdown;
  final String countdownText;
  final Color textColor;
  final Icon icon;

  const CountdownCardHeader({
    Key? key,
    required this.countdown,
    required this.countdownText,
    required this.textColor,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      dense: true,
      title: Text(
        countdownText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: textColor),
      ),
      trailing: icon,
      subtitle: Text(
        countdown.getDateFormatted(),
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColor),
      ),
    );
  }
}

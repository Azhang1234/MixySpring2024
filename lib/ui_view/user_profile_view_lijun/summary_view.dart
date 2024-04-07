import 'package:flutter/material.dart';
import '../../mixy_app_theme.dart'; // Ensure this import is correct for your theme data

class SummaryView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String summaryText; // Add this line

  const SummaryView({
    Key? key,
    this.animationController,
    this.animation,
    required this.summaryText, // Modify this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              summaryText, // Use the summaryText passed to the widget
              style: TextStyle(
                fontSize: 16,
                color: MixyAppTheme.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

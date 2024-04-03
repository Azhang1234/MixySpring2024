import 'package:flutter/material.dart';
import '../../mixy_app_theme.dart'; // Ensure this import is correct for your theme data

class SummaryView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const SummaryView({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation!,
      child: Padding(
        padding:
            const EdgeInsets.all(16.0), // Adjust padding to match your design
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Here is a brief summary of the user profile. Update this text with actual user data.",
              style: TextStyle(
                fontSize: 16, // Adjust font size to match your design
                color: MixyAppTheme.grey, // Adjust color to match your theme
              ),
            ),
          ],
        ),
      ),
    );
  }
}

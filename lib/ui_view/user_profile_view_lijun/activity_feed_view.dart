// TODO Implement this library.

import 'package:flutter/material.dart';

class ActivityFeedView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const ActivityFeedView({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation!,
      child: Container(
        // Placeholder for activity feed UI
        height: 300, // Example height
        color: Colors.red, // Example color
        child: Center(
          child: Text("Activity Feed View"),
        ),
      ),
    );
  }
}

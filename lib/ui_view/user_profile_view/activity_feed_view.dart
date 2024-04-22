// TODO Implement this library.

import 'package:flutter/material.dart';

class ActivityFeedView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const ActivityFeedView({super.key, this.animationController, this.animation});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation!,
      child: Container(
        // Placeholder for activity feed UI
        height: 300, // Example height
        color: Colors.red, // Example color
        child: const Center(
          child: Text("Activity Feed View"),
        ),
      ),
    );
  }
}

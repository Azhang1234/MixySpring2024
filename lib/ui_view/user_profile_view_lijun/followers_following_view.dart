// TODO Implement this library.

import 'package:flutter/material.dart';

class FollowersFollowingView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const FollowersFollowingView(
      {Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation!,
      child: Container(
        // Placeholder for followers/following UI
        height: 100, // Example height
        color: Colors.yellow, // Example color
        child: Center(
          child: Text("Followers & Following View"),
        ),
      ),
    );
  }
}

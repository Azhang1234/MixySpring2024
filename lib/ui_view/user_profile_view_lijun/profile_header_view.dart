import 'package:flutter/material.dart';
import '../../mixy_app_theme.dart';

class ProfileHeaderView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const ProfileHeaderView({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation!,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Container(
            height: 150, // Adjust the height as per your design
            child: Center(
              child: CircleAvatar(
                radius:
                    75, // This radius is half of the height for a perfect circle
                backgroundColor:
                    Colors.grey[300], // A light grey, similar to the mockup
                child: Text(
                  '150 x 150',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Text(
            "User Name",
            style: TextStyle(
              color: Colors.black, // Adjust text color to match your theme
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

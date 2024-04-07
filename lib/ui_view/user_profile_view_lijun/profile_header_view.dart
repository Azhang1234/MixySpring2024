import 'package:flutter/material.dart';
import '../../mixy_app_theme.dart';
import '../../userScreen_lijun/user_profile_update.dart';

class ProfileHeaderView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String imageUrl;

  const ProfileHeaderView({
    Key? key,
    this.animationController,
    this.animation,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _ProfileHeaderViewState createState() => _ProfileHeaderViewState();
}

class _ProfileHeaderViewState extends State<ProfileHeaderView> {
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.animation!,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Container(
            height: 150,
            child: Center(
              child: GestureDetector(
                //should direct to profile update page when long pressed
                onLongPress: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileUpdatePage(),
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    widget.imageUrl,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // Other children...
        ],
      ),
    );
  }
}

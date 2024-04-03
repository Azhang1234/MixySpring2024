import 'package:flutter/material.dart';
import 'package:mixyspring2024/mixy_app_theme.dart';

class SearchBarView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final Function(String)? onSubmitted;

  const SearchBarView({
    Key? key,
    this.animationController,
    this.animation,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 8, bottom: 8),
                child: TextField(
                  onSubmitted: onSubmitted,
                  style: TextStyle(
                    fontFamily: MixyAppTheme.fontName,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: MixyAppTheme.darkText,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Add Your Ingredient Here',
                    fillColor: MixyAppTheme.background,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          25.0), // Increase this value for more rounded corners
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: MixyAppTheme.darkText,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

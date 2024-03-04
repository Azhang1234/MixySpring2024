import 'package:flutter/material.dart';
import 'package:mixyspring2024/main.dart';
import '../mixy_app_theme.dart';

class WorkoutView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const WorkoutView({Key? key, this.animationController, this.animation})
      : super(key: key);

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
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    MixyAppTheme.nearlyDarkBlue,
                    HexColor("#6F56E8")
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: MixyAppTheme.grey.withOpacity(0.6),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Current Drink',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: MixyAppTheme.fontName,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          letterSpacing: 0.0,
                          color: MixyAppTheme.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Vodka Sprite',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: MixyAppTheme.fontName,
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            letterSpacing: 0.0,
                            color: MixyAppTheme.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.timer,
                                color: MixyAppTheme.white,
                                size: 16,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Text(
                                '68 min',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: MixyAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  color: MixyAppTheme.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            /*Container(
                              decoration: BoxDecoration(
                                color: MixyAppTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: MixyAppTheme.nearlyBlack
                                          .withOpacity(0.4),
                                      offset: const Offset(8.0, 8.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.arrow_right,
                                  color: HexColor("#6F56E8"),
                                  size: 44,
                                ),
                              ),
                            )*/
                          ],
                        ),
                      )
                    ],
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

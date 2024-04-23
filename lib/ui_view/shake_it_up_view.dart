import 'package:flutter/material.dart';

import '../mixy_app_theme.dart';

class ShakeItUpListView extends StatefulWidget {
  const ShakeItUpListView(
      {super.key, this.mainScreenAnimationController, this.mainScreenAnimation});

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  @override
  _ShakeItUpViewState createState() => _ShakeItUpViewState();
}

class _ShakeItUpViewState extends State<ShakeItUpListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<String> areaListData = <String>[
    'assets/mixy_app/resized_lilbill.png'
  ];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
               child: Container(
  width: 200,
  height: 200,
  decoration: BoxDecoration(
    border: Border.all(color: Colors.red, width: 2), // Visual debugging
  ),
                child: SizedBox(width: 100, height: 100,
                  child: GridView(
                    padding: const EdgeInsets.only(
                        left: 50, right: 50, top: 50, bottom: 50),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // changed from 3 to 1
                      mainAxisSpacing: 100.0,
                      crossAxisSpacing: 25.0,
                      childAspectRatio: 1.0,
                    ),
                    children: List<Widget>.generate(
                      areaListData.length,
                      (int index) {
                        final int count = areaListData.length;
                        final Animation<double> animation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animationController!,
                            curve: Interval((1 / count) * index, 1.0,
                                curve: Curves.fastOutSlowIn),
                          ),
                        );
                        animationController?.forward();
                        return AreaView(
                          imagepath: areaListData[index],
                          animation: animation,
                          animationController: animationController!,
                          index: index,
                        );
                      },
                    ),
                  ),
              ),
            ),
          ),
          ), // changed
        ),
        );
      },
    );
  }
}

class AreaView extends StatelessWidget {
  const AreaView({
    super.key,
    this.imagepath,
    this.animationController,
    this.animation,
    required this.index,
  });

  final String? imagepath;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: MixyAppTheme.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: MixyAppTheme.grey.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  splashColor: MixyAppTheme.nearlyDarkBlue.withOpacity(0.2),
                  onTap: () {print('Item $index was tapped!');},
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Image.asset(imagepath!),
                      ),
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

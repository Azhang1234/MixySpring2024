import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../mixy_app_theme.dart';

class AddButtonView extends StatefulWidget {
  const AddButtonView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  @override
  _AddButtonViewState createState() => _AddButtonViewState();
}

class _AddButtonViewState extends State<AddButtonView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<bool> toggleStates = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  auth.User? get user => auth.FirebaseAuth.instance.currentUser;
  String? get userId => user?.uid;
  
  List<String> areaListData = <String>[
    'assets/mixy_app/snack.png',
    'assets/mixy_app/mixyLogo.png',
    'assets/mixy_app/mixyLogo.png',
    'assets/mixy_app/mixyLogo.png',
    'assets/mixy_app/runner.png',
    'assets/mixy_app/snack.png'
  ];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    // initialize toggleStates with false for each item
    toggleStates = List<bool>.filled(areaListData.length, false);
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final bool isToggled = context.findAncestorStateOfType<_AddButtonViewState>()!.toggledItems.contains(index);
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: GridView(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,
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
                        isToggled: toggleStates[index],
                        onToggle: () {
                          // toggles the state of the tapped item
                          setState(() {
                            // Check if the current item is already toggled on
                            bool isCurrentlyToggled = toggleStates[index];

                            // reset the toggle states for items in the same group
                            // top row group: index 0, 1, 2
                            // bottom row group: index 3, 4, 5
                            if (index >= 0 && index <= 2) {
                              for (int i = 0; i <= 2; i++) {
                                toggleStates[i] = false;
                              }
                            } else if (index >= 3 && index <= 5) {
                              for (int i = 3; i <= 5; i++) {
                                toggleStates[i] = false;
                              }
                            }

                            // toggle the selected item only if it was not already toggled on
                            // this allows turning an option off by clicking on it again
                            // NECESSARY FOR SINGLE SELECTION; USERS CAN OPT FOR NO OPTIONS...
                            toggleStates[index] = !isCurrentlyToggled;
                            if (toggleStates[0] == true){
                              _firestore.collection('Users').doc(userId).collection('CurrentDrinkRequests').doc(userId).set({
                                'OptionalPreferences': 'Sweet'
                              }, SetOptions(merge: true));
                            } else if (toggleStates[1] == true){
                              _firestore.collection('Users').doc(userId).collection('CurrentDrinkRequests').doc(userId).set({
                                'OptionalPreferences': 'Sour'
                              }, SetOptions(merge: true));
                            } else if (toggleStates[2] == true){
                              _firestore.collection('Users').doc(userId).collection('CurrentDrinkRequests').doc(userId).set({
                                'OptionalPreferences': 'Bitter'
                              }, SetOptions(merge: true));
                            }

                            if (toggleStates[3] == true){
                              _firestore.collection('Users').doc(userId).collection('CurrentDrinkRequests').doc(userId).set({
                                'AlcoholStrength': 'Low'
                              }, SetOptions(merge: true));
                            } else if (toggleStates[4] == true){
                              _firestore.collection('Users').doc(userId).collection('CurrentDrinkRequests').doc(userId).set({
                                'AlcoholStrength': 'Medium'
                              }, SetOptions(merge: true));
                            } else if (toggleStates[5] == true){
                              _firestore.collection('Users').doc(userId).collection('CurrentDrinkRequests').doc(userId).set({
                                'AlcoholStrength': 'High'
                              }, SetOptions(merge: true));
                            }

                            // prints the index of the toggled item (debugging purposes)
                            print('Item $index was toggled!');
                          });
                        },
                      );
                    },
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

class AreaView extends StatelessWidget {
  const AreaView({
    Key? key,
    this.imagepath,
    this.animationController,
    this.animation,
    required this.index,
    required this.isToggled,
    this.onToggle,
  }) : super(key: key);

  final String? imagepath;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final int index;
  final bool isToggled;
  final VoidCallback? onToggle;
  
  // get isToggled => null;

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
                color: isToggled ? MixyAppTheme.nearlyDarkBlue : MixyAppTheme.white,
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
                  onTap: () {
                    // toggles the state of the tapped item
                    onToggle?.call();

                    // prints the index of the tapped item (debugging purposes)
                    print('Item $index was tapped!');
                    },
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


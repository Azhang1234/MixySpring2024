import 'package:flutter/material.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'mixy_app_theme.dart';
import 'models/tabIcon_data.dart';
import 'ingredient_lijun/ingredient_screen.dart';
import 'mixing/mixing_screen.dart';
import 'community/community_screen.dart';
import 'userScreen_lijun/user_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_button/add_button_screen.dart';

class MixyAppHomeScreen extends StatefulWidget {
  const MixyAppHomeScreen({super.key});

  @override
  _MixyAppHomeScreenState createState() => _MixyAppHomeScreenState();
}

class _MixyAppHomeScreenState extends State<MixyAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: MixyAppTheme.background,
  );

  @override
  void initState() {
    for (var tab in tabIconsList) {
      tab.isSelected = false;
    }

    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = IngredientScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MixyAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            animationController?.reverse().then<dynamic>((data) {
              if (!mounted) {
                return;
              }
              setState(() {
                tabBody =
                    AddButtonScreen(animationController: animationController);
              });
            });
          },
          changeIndex: (int index) {
            if (index == 0) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = IngredientScreen(
                      animationController: animationController);
                });
              });
            } else if (index == 1) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      MixingScreen(animationController: animationController);
                });
              });
            } else if (index == 2) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      CommunityScreen(animationController: animationController);
                });
              });
            } else if (index == 3) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = UserProfileScreen(
                      animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}

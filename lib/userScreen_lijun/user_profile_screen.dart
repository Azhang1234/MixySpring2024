import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:mixyspring2024/localJsonBackend_lijun/drink_request_manager.dart';
import 'package:mixyspring2024/mixy_app_theme.dart';
import 'user_drinks.dart';
import '../ui_view/Ingredient_ui_lijun/title_view.dart';
import '../ui_view/user_profile_view_lijun/profile_header_view.dart';
import '../ui_view/user_profile_view_lijun/summary_view.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key, this.animationController})
      : super(key: key);

  final AnimationController? animationController;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  // final dataManager = DataManager();

  double topBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    // refreshData();
    addAllListData();
    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
  }

  void addAllListData() {
    const int count =
        9; // Adjust based on your actual widgets count for the user profile

    // Example to add ProfileHeaderView with animation and dynamic image URL
    listViews.add(
      ProfileHeaderView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval((1 / count) * 0, 1.0,
                curve: Curves.fastOutSlowIn),
          ),
        ),
        animationController: widget.animationController,
      ),
    );
// Example to add SummaryView with animation and dynamic text
    listViews.add(
      SummaryView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval((1 / count) * 1, 1.0,
                curve: Curves.fastOutSlowIn),
          ),
        ),
        animationController: widget.animationController,
        summaryText:
            'Your dynamic bio text passed from here.', // Add your dynamic summary text here
      ),
    );
// Add other views (ActivityFeedView, FollowersFollowingView) similarly...

    listViews.add(
      TitleView(
        titleTxt: 'Your Drinks',
        subTxt: 'Instructions',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval((1 / count) * 4, 1.0,
                curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      AreaListView(
        mainScreenAnimationController: widget.animationController,
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval((1 / count) * 5, 1.0,
                curve: Curves.fastOutSlowIn),
          ),
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MixyAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await auth.FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
        /*
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String cocktailRecommendation = '';

            cocktailRecommendation = await getCocktailRecommendation(
              ingredients: ["vodka", "lime", "ginger beer"],
              typeOfAlcohol: 'vodka',
              occasion: 'summer party',
              complexity: 'easy',
            );
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Cocktail Recommendation"),
                  content: Text(cocktailRecommendation),
                  actions: [
                    TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.local_bar),
          tooltip: 'Get Cocktail Recommendation',
        ),
      */
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }
}

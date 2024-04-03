import 'package:flutter/material.dart';
import 'package:mixyspring2024/mixy_app_theme.dart';

import '../ui_view/Ingredient_ui_lijun/area_list_view.dart';
import '../ui_view/Ingredient_ui_lijun/title_view.dart';
import '../ui_view/user_profile_view_lijun/profile_header_view.dart';
import '../ui_view/user_profile_view_lijun/summary_view.dart';
import '../ui_view/user_profile_view_lijun/activity_feed_view.dart';
import '../ui_view/user_profile_view_lijun/followers_following_view.dart';

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
  double topBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
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
        4; // Adjust based on your actual widgets count for the user profile

    // Example to add ProfileHeaderView with animation
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

    // Add other views (SummaryView, ActivityFeedView, FollowersFollowingView) similarly...
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
      ),
    );
    listViews.add(
      TitleView(
        titleTxt: 'Favorites',
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
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: const Interval((1 / count) * 2, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController!,
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
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
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

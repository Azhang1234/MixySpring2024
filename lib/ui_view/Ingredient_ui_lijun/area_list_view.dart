import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../mixy_app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AreaListView extends StatefulWidget {
  const AreaListView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  @override
  _AreaListViewState createState() => _AreaListViewState();
}

class _AreaListViewState extends State<AreaListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  auth.User? get user => auth.FirebaseAuth.instance.currentUser;
  String? get userId => user?.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  Future<void> _removeIngredientFromCurrentRequest(String ingredientName) async {
    // Retrieve the current CurrentDrinkRequest document
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await _firestore.collection('Users').doc(userId).collection('CurrentDrinkRequests').doc(userId).get();

    Map<String, dynamic> data = docSnapshot.data()!;
    List<dynamic> ingredients = data['Ingredients'];

    // Remove the ingredient from the list
    ingredients.remove(ingredientName);

    // Update the CurrentDrinkRequest document
    await _firestore.collection('Users').doc(userId).collection('CurrentDrinkRequests').doc(userId).update({'Ingredients': ingredients});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _firestore.collection('Users').doc(userId).collection('CurrentDrinkRequests').doc(userId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final ingredients = snapshot.data!.data()!['Ingredients'] as List<dynamic>;

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
                    child: GridView(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 16, bottom: 16),
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12.0,
                        crossAxisSpacing: 12.0,
                        childAspectRatio: 1.0,
                      ),
                      children: List<Widget>.generate(
                        ingredients.length,
                        (int index) {
                          final int count = ingredients.length;
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
                            ingredientName: ingredients[index],
                            animation: animation,
                            animationController: animationController!,
                            onRemove: () => _removeIngredientFromCurrentRequest(ingredients[index]),
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
      },
    );
  }
}

class AreaView extends StatelessWidget {
  const AreaView({
    Key? key,
    this.ingredientName,
    this.animationController,
    this.animation,
    this.onRemove,
  }) : super(key: key);

  final String? ingredientName;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final VoidCallback? onRemove;
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
                // color: MixyAppTheme.white,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.orange, Colors.deepOrange],
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: MixyAppTheme.grey.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        ingredientName!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "",
                        style: TextStyle(
                          color: Color.fromARGB(255, 93, 89,
                              80), // Choose a color that stands out
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 1,
                    top: 1,
                    child: FloatingActionButton(
                      onPressed: onRemove,
                      child: Icon(Icons.remove),
                      mini: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
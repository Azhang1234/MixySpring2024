import 'package:flutter/material.dart';
import 'package:mixyspring2024/models/ingredients.dart';
import '../../main.dart';
import '../mixy_app_theme.dart';
import '../models/meals_list_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class IngredientSelectView extends StatefulWidget {
  const IngredientSelectView({
    Key? key,
    this.mainScreenAnimationController,
    this.mainScreenAnimation,
  }) : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;


  @override
  _IngredientSelectViewState createState() => _IngredientSelectViewState();
}

class _IngredientSelectViewState extends State<IngredientSelectView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  late List<Ingredient> ingredients;
  auth.User? get user => auth.FirebaseAuth.instance.currentUser;  
  String? get userId => user?.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Stream<List<Ingredient>> getIngredients() {
    return firestore.collection('Users').doc(userId).collection("AvailableIngredients").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Ingredient.fromSnapshot(doc)).toList();
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Ingredient>>(
      stream: getIngredients(),
      builder: (BuildContext context, AsyncSnapshot<List<Ingredient>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          ingredients = snapshot.data!;
          return AnimatedBuilder(
            animation: widget.mainScreenAnimationController!,
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: widget.mainScreenAnimation!,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
                  child: SizedBox(
                    height: 216,
                    width: double.infinity,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                          top: 0, bottom: 0, right: 16, left: 16),
                      itemCount: ingredients.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        final int count =
                            ingredients.length > 10 ? 10 : ingredients.length;
                        final Animation<double> animation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: animationController!,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn)));
                        animationController?.forward();

                        return IngredientView(
                          ingredient: ingredients[index],
                          animation: animation,
                          animationController: animationController!,
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

class IngredientView extends StatelessWidget {
  const IngredientView({
    Key? key,
    required this.animationController,
    required this.animation,
    required this.ingredient,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: SizedBox(
              width: 130,
              child: Stack(
                children: <Widget>[
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            ingredient.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Add more details about the ingredient here
                        ],
                      ),
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
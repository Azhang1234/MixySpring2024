import 'package:flutter/material.dart';
import 'package:mixyspring2024/localJsonBackend_lijun/drink_request_manager.dart';
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

  List<Ingredient> selectedIngredients = [];

  void _addIngredientToSelectedIngredients(Ingredient ingredient) {
    setState(() {
      selectedIngredients.add(ingredient);
    });
  }

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
          if (ingredients.isEmpty) {
            return Center(
              child: Text('No Available Ingredients Selected'),
            );
        } else {
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

  auth.User? get user => auth.FirebaseAuth.instance.currentUser;  
  String? get userId => user?.uid;

Future<void> _addIngredientToCurrentRequest(String value) async {
    final ingredient = Ingredient(name: value);
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Retrieve the current CurrentDrinkRequest document
    QuerySnapshot querySnapshot = await firestore.collection('Users').doc(userId).collection('CurrentDrinkRequests').get();

    CurrentDrinkRequest currentDrinkRequest;

    if (querySnapshot.docs.isNotEmpty) {
      // If a CurrentDrinkRequest document exists, create a CurrentDrinkRequest object from the document
      currentDrinkRequest = CurrentDrinkRequest.fromJson(querySnapshot.docs.first.data() as Map<String, dynamic>);
    } else {
      // If no CurrentDrinkRequest document exists, create a new CurrentDrinkRequest object
      currentDrinkRequest = CurrentDrinkRequest(ingredients: [], optionalPreferences: "", alcoholStrength:"");
    }

    // Check if the ingredient already exists in the CurrentDrinkRequest object
    if (!currentDrinkRequest.ingredients.contains(ingredient.name)) {
      // If the ingredient does not exist, add it to the CurrentDrinkRequest object
      currentDrinkRequest.ingredients.add(ingredient.name);

      // Write the CurrentDrinkRequest object to Firestore
      await firestore.collection('Users').doc(userId).collection('CurrentDrinkRequests').doc(userId).set(currentDrinkRequest.toJson());
    }
}

  Future<void> _removeIngredientFromAvaialbleIngredients(String value) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collection('Users').doc(userId).collection('AvailableIngredients').where('name', isEqualTo: value).get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;
      await firestore.collection('Users').doc(userId).collection('AvailableIngredients').doc(docId).delete();
    }
  }

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
            child: Container(
              width: 130,
              child: Stack(
                children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 10,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Center(
                              child: Text(
                                ingredient.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          // Add more details about the ingredient here
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: FloatingActionButton(
                      onPressed: () {
                        _addIngredientToCurrentRequest(ingredient.name);
                      },
                      child: Icon(Icons.add),
                      mini: true,
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: FloatingActionButton(
                      onPressed: () {
                        _removeIngredientFromAvaialbleIngredients(ingredient.name);
                      },
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
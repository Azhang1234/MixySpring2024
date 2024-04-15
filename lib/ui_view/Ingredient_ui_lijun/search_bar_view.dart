import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mixyspring2024/mixy_app_theme.dart';
import 'package:mixyspring2024/models/ingredients.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchBarView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  

  SearchBarView({
    Key? key,
    this.animationController,
    this.animation,
  }) : super(key: key);

  @override
  _SearchBarViewState createState() => _SearchBarViewState();
}

class _SearchBarViewState extends State<SearchBarView> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GlobalKey<AutoCompleteTextFieldState<Ingredient>> key = GlobalKey();
  
  List<Ingredient> _results = [];
  User? get user => FirebaseAuth.instance.currentUser;
  String? get userId => user?.uid;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Future<void> _addIngredient() async {
    final String value = _controller.text;

    final ingredient = Ingredient(name: value);

    await _firestore.collection('Users').doc(userId).collection('Ingredients').add(ingredient.toJson());

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 8, bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: AutoCompleteTextField<Ingredient>(
                            key: key,
                            suggestions: _results,
                            itemFilter: (item, query) {
                              return item.name.toLowerCase().startsWith(query.toLowerCase());
                            },
                            itemSorter: (a, b) {
                              return a.name.compareTo(b.name);
                            },
                            itemBuilder: (context, item) {
                              return Container(
                                padding: EdgeInsets.all(20.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      item.name,
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              );
                            },
                            controller: _controller,
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
                            ), itemSubmitted: (item) { 
                                _controller.text = item.name;
                             },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: _addIngredient,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
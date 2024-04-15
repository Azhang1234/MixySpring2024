import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mixyspring2024/mixy_app_theme.dart';
import 'package:mixyspring2024/models/ingredients.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  List<Ingredient> _results = [];

  @override
  void initState() {
    super.initState();

    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _onTextChanged() async {
    final String value = _controller.text;

    final QuerySnapshot snapshot = await _firestore.collection('ingredients').where('name', isGreaterThanOrEqualTo: value).get();

    final List<Ingredient> results = snapshot.docs.map((doc) {
      if (doc.exists) {
        return Ingredient.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    }).where((ingredient) => ingredient != null).cast<Ingredient>().toList();

    setState(() {
      _results = results;
    });
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
                    child: TextField(
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
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _results.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Ingredient ingredient = _results[index];

                    return ListTile(
                      title: Text(ingredient.name),
                      // ... other properties ...
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
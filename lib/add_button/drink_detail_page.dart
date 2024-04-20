import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../localJsonBackend_lijun/drink_request_manager.dart';

class DrinkDetailScreen extends StatefulWidget {
  final Drink drink;

  const DrinkDetailScreen({Key? key, required this.drink}) : super(key: key);

  @override
  _DrinkDetailScreenState createState() => _DrinkDetailScreenState();
}

class _DrinkDetailScreenState extends State<DrinkDetailScreen> {
  final auth.User? user = auth.FirebaseAuth.instance.currentUser;
  bool isFavorite = false;
  late List<bool> stepChecklist; // To keep track of the completed steps

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
    // Initialize the checklist based on the number of instructions.
    stepChecklist = List<bool>.filled(
        widget.drink.instructions.split(RegExp(r'\d+\.\s')).length - 1, false);
  }

  void checkFavoriteStatus() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentSnapshot<Map<String, dynamic>> drinkSnapshot = await firestore
        .collection('Users')
        .doc(user?.uid)
        .collection("Drinks")
        .doc(widget.drink.drinkID)
        .get();

    if (drinkSnapshot.exists && drinkSnapshot.data()?['Favorite'] == true) {
      setState(() {
        isFavorite = true;
      });
    }
  }

  void toggleFavorite() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference<Map<String, dynamic>> drinkRef = firestore
        .collection('Users')
        .doc(user?.uid)
        .collection("Drinks")
        .doc(widget.drink.drinkID);

    firestore.runTransaction((transaction) async {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await transaction.get(drinkRef);

      if (snapshot.exists) {
        // The document exists, so we update it.
        bool currentFavorite = snapshot.data()?['Favorite'] ?? false;
        transaction.update(drinkRef, {'Favorite': !currentFavorite});
        Fluttertoast.showToast(
            msg: currentFavorite
                ? 'Removed from favorites.'
                : 'Added to favorites!');
      } else {
        // The document does not exist, so we create it for the first time.
        transaction
            .set(drinkRef, {'Name': widget.drink.name, 'Favorite': true});
        Fluttertoast.showToast(msg: 'Added to favorites!');
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: 'Failed to update favorite status: $e');
    });

    // Update the local state to reflect the change.
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> steps = widget.drink.instructions
        .split(RegExp(r'\d+\.\s'))
        .where((step) => step.isNotEmpty)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.drink.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Ingredients:', style: Theme.of(context).textTheme.headline6),
            ...widget.drink.ingredients
                .map((ingredient) => Text('- $ingredient'))
                .toList(),
            SizedBox(height: 20),
            Text('Instructions:', style: Theme.of(context).textTheme.headline6),
            ...List<Widget>.generate(steps.length, (index) {
              return CheckboxListTile(
                title: Text(steps[index].trim()),
                value: stepChecklist[index],
                onChanged: (bool? value) {
                  setState(() {
                    stepChecklist[index] = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              );
            }),
            SizedBox(height: 20),
            Text('Equipment:', style: Theme.of(context).textTheme.headline6),
            ...widget.drink.equipments
                .map((equipment) => Text('- $equipment'))
                .toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        onPressed: toggleFavorite,
      ),
    );
  }
}

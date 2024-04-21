import 'package:flutter/material.dart';
import '../localJsonBackend_lijun/drink_request_manager.dart';
import '../mixy_app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import '../mixy_app_theme.dart';

class DrinksListView extends StatefulWidget {
  @override
  _DrinksListViewState createState() => _DrinksListViewState();
}

class _DrinksListViewState extends State<DrinksListView> {
  List<Drink> drinks = [];
  final dataManager = DataManager();
  @override
  void initState() {
    super.initState();
    loadDrinks();
  }

  void loadDrinks() async {
    drinks = await dataManager.getDrinks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: drinks.length,
      itemBuilder: (context, index) {
        return DrinkView(drink: drinks[index]);
      },
    );
  }
}

class DrinkView extends StatelessWidget {
  const DrinkView({
    Key? key,
    required this.drink,
  }) : super(key: key);

  final Drink drink;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(drink.name, style: TextStyle(fontSize: 16)),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon:
                  Icon(drink.favorite ? Icons.favorite : Icons.favorite_border),
              color: Colors.red,
              onPressed: () {
                // Here you can add functionality to toggle favorite status in Firestore
              },
            ),
          ),
        ],
      ),
    );
  }
}

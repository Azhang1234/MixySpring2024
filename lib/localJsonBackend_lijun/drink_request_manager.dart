import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class CurrentDrinkRequest {
  final List<String> ingredients;
  final String optionalPreferences;
  final String alcoholStrength;

  CurrentDrinkRequest({
    required this.ingredients,
    required this.optionalPreferences,
    required this.alcoholStrength,
  });

  // Factory constructor to create a CurrentDrinkRequest instance from a Map
  factory CurrentDrinkRequest.fromJson(Map<String, dynamic> json) {
    return CurrentDrinkRequest(
      ingredients: List<String>.from(json['Ingredients']),
      optionalPreferences:
          json['OptionalPreferences'], // Corrected field access
      alcoholStrength: json['AlcoholStrength'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Ingredients': this.ingredients,
      'OptionalPreferences': this.optionalPreferences,
      'AlcoholStrength': this.alcoholStrength
    };
  }

  @override
  String toString() {
    return 'CurrentDrinkRequest(ingredients: $ingredients, optionalPreferences: $optionalPreferences, alcoholStrength: $alcoholStrength)';
  }
}

class User {
  final String name;
  final String id;
  final String bio;
  final String imageUrl;

  User({
    required this.name,
    required this.id,
    required this.bio,
    required this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['Name'] ?? '',
      id: json['Id'] ?? '',
      bio: json['Bio'] ?? '',
      imageUrl: json['ImageUrl'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Name': this.name,
      'Id': this.id,
      'Bio': this.bio,
      'ImageUrl': this.imageUrl,
    };
  }

  @override
  String toString() {
    return 'User(name: $name, id: $id, bio: $bio, imageUrl: $imageUrl)';
  }
}

class Drink {
  final String name;
  final String timeCreated;
  bool favorite;
  final String instructions;
  final List<String> equipments;
  final List<String> ingredients;
  String? drinkID;

  Drink({
    required this.name,
    required this.timeCreated,
    required this.favorite,
    required this.instructions,
    required this.equipments,
    required this.ingredients,
    this.drinkID,
  });
  Map<String, dynamic> toJson() {
    return {
      'Name': this.name,
      'TimeCreated': this.timeCreated,
      'Favorite': this.favorite,
      'Instructions': this.instructions,
      'Equipments': this.equipments,
      'Ingredients': this.ingredients,
    };
  }

  factory Drink.fromJson(Map<String, dynamic> json, String docID) {
    return Drink(
      name: json['Name'],
      timeCreated: json['TimeCreated'],
      favorite: json['Favorite'],
      instructions: json['Instructions'],
      equipments: List<String>.from(json['Equipments']),
      ingredients: List<String>.from(json['Ingredients']),
      drinkID: docID,
    );
  }
  @override
  String toString() {
    return 'Drink(name: $name, timeCreated: $timeCreated, favorite: $favorite, instructions: $instructions, equipments: $equipments, ingredients: $ingredients, id: $drinkID)';
  }
}

class DataManager {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  auth.User? get user => auth.FirebaseAuth.instance.currentUser;
  String? get userId => user?.uid;

  Future<DocumentSnapshot> _readFirestore(String subCollectionName) async {
    return await firestore
        .collection('Users')
        .doc(userId)
        .collection(subCollectionName)
        .get()
        .then((value) => value.docs.first);
  }

  Future<void> _writeFirestore(
      String subCollectionName, Map<String, dynamic> json) async {
    return await firestore
        .collection('Users')
        .doc(userId)
        .collection(subCollectionName)
        .doc(userId)
        .set(json)
        .then((value) => print('Document Added'))
        .catchError((error) => print('Failed to add document: $error'));
  }

  // Retrieve user data
  Future<User> getUser() async {
    final DocumentSnapshot doc =
        await firestore.collection('Users').doc(userId).get();
    return User.fromJson(
        Map<String, dynamic>.from(doc.data() as Map<dynamic, dynamic>));
  }

  // Update user data
  Future<void> updateUser(User user) async {
    await firestore.collection('Users').doc(userId).set(user.toJson());
  }

  // Retrieve CurrentDrinkRequest data
  Future<CurrentDrinkRequest> getCurrentDrinkRequest() async {
    final DocumentSnapshot doc = await _readFirestore('CurrentDrinkRequests');
    if (doc.data() != null) {
      return CurrentDrinkRequest.fromJson(
          Map<String, dynamic>.from(doc.data() as Map<dynamic, dynamic>));
    } else {
      throw Exception('CurrentDrinkRequest document does not exist or is null');
    }
  }

  // Update CurrentDrinkRequest data
  Future<void> updateCurrentDrinkRequest(
      CurrentDrinkRequest drinkRequest) async {
    await _writeFirestore('CurrentDrinkRequests', drinkRequest.toJson());
  }

  // Retrieve all drinks
  Future<List<Drink>> getDrinks() async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('Users')
        .doc(userId)
        .collection('Drinks')
        .orderBy('TimeCreated')
        .get();
    return querySnapshot.docs
        .map((doc) => Drink.fromJson(
            Map<String, dynamic>.from(doc.data() as Map<dynamic, dynamic>),
            doc.id))
        .toList();
  }

  // Append a new drink
  Future<void> addDrink(Drink drink) async {
    await firestore
        .collection('Users')
        .doc(userId)
        .collection('Drinks')
        .add(drink.toJson());
  }

  // Update a specific drink
  Future<void> updateDrink(
      String drinkId, Map<String, dynamic> drinkData) async {
    final DocumentSnapshot doc = await firestore
        .collection('Users')
        .doc(userId)
        .collection('Drinks')
        .doc(drinkId)
        .get();
    if (doc.exists) {
      await firestore
          .collection('Users')
          .doc(userId)
          .collection('Drinks')
          .doc(drinkId)
          .update(drinkData);
    }
  }
}

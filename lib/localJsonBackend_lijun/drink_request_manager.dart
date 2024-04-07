import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class CurrentDrinkRequest {
  final List<String> ingredients;
  final String typesOfAlcohol;
  final String occasion;
  final String complexity;

  CurrentDrinkRequest({
    required this.ingredients,
    required this.typesOfAlcohol,
    required this.occasion,
    required this.complexity,
  });

  // Factory constructor to create a CurrentDrinkRequest instance from a Map
  factory CurrentDrinkRequest.fromJson(Map<String, dynamic> json) {
    return CurrentDrinkRequest(
      ingredients: List<String>.from(json['Ingredients']),
      typesOfAlcohol: json['TypesOfAlcohol'], // Corrected field access
      occasion: json['Occasion'],
      complexity: json['Complexity'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Ingredients': this.ingredients,
      'TypesOfAlcohol': this.typesOfAlcohol,
      'Occasion': this.occasion,
      'Complexity': this.complexity,
    };
  }

  @override
  String toString() {
    return 'CurrentDrinkRequest(ingredients: $ingredients, typesOfAlcohol: $typesOfAlcohol, occasion: $occasion, complexity: $complexity)';
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
      name: json['Name'],
      id: json['Id'],
      bio: json['Bio'],
      imageUrl: json['ImageUrl'],
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
  final bool favorite;
  final String instructions;
  final List<String> equipments;
  final List<String> ingredients;

  Drink({
    required this.name,
    required this.timeCreated,
    required this.favorite,
    required this.instructions,
    required this.equipments,
    required this.ingredients,
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

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
      name: json['Name'],
      timeCreated: json['TimeCreated'],
      favorite: json['Favorite'],
      instructions: json['Instructions'],
      equipments: List<String>.from(json['Equipments']),
      ingredients: List<String>.from(json['Ingredients']),
    );
  }
  @override
  String toString() {
    return 'Drink(name: $name, timeCreated: $timeCreated, favorite: $favorite, instructions: $instructions, equipments: $equipments, ingredients: $ingredients)';
  }
}

class DataManager {
  final String filePath = "assets/user.json";

  Future<Map<String, dynamic>> _readJson() async {
    try {
      final String jsonString = await rootBundle.loadString(filePath);
      return jsonDecode(jsonString);
    } catch (e) {
      print('Error reading JSON file: $e');
      return {}; // Return an empty map or handle the error appropriately
    }
  }

  Future<void> _writeJson(Map<String, dynamic> json) async {
    final file = File(filePath);
    await file.writeAsString(jsonEncode(json));
  }

  // Retrieve user data
  Future<User> getUser() async {
    final json = await _readJson();
    return User.fromJson(json['User']);
  }

// Update user data
  Future<void> updateUser(User user) async {
    final json = await _readJson();
    json['User'] = user.toJson();
    await _writeJson(json);
  }

  Future<CurrentDrinkRequest> getCurrentDrinkRequest() async {
    final json = await _readJson();
    Map<String, dynamic> drinkRequestData =
        Map<String, dynamic>.from(json['CurrentDrinkRequest']);
    return CurrentDrinkRequest.fromJson(drinkRequestData);
  }

// Update CurrentDrinkRequest data
  Future<void> updateCurrentDrinkRequest(
      CurrentDrinkRequest drinkRequest) async {
    final json = await _readJson();
    json['CurrentDrinkRequest'] = drinkRequest.toJson();
    await _writeJson(json);
  }

  // Retrieve all drinks
  Future<List<Drink>> getDrinks() async {
    final json = await _readJson();
    return (json['Drinks'] as List)
        .map((drinkJson) => Drink.fromJson(drinkJson))
        .toList();
  }

// Append a new drink
  Future<void> addDrink(Drink drink) async {
    final json = await _readJson();
    List drinks = json['Drinks'];
    drinks.add(drink.toJson());
    await _writeJson(json);
  }

  // Update a specific drink
  Future<void> updateDrink(
      String drinkName, Map<String, dynamic> drinkData) async {
    final json = await _readJson();
    final drinks = List<Map<String, dynamic>>.from(json['Drinks']);
    final index = drinks.indexWhere((drink) => drink['Name'] == drinkName);
    if (index != -1) {
      drinks[index] = drinkData;
      json['Drinks'] = drinks;
      await _writeJson(json);
    }
  }
}

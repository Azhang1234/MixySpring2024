import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  final String name;
  
  // ... other properties ...

  Ingredient({
    required this.name,
    // ... other properties ...
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      // ... other properties ...
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      // ... other properties ...
    };
  }
    factory Ingredient.fromSnapshot(DocumentSnapshot snapshot) {
    return Ingredient(
      name: snapshot['name'],
      // Initialize other properties from the snapshot as needed
    );
  }

}
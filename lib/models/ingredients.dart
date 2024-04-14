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
}
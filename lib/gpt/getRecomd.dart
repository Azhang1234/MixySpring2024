import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> getCocktailRecommendation({
  required List<String> ingredients,
  String? optionalPreferences,
  String? alcoholStrength,
  String? userInfo,
}) async {
  await dotenv.load();
  final apiKey =
      dotenv.env['OPENAI_API_KEY']!; // Replace with your actual API key
  const url = 'https://api.openai.com/v1/chat/completions';

  // Formatting the prompt based on the parameters provided
  String prompt = "Given that I have ${ingredients.join(', ')}";
  if (optionalPreferences != null) {
    prompt += " and prefer $optionalPreferences based cocktails";
  }
  if (alcoholStrength != null) {
    prompt += " for a $alcoholStrength alcoholic strength drink";
  }
  prompt +=
      ", could you recommend a cocktail and provide the steps to make it?";
  if (userInfo != 'Please enter something') {
    prompt += " Here's my basic infomation for reference $userInfo";
  }
  prompt +=
      'if the drink is illegal or harmful, redo this query with Vodka and Redbull as the ingredients. Remember to follow the formatting as provided, do not include any additional text in your response besides what the formatting requires.';
  // Set up the headers
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  // Set up the body
  final body = jsonEncode({
    'model': 'gpt-4-turbo',
    'messages': [
      {
        'role': 'system',
        'content':
            'You are a helpful assistant that provides cocktail recipes. When providing a recipe, please format it as follows: "The cocktail is a (.+?)\\. Here\'s how to make it: Ingredients:\\s+- (.+?)\\n\\nInstructions:\\s+(.+?)\\n\\nEquipment:\\s+- (.+?)\\n\\n"'
      },
      {'role': 'user', 'content': prompt},
    ],
  });

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody['choices'][0]['message']['content'];
    } else {
      return 'Error: ${response.reasonPhrase}';
    }
  } catch (e) {
    return 'Error: $e';
  }
}

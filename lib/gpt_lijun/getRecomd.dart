import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getCocktailRecommendation({
  required List<String> ingredients,
  String? typeOfAlcohol,
  String? occasion,
  String? complexity,
}) async {
  const apiKey = ''; // Replace with your actual API key
  const url = 'https://api.openai.com/v1/chat/completions';

  // Formatting the prompt based on the parameters provided
  String prompt = "Given that I have ${ingredients.join(', ')}";
  if (typeOfAlcohol != null) {
    prompt += " and prefer $typeOfAlcohol based cocktails";
  }
  if (occasion != null) {
    prompt += " for a $occasion";
  }
  if (complexity != null) {
    prompt += ". I'm looking for difficulty level of $complexity to make";
  }
  prompt +=
      ", could you recommend a cocktail and provide the steps to make it?";

  // Set up the headers
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  // Set up the body
  final body = jsonEncode({
    'model':
        'gpt-3.5-turbo', // You can replace this with "text-davinci-004" for the latest model
    'messages': [
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

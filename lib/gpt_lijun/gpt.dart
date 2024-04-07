import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> callGPT4(String prompt) async {
  const apiKey = 'YOUR_API_KEY_HERE'; // Replace with your actual API key
  const url = 'https://api.openai.com/v1/engines/davinci-codex/completions';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'prompt': prompt,
        'max_tokens': 100,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody['choices'][0]['text'];
    } else {
      return 'Error: ${response.reasonPhrase}';
    }
  } catch (e) {
    return 'Error: $e';
  }
}

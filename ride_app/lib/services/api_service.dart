import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  static Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    print("Response: ${response.body}"); // debug

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  static Future<Map<String, dynamic>?> register(
  String name,
  String email,
  String password,
) async {
  final url = Uri.parse("$baseUrl/register");

  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
    body: jsonEncode({
      "name": name,
      "email": email,
      "password": password,
    }),
  );

  return jsonDecode(response.body);
}
}
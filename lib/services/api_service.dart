import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://www.vooid.my.id/api';

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // GET Request
  static Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.get(url, headers: headers);
  }

  // POST Request
  static Future<http.Response> post(String endpoint, dynamic data) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.post(url, headers: headers, body: jsonEncode(data));
  }

  // PUT Request
  static Future<http.Response> put(String endpoint, dynamic data) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.put(url, headers: headers, body: jsonEncode(data));
  }

  // PATCH Request
  static Future<http.Response> patch(
    String endpoint, {
    required dynamic body,
  }) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      return await http.patch(url, headers: headers, body: jsonEncode(body));
    } catch (e) {
      throw Exception('Failed to PATCH: $e');
    }
  }

  // DELETE Request
  static Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.delete(url, headers: headers);
  }

  // POST Request tanpa Auth
  static Future<http.Response> postNoAuth(String endpoint, dynamic data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String baseUrl = 'https://www.vooid.my.id/api';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
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

  // UPLOAD FILE
  // static Future<http.Response> uploadImage(File file) async {
  //   final uri = Uri.parse('$baseUrl/user/image');
  //   final token = await _getToken();
  //
  //   if (token == null) throw Exception('Token not found');
  //
  //   final request = http.MultipartRequest('POST', uri);
  //   request.headers['Authorization'] = 'Bearer $token';
  //
  //   final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
  //   final splitMime = mimeType.split('/');
  //
  //   final multipartFile = await http.MultipartFile.fromPath(
  //     'file',
  //     file.path,
  //     contentType: MediaType(splitMime[0], splitMime[1]),
  //   );
  //
  //   request.files.add(multipartFile);
  //
  //   final streamedResponse = await request.send();
  //   return await http.Response.fromStream(streamedResponse);
  // }

  static Future<http.Response> uploadImage(
    File file, {
    required String path,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final token = await _getToken();

    if (token == null) throw Exception('Token not found');

    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
    final splitMime = mimeType.split('/');

    final multipartFile = await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: MediaType(splitMime[0], splitMime[1]),
    );

    request.files.add(multipartFile);

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}

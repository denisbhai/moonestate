// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://moonestate.goodcoderz.com';
  static const String imageUrlPrefix = '$baseUrl/storage/';

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl/$endpoint').replace(queryParameters: params);
    return http.get(url, headers: headers);
  }

  static Future<http.Response> post(String endpoint, dynamic body) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl/$endpoint');
    return http.post(url, headers: headers, body: json.encode(body));
  }

  static Future<http.Response> put(String endpoint, dynamic body) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl/$endpoint');
    return http.put(url, headers: headers, body: json.encode(body));
  }

  static Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl/$endpoint');
    return http.delete(url, headers: headers);
  }
}
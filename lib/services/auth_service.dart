// lib/services/auth_service.dart
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/user.dart';

class AuthService {
  static const String baseUrl = 'https://moonestate.goodcoderz.com';

  static Future<Map<String, dynamic>> register(
    String firstName,
    String lastName,
    String email,
    String userName,
    String password,
    String confirmPassword,
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/register'),
      );

      request.fields.addAll({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'username': userName,
        'password': password,
        'password_confirmation': confirmPassword,
      });

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      log("response====${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        log("response===data===${data['data']['token']}");
        await _storeToken(data['data']['token']);
        await _sendDeviceToken();
        return {'success': true, 'data': data['data']};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['message']};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> login(
      String email,
      String password,
      ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/login'),
      );

      request.fields.addAll({
        'email': email,
        'password': password,
      });

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _storeToken(data['data']['token']);
        log("message==login===${data['data']['token']}");
        await _sendDeviceToken();
        return {'success': true, 'data': data['data']};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['message']};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      await http.post(
        Uri.parse('$baseUrl/api/logout'),
        headers: {'Authorization': 'Bearer $token'},
      );
    }

    await prefs.remove('auth_token');
  }

  static Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_token');
  }

  static Future<void> _sendDeviceToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();



      if (token != null) {
        final authToken = await getToken();
        if (authToken != null) {
          await http.post(
            Uri.parse('$baseUrl/api/device-token'),
            headers: {'Authorization': 'Bearer $authToken'},
            body: {'device_token': token},
          );
        }
      }
    } catch (e) {
      print('Error sending device token: $e');
    }
  }

  static Future<User?> getUserProfile() async {
    final token = await getToken();
    if (token == null) return null;
    log("token====$token");
    final response = await http.get(
      Uri.parse('$baseUrl/api/user-detail-fetch'),
      headers: {'Authorization': 'Bearer $token'},
    );
    log("response==response====$response");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data['data']['user']);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>> updateProfile(User user, {File? avatar}) async {
    final token = await getToken();
    if (token == null) return {'success': false, 'error': 'Not authenticated'};

    try {
      var request = http.MultipartRequest(
        'POST', // or "PUT" if backend accepts multipart PUT (many APIs use POST for profile update)
        Uri.parse('$baseUrl/api/setting'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['first_name'] = user.firstName;
      request.fields['last_name'] = user.lastName;
      request.fields['username'] = user.username;
      request.fields['phone'] = user.phone;
      request.fields['description'] = user.description;
      request.fields['dob'] = user.dateOfBirth.toIso8601String().split('T')[0];
      request.fields['gender'] = user.gender;

      log("request.fields['dob']===${request.fields['dob']}");

      if (avatar != null) {
        request.files.add(
          await http.MultipartFile.fromPath('avatar_file', avatar.path),
        );
      }

      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return {'success': true, 'data': json.decode(respStr)};
      } else {
        final error = json.decode(respStr);
        return {'success': false, 'error': error['message'] ?? 'Upload failed'};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}

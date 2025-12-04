import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projetomobile/models/rating.dart';
import 'dart:io';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;

  bool get hasToken => _token != null;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('access_token');
  }

  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro ${response.statusCode}: ${response.body}');
    }
  }

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    );
    if (response.statusCode == 204) return null;
    return _handleResponse(response);
  }

  Future<bool> validateToken() async {
    await loadToken();

    if (_token == null) return false;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/verify-token'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        await clearToken();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];

        await setToken(token);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<Rating>> getRatings(int movieId) async {
    final List<dynamic> data = await get('/movies/$movieId/ratings');
    return data.map((json) => Rating.fromJson(json)).toList();
  }

  Future<Rating> submitRating({
    required int movieId,
    required double value,
    String? comment,
  }) async {
    final data = await post('/ratings/', {
      'movieId': movieId,
      'value': value,
      'comment': comment,
    });
    return Rating.fromJson(data);
  }

  Future<void> deleteRating(int movieId) async {
    await delete('/ratings/$movieId');
  }

  Future<dynamic> uploadProfilePhoto(File imageFile) async {
    await loadToken();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/users/me/photo'),
    );

    request.headers.addAll(_headers);

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      throw Exception("Erro ao enviar imagem: $e");
    }
  }
}

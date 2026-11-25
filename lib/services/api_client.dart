import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/experience.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode);
  final int statusCode;

  @override
  String toString() => 'Permintaan gagal (HTTP $statusCode).';
}

class ApiClient {
  ApiClient({String baseUrl = apiBaseUrl, http.Client? client})
    : _experiences = Uri.parse(
        '${baseUrl.replaceFirst(RegExp(r'/+$'), '')}/api/v1/experiences/',
      ),
      _client = client ?? http.Client();

  final Uri _experiences;
  final http.Client _client;

  Future<String> obtainToken(String username, String password) async {
    final response = await _client.post(
      _experiences.resolve('../auth/token/'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    final data = _decode(response);
    if (data is! Map ||
        data['token'] is! String ||
        (data['token'] as String).isEmpty) {
      throw const FormatException('Token tidak tersedia.');
    }
    return data['token'] as String;
  }

  Future<void> logout(String token) async {
    final response = await _client.post(
      _experiences.resolve('../auth/logout/'),
      headers: {'Authorization': 'Token $token'},
    );
    if (response.statusCode != 204 && response.statusCode != 401) {
      throw ApiException(response.statusCode);
    }
  }

  Future<List<Experience>> getExperiences() async {
    final response = await _client.get(
      _experiences,
      headers: {'Accept': 'application/json'},
    );
    final items = _decode(response) as List<dynamic>;
    return items
        .map((item) => Experience.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Experience> createExperience(
    Experience experience, {
    required String token,
  }) async {
    final response = await _client.post(
      _experiences,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(experience.toJson()),
    );
    return Experience.fromJson(_decode(response) as Map<String, dynamic>);
  }

  dynamic _decode(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(response.statusCode);
    }
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  void close() => _client.close();
}

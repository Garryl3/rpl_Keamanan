import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../utils/logger.dart';

class ApiService {
  static ApiService? _instance;
  final http.Client _client;
  final String _baseUrl;

  // Private Constructor (Singleton Pattern)
  ApiService._internal({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? AppConfig.baseUrl;

  // Factory Constructor untuk akses instance Singleton
  factory ApiService({http.Client? client, String? baseUrl}) {
    _instance ??= ApiService._internal(client: client, baseUrl: baseUrl);
    return _instance!;
  }

  Future<List<User>> getUsers() async {
    try {
      Logger.info('GET /users initiated');
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/users'),
            headers: _buildHeaders(),
          )
          .timeout(const Duration(seconds: AppConfig.timeoutSeconds));

      Logger.debug('GET /users response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data. Status: ${response.statusCode}');
      }
    } on TimeoutException {
      Logger.error('GET /users request timeout');
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      Logger.error('GET /users socket exception');
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      Logger.error('GET /users format exception');
      throw Exception('Format data tidak valid.');
    } catch (e, stack) {
      Logger.error('GET /users error', e, stack);
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<User> getUserById(int id) async {
    try {
      Logger.info('GET /users/$id initiated');
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/users/$id'),
            headers: _buildHeaders(),
          )
          .timeout(const Duration(seconds: AppConfig.timeoutSeconds));

      Logger.debug('GET /users/$id status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Gagal memuat data. Status: ${response.statusCode}');
      }
    } on TimeoutException {
      Logger.error('GET /users/$id request timeout');
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      Logger.error('GET /users/$id no internet connection');
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } catch (e, stack) {
      Logger.error('GET /users/$id error', e, stack);
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// Fetch daftar postingan dari endpoint /posts
  Future<List<Post>> getPosts() async {
    try {
      Logger.info('GET /posts initiated');
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/posts'),
            headers: _buildHeaders(),
          )
          .timeout(const Duration(seconds: AppConfig.timeoutSeconds));

      Logger.debug('GET /posts status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat posts. Status: ${response.statusCode}');
      }
    } on TimeoutException {
      Logger.error('GET /posts request timeout');
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      Logger.error('GET /posts socket exception');
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      Logger.error('GET /posts format exception');
      throw Exception('Format data tidak valid.');
    } catch (e, stack) {
      Logger.error('GET /posts error', e, stack);
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<String> login(String email, String password) async {
    try {
      Logger.info('Login attempt for email: $email');
      await Future.delayed(const Duration(seconds: 1));
      if (email.isNotEmpty && password.isNotEmpty) {
        final token = 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';
        Logger.info('Login successful');
        return token;
      } else {
        throw Exception('Email dan password tidak boleh kosong');
      }
    } catch (e, stack) {
      Logger.error('Login failed', e, stack);
      throw Exception('Login gagal: $e');
    }
  }

  Map<String, String> _buildHeaders() {
    return {
      'Content-Type': 'application/json',
      'X-API-Key': AppConfig.apiKey,
    };
  }

  void dispose() {
    _client.close();
  }
}
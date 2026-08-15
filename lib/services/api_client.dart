import 'dart:async';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';

class ApiException implements Exception {
  final String message;
  const ApiException({required this.message});

  @override
  String toString() => 'ApiException: $message';
}

class ApiClient {
  final SharedPreferences? _prefs;
  Dio? _dio;
  SharedPreferences? _cachedPrefs;

  static String _currentBaseUrl = kDefaultApiBaseUrl;

  static String get currentBaseUrl => _currentBaseUrl;

  static void updateBaseUrl(String url) {
    _currentBaseUrl = url;
  }

  ApiClient({SharedPreferences? prefs}) : _prefs = prefs;

  Future<Dio> _getDio() async {
    if (_dio != null) return _dio!;

    final prefs = _prefs ?? _cachedPrefs ?? await SharedPreferences.getInstance();
    if (_prefs == null) _cachedPrefs = prefs;

    final baseUrl = _resolveBaseUrl(prefs);

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 50),
        receiveTimeout: const Duration(seconds: 50),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await _addAuthHeader(options);
          handler.next(options);
        },
        onError: (DioException err, ErrorInterceptorHandler handler) {
          final message = _normalizeError(err);
          handler.reject(DioException(
            requestOptions: err.requestOptions,
            error: message,
            type: err.type,
            response: err.response,
          ));
        },
      ),
    );

    return _dio!;
  }

  String _resolveBaseUrl(SharedPreferences prefs) {
    final stored = prefs.getString(kApiBaseUrlPrefKey);
    if (stored != null) {
      final trimmed = stored.trim();
      if (trimmed.isNotEmpty) {
        try {
          final uri = Uri.parse(trimmed);
          if (uri.hasScheme && uri.hasAuthority) {
            return trimmed;
          }
        } catch (_) {
          // fall through to default
        }
      }
    }
    return _currentBaseUrl;
  }

  // Protected endpoints that require Firebase Auth token
  static const _protectedPaths = {
    '/api/contract/upload',
    '/api/contract/segment',
    '/api/contract/segment/file',
    '/api/contract/classify',
    '/api/contract/classify/batch',
    '/api/contract/summarize',
    '/api/contract/analyze',
    '/api/contract/compare',
  };

  Future<void> _addAuthHeader(RequestOptions options) async {
    final path = options.path;
    final needsAuth = _protectedPaths.any((p) => path.startsWith(p));

    if (!needsAuth) return;

    // Try to get the current user, waiting briefly if needed
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User just signed in but auth state hasn't propagated yet
      // Wait briefly for auth state to settle (max 2 seconds)
      try {
        await FirebaseAuth.instance
            .authStateChanges()
            .firstWhere((u) => u != null)
            .timeout(const Duration(seconds: 2));
        user = FirebaseAuth.instance.currentUser;
      } catch (e) {
        // Timeout or no user, proceed without auth (will get 401)
      }
    }

    if (user != null) {
      try {
        final token = await user.getIdToken(true); // force refresh if needed
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      } catch (e) {
        // Token retrieval failed
      }
    }
  }

  String _normalizeError(DioException err) {
    if (err.response?.data != null && err.response!.data is Map) {
      final data = err.response!.data as Map;
      if (data.containsKey('message')) {
        return data['message'] as String;
      }
      if (err.response!.statusCode == 422 && data.containsKey('details')) {
        return data['details'].toString();
      }
    }

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection failed: Request timed out';
      case DioExceptionType.connectionError:
        return 'Connection failed: Unable to reach server';
      case DioExceptionType.badResponse:
        return 'Connection failed: Server returned ${err.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Connection failed: Request cancelled';
      case DioExceptionType.unknown:
      default:
        return 'Connection failed: ${err.message ?? 'Unknown error'}';
    }
  }

  Future<SharedPreferences> _prefsInstance() async {
    final prefs = _prefs;
    if (prefs != null) return prefs;
    final cached = _cachedPrefs;
    if (cached != null) return cached;
    final newPrefs = await SharedPreferences.getInstance();
    _cachedPrefs = newPrefs;
    return newPrefs;
  }

  Future<void> _updateBaseUrl() async {
    final prefs = await _prefsInstance();
    final dio = await _getDio();
    dio.options.baseUrl = _resolveBaseUrl(prefs);
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? query,
    T Function(Map<String, dynamic>)? decoder,
  }) async {
    await _updateBaseUrl();
    final dio = await _getDio();
    final response = await dio.get(path, queryParameters: query);
    return _decode<T>(response.data, decoder);
  }

  Future<T> postJson<T>(
    String path, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? decoder,
  }) async {
    await _updateBaseUrl();
    final dio = await _getDio();
    final response = await dio.post(path, data: body);
    return _decode<T>(response.data, decoder);
  }

  Future<T> postMultipart<T>(
    String path, {
    required String field,
    required PlatformFile file,
    Map<String, String>? extraFields,
    void Function(int sent, int total)? onProgress,
    T Function(Map<String, dynamic>)? decoder,
  }) async {
    await _updateBaseUrl();
    final dio = await _getDio();

    final formData = FormData.fromMap({
      field: await MultipartFile.fromFile(file.path!),
      if (extraFields != null) ...extraFields,
    });

    final response = await dio.post(
      path,
      data: formData,
      onSendProgress: onProgress,
    );

    return _decode<T>(response.data, decoder);
  }

  Future<T> postMultipartRaw<T>(
    String path, {
    required FormData formData,
    void Function(int sent, int total)? onProgress,
    T Function(Map<String, dynamic>)? decoder,
  }) async {
    await _updateBaseUrl();
    final dio = await _getDio();

    final response = await dio.post(
      path,
      data: formData,
      onSendProgress: onProgress,
    );

    return _decode<T>(response.data, decoder);
  }

  T _decode<T>(dynamic data, T Function(Map<String, dynamic>)? decoder) {
    if (data is Map<String, dynamic>) {
      if (decoder != null) {
        return decoder(data);
      }
      return data as T;
    }
    throw ApiException(message: 'Unexpected response format');
  }

  Future<void> delete(String path) async {
    await _updateBaseUrl();
    final dio = await _getDio();
    await dio.delete(path);
  }
}
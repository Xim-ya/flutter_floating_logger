import 'package:dio/io.dart' show IOHttpClientAdapter;
import 'package:floating_logger/floating_logger.dart';
import 'package:floating_logger/src/network/network_model.dart';
import '../utils/utils_network.dart';
import 'package:flutter/foundation.dart' as foundation; // For kIsWeb

/// A custom Dio instance with integrated logging functionality.
///
/// This class extends [DioMixin] and implements [Dio] to provide a singleton
/// Dio instance that includes network request logging using [DioLogger].
///
/// It logs HTTP requests, responses, and errors while allowing further customization.
///
/// Usage:
/// ```dart
/// final dio = DioLogger.instance;
/// dio.get('https://api.example.com');
/// ```
class DioLogger with DioMixin implements Dio {
  /// The log repository used to store and manage logs.
  final LogRepository logRepository;

  /// Private constructor to initialize DioLogger with custom configurations.
  ///
  /// - Sets default request options such as `contentType`, `connectTimeout`, and `receiveTimeout`.
  /// - Adds custom interceptors for logging requests, responses, and errors.
  /// - Uses [IOHttpClientAdapter] for HTTP request handling.
  DioLogger._(this.logRepository) {
    // Add default interceptors
    addDefaultInterceptors();
  }

  /// A private log repository instance to manage logs globally.
  static final LogRepository _logRepository = LogRepository();

  /// A singleton instance of [DioLogger].
  ///
  /// This ensures that only one instance of DioLogger is used throughout the application.
  static final DioLogger _instance = DioLogger._(_logRepository);

  /// Returns the singleton instance of [DioLogger].
  static DioLogger get instance => _instance;

  /// Provides access to the log repository instance.
  LogRepository get logs => _logRepository;

  // Add a custom interceptor to log request, response, and error details.
  void addDefaultInterceptors() {
    interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => LoggerNetworkSettings.onRequest(
          options,
          handler,
          logRepository,
        ),
        onResponse: (response, handler) => LoggerNetworkSettings.onResponse(
          response,
          handler,
          logRepository,
        ),
        onError: (error, handler) => LoggerNetworkSettings.onError(
          error,
          handler,
          logRepository,
        ),
      ),
    );
  }

  /// Method to add custom interceptors
  void addInterceptor(Interceptor interceptor) {
    interceptors.add(interceptor);
  }

  void addListInterceptor(List<Interceptor> interceptorsList) {
    for (var interceptor in interceptorsList) {
      interceptors.add(interceptor);
    }
  }
}

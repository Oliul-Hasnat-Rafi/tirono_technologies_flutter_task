import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../utils/dev_functions/dev_print.dart';
import '../utils/user_message/snackbar.dart';
import '../environment/environment.dart';

part 'http_client.dart';

/// Base class for HTTP repositories
///
/// Provides access to [httpClient] for making HTTP requests
///   
/// All repositories should extend this class to get HTTP functionality
abstract class HttpRepository {
  /// Base class for HTTP repositories
  ///
  /// Add `import 'package:dio/dio.dart' as dio;`
  /// 
  /// Note: HttpClient now requires a Ref for accessing auth state
  HttpRepository({Ref? ref}) : _ref = ref;
  
  final Ref? _ref;
  
  _HttpClient? _httpClientInstance;
  
  /// HTTP client for making requests
  /// 
  /// Use this to make GET, POST, PUT, DELETE requests
  _HttpClient get httpClient {
    _httpClientInstance ??= _HttpClient(_ref);
    return _httpClientInstance!;
  }
}

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'api_constants.dart';

class ApiResponse<T> {
  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
  });

  final bool success;
  final String message;
  final T? data;
  final int? statusCode;
}

class ApiClient extends GetConnect {
  ApiClient() {
    baseUrl = ApiConstants.baseUrl;
    timeout = const Duration(seconds: 30);
  }

  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await post(ApiConstants.login, {
        'email': email,
        'password': password,
      });
      final body = _asMap(response.body);
      final success = response.statusCode == 200 && (body['success'] == true);
      return ApiResponse<Map<String, dynamic>>(
        success: success,
        message: (body['message'] ?? body['msg'] ?? (success ? 'Login successful' : 'Login failed')).toString(),
        data: body,
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint('Login request failed');
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Unable to connect. Please try again.',
      );
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getMyPhotos(String token) async {
    try {
      final cleanToken = token.trim();
      debugPrint('ApiClient: getMyPhotos called');
      
      // The live API expects the raw token in the Authorization header.
      final response = await get(
        ApiConstants.myPhotos,
        headers: {'Authorization': cleanToken},
      );
      
      debugPrint('ApiClient: getMyPhotos status code: ${response.statusCode}');
      debugPrint('ApiClient: getMyPhotos response body: ${response.body}');
      
      if (response.statusCode == 401) {
        return ApiResponse<List<Map<String, dynamic>>>(
          success: false,
          message: 'Unauthorized. Please log in again.',
          statusCode: 401,

        );
      }

      final body = _asMap(response.body);
      final bool isSuccess = response.statusCode == 200 || body['success'] == true || body['status'] == true;

      if (isSuccess) {
        List<dynamic> list = [];
        
        // Search body and its potential container fields for a List
        final candidateData = body['data'] ?? body['photos'] ?? body['uploads'] ?? body['items'] ?? body['results'] ?? body;
        
        if (candidateData is List) {
          list = candidateData;
        } else if (candidateData is Map) {
          for (final val in candidateData.values) {
            if (val is List) {
              list = val;
              break;
            } else if (val is Map) {
              for (final nestedVal in val.values) {
                if (nestedVal is List) {
                  list = nestedVal;
                  break;
                }
              }
              if (list.isNotEmpty) break;
            }
          }
        }
        
        if (list.isEmpty && body is Map) {
          for (final val in body.values) {
            if (val is List) {
              list = val;
              break;
            }
          }
        }

        final listMaps = list
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
        
        return ApiResponse<List<Map<String, dynamic>>>(
          success: true,
          message: (body['message'] ?? body['msg'] ?? 'Success').toString(),
          data: listMaps,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse<List<Map<String, dynamic>>>(
        success: false,
        message: (body['message'] ?? body['msg'] ?? 'Failed to load photos').toString(),
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint('Gallery request failed: $e');
      return ApiResponse<List<Map<String, dynamic>>>(
        success: false,
        message: 'Unable to load photos. Please try again.',
      );
    }
  }

  Map<String, dynamic> _asMap(dynamic body) {
    if (body is Map<String, dynamic>) return body;
    if (body is Map) return Map<String, dynamic>.from(body);
    return <String, dynamic>{};
  }
}

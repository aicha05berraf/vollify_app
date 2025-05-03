import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      'http://192.168.100.2:3000/api'; // Android emulator
  // For real devices: 'http://<YOUR_LOCAL_IP>:3000/api'

  // ========================
  // Auth Methods
  // ========================
  Future<http.Response> volunteerSignup({
    required String username,
    required String email,
    required String password,
    required String phone,
    required List<String> skills,
    required String experience,
  }) async {
    return await _postRequest(
      endpoint: '/volunteer/signup',
      body: {
        'username': username,
        'email': email,
        'password': password,
        'phone': phone,
        'skills': skills,
        'experience': experience,
      },
    );
  }

  Future<http.Response> organizationSignup(
    String name,
    String email,
    String password,
    String phone,
    String location,
    String socialMedia,
  ) async {
    return await _postRequest(
      endpoint: '/organization/signup',
      body: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'location': location,
        'social_media': socialMedia,
      },
    );
  }

  Future<http.Response> login({
    required String email,
    required String password,
    required String role,
  }) async {
    return await _postRequest(
      endpoint: '/login',
      body: {'email': email, 'password': password, 'role': role},
    );
  }

  // ========================
  // Profile Methods
  // ========================
  Future<http.Response> getVolunteerProfile(int id) async {
    return await _getRequest(endpoint: '/volunteers/$id');
  }

  Future<http.Response> getOrganizationProfile(int id) async {
    return await _getRequest(endpoint: '/organizations/$id');
  }

  Future<http.Response> updateVolunteerProfile(
    int id,
    Map<String, Object?> data,
  ) async {
    return await _putRequest(endpoint: '/volunteers/update/$id', body: data);
  }

  Future<http.Response> updateOrganizationProfile(
    int organizationId,
    Map<String, Object> updatedData, {
    required int id,
    required Map<String, dynamic> data,
  }) async {
    return await _putRequest(endpoint: '/organizations/update/$id', body: data);
  }

  // ========================
  // Opportunity Methods
  // ========================
  Future<http.Response> createOpportunity({
    required Map<String, dynamic> opportunityData,
  }) async {
    return await _postRequest(
      endpoint: '/opportunities',
      body: opportunityData,
      requiresAuth: true,
    );
  }

  Future<http.Response> getAllOpportunities() async {
    return await _getRequest(endpoint: '/opportunities');
  }

  Future<http.Response> saveOpportunity({
    required int volunteerId,
    required int opportunityId,
  }) async {
    return await _postRequest(
      endpoint: '/saved',
      body: {'volunteer_id': volunteerId, 'opportunity_id': opportunityId},
      requiresAuth: true,
    );
  }

  Future<http.Response> getSavedOpportunities(int volunteerId) async {
    return await _getRequest(
      endpoint: '/saved/$volunteerId',
      requiresAuth: true,
    );
  }

  Future<http.Response> applyForOpportunity({
    required int volunteerId,
    required int opportunityId,
  }) async {
    return await _postRequest(
      endpoint: '/applications',
      body: {'volunteer_id': volunteerId, 'opportunity_id': opportunityId},
      requiresAuth: true,
    );
  }

  Future<http.Response> getApplications(int volunteerId) async {
    return await _getRequest(
      endpoint: '/applications/$volunteerId',
      requiresAuth: true,
    );
  }

  // ========================
  // Notification Methods
  // ========================
  Future<http.Response> sendNotification({
    required int recipientId,
    required String message,
  }) async {
    return await _postRequest(
      endpoint: '/notifications',
      body: {'recipient_id': recipientId, 'message': message},
      requiresAuth: true,
    );
  }

  Future<http.Response> getNotifications(int userId) async {
    return await _getRequest(
      endpoint: '/notifications/$userId',
      requiresAuth: true,
    );
  }

  // ========================
  // Review Methods
  // ========================
  Future<http.Response> postReview({
    required int reviewerId,
    required int reviewedOrgId,
    required int rating,
    required String comment,
  }) async {
    return await _postRequest(
      endpoint: '/reviews',
      body: {
        'reviewer_id': reviewerId,
        'reviewed_org_id': reviewedOrgId,
        'rating': rating,
        'comment': comment,
      },
      requiresAuth: true,
    );
  }

  Future<http.Response> getReviews(int orgId) async {
    return await _getRequest(endpoint: '/reviews/$orgId');
  }

  // ========================
  // Password Reset Methods
  // ========================
  Future<http.Response> forgotPassword({
    required String email,
    required String role,
  }) async {
    return await _postRequest(
      endpoint: '/forgot-password',
      body: {'email': email, 'role': role},
    );
  }

  Future<http.Response> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    return await _postRequest(
      endpoint: '/reset-password',
      body: {'token': token, 'newPassword': newPassword},
    );
  }

  // ========================
  // Helper Methods
  // ========================
  Future<http.Response> _getRequest({
    required String endpoint,
    bool requiresAuth = false,
  }) async {
    final headers =
        requiresAuth
            ? await _getHeaders()
            : {'Content-Type': 'application/json'};

    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  Future<http.Response> _postRequest({
    required String endpoint,
    required Map<String, dynamic> body,
    bool requiresAuth = false,
  }) async {
    final headers =
        requiresAuth
            ? await _getHeaders()
            : {'Content-Type': 'application/json'};

    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  Future<http.Response> _putRequest({
    required String endpoint,
    required Map<String, dynamic> body,
    bool requiresAuth = true,
  }) async {
    final headers =
        requiresAuth
            ? await _getHeaders()
            : {'Content-Type': 'application/json'};

    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 400) {
      final errorData = jsonDecode(response.body);
      final errorMessage =
          errorData['error'] ?? errorData['message'] ?? 'Unknown error';
      throw Exception('API Error (${response.statusCode}): $errorMessage');
    }
    return response;
  }

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> markAllNotificationsAsRead(int userId) async {
    final url = Uri.parse('$baseUrl/notifications/mark-all-read/$userId');
    return await http.post(url, headers: await _getHeaders());
  }
}

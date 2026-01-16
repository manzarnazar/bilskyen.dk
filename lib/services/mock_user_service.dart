import '../models/user_model.dart';
import '../models/api_response_model.dart';

class MockUserService {
  // Mock user data
  static final UserModel _mockUser = UserModel(
    id: 1,
    name: 'Demo User',
    email: 'demo@gmail.com',
    phone: '+45 12 34 56 78',
    statusId: 1, // ACTIVE
    emailVerifiedAt: DateTime.now().subtract(const Duration(days: 30)),
    createdAt: DateTime.now().subtract(const Duration(days: 60)),
    updatedAt: DateTime.now(),
    statusName: 'Active',
  );

  // Mock login response matching API format
  static ApiResponse<Map<String, dynamic>> mockLoginResponse({
    required String email,
    required String password,
  }) {
    // Simulate authentication
    if (email == 'demo@gmail.com' && password == '12345678') {
      return ApiResponse<Map<String, dynamic>>(
        data: {
          'user': _mockUser.toJson(),
          'access_token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
          'token_type': 'Bearer',
        },
      );
    }

    throw Exception('Invalid credentials');
  }

  // Mock register response matching API format
  static ApiResponse<Map<String, dynamic>> mockRegisterResponse({
    required String name,
    required String email,
    required String password,
  }) {
    // Create new user
    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      email: email,
      statusId: 1, // ACTIVE
      emailVerifiedAt: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      statusName: 'Active',
    );

    return ApiResponse<Map<String, dynamic>>(
      data: {
        'user': newUser.toJson(),
        'access_token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        'token_type': 'Bearer',
      },
    );
  }

  // Mock get current user response
  static ApiResponse<UserModel> mockGetCurrentUserResponse() {
    return ApiResponse<UserModel>(
      data: _mockUser,
    );
  }

  // Mock error response
  static Map<String, dynamic> mockErrorResponse({
    required String message,
    Map<String, List<String>>? errors,
  }) {
    return {
      'status': 'error',
      'message': message,
      if (errors != null) 'errors': errors,
    };
  }
}


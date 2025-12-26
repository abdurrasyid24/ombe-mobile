class LoginResponse {
  final bool success;
  final String message;
  final UserData? data;
  final String? token;

  LoginResponse({
    required this.success,
    required this.message,
    this.data,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
      token: json['token'],
    );
  }
}

class UserData {
  final int id;
  final String username;
  final String email;
  final String fullName;
  final String phone;
  final String address;
  final String role;

  UserData({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      fullName: json['fullName'],
      phone: json['phone'],
      address: json['address'],
      role: json['role'],
    );
  }
}

class ApiConfig {
  // GANTI dengan IP server backend Anda
  // Untuk emulator Android: http://10.0.2.2:5000
  // Untuk device fisik: http://[IP_LAPTOP]:5000 (contoh: http://192.168.1.10:5000)
  // Untuk iOS simulator: http://localhost:5000
  // static const String baseUrl = 'http://10.0.2.2:5000';
  static const String baseUrl = 'https://server-ombe.codingankuu.com';

  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String logout = '/api/auth/logout';
  static const String me = '/api/auth/me';
  static const String updateProfile = '/api/auth/profile';
  static const String changePassword = '/api/auth/change-password';

  // Product endpoints
  static const String products = '/api/products';
  static const String featuredProducts = '/api/products/featured/list';

  // Category endpoints
  static const String categories = '/api/categories';

  // Order endpoints
  // Order endpoints
  static const String orders = '/api/orders';

  // Payment endpoints
  static const String paymentMethods = '/api/payment/methods';

  // Rewards endpoints
  static const String rewards = '/api/rewards';

  // Notification endpoints
  static const String notifications = '/api/notifications';
  static const String notificationUnreadCount =
      '/api/notifications/unread-count';
  static const String notificationMarkAllRead = '/api/notifications/read-all';

  // Helper methods
  static String productById(int id) => '/api/products/$id';
  static String categoryById(int id) => '/api/categories/$id';
  static String orderById(int id) => '/api/orders/$id';
  static String notificationMarkRead(int id) => '/api/notifications/$id/read';
}

import '../environment/environment.dart';

class ApiEndPoints {
  static final   baseUrl = Environment.apiBaseUrl;
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String courses = '/courses';
  static const String logout = '/auth/logout';
  static const String dashboard = '/dashboard';
  static const String products = '/products';
  static const String productDetails = '/products/{id}';
  static const String users = '/users';
  static const String userDetails = '/users/{id}';
  static const String mentors = '/auth/mentor/all';
 
} 
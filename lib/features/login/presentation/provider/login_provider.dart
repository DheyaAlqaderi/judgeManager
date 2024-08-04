import 'package:flutter/cupertino.dart';
import '../../domain/repository/login_repository.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLogin = false;

  bool get isLoading => _isLoading;
  bool get isLogin => _isLogin;

  /// Attempts to login with the given phone number and password.
  /// Updates the loading state and login status accordingly.
  Future<void> login({required String phoneNumber, required String password}) async {
    _setLoading(true);
    try {
      // Simulate network delay
      await Future.delayed(Duration(seconds: 2));

      final success = await LoginRepository.login(
        phoneNumber: '+967$phoneNumber',
        password: password,
      );

      // Update the login status based on the success of the login attempt
      _setLogin(success);
    } catch (error) {
      // Handle any errors (e.g., log the error, show a message to the user)
      print('Login failed: $error');
      _setLogin(false);
    } finally {
      _setLoading(false);
    }
  }

  /// Sets the loading state and notifies listeners.
  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  /// Sets the login status and notifies listeners.
  void _setLogin(bool isLogin) {
    _isLogin = isLogin;
    notifyListeners();
  }
}

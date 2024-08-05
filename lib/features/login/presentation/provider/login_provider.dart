
import 'package:flutter/cupertino.dart';

import '../../../../core/constant/app_constant.dart';
import '../../../../core/utills/helpers/local_database/shared_pref.dart';
import '../../domain/repository/login_repository.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLogin = false;
  String _phoneNumber = "0";

  bool get isLoading => _isLoading;
  bool get isLogin => _isLogin;
  String get phoneNumber => _phoneNumber;

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


  /// check if user is login or not
  Future<bool> hadAUserPhone() async {
    // Retrieve the user phone number from shared preferences
    final userPhone = await SharedPrefManager.getData(AppConstant.userPhoneNumber);
      if (userPhone
          .toString()
          .isNotEmpty && userPhone != null) {
        bool checkIsActive = await LoginRepository.isUserActive(
            phoneNumber: userPhone.toString());
        if (checkIsActive) {
          // Navigate to HomeScreen if userPhone has a value
          _setLogin(true);
          return true;
        } else {
          // Navigate to LoginScreen if userPhone is null or empty
          _setLogin(false);
          return false;
        }
      } else {
        // Navigate to LoginScreen if userPhone is null or empty
        _setLogin(false);
        return false;
      }
  }

}

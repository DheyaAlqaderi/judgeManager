

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:judgemanager/core/constant/app_constant.dart';
import 'package:judgemanager/core/utills/helpers/local_database/shared_pref.dart';
import 'package:judgemanager/core/utills/helpers/snackbar_helper.dart';

class LoginRepository{

  static Future<bool> login({required String phoneNumber, required password})async{
    try{
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the `judge` users collection
      final CollectionReference usersCollection = firestore.collection(AppConstant.judge);

      // Query for a document with the given phone number
      final QuerySnapshot querySnapshot = await usersCollection
          .where(AppConstant.phoneNumber, isEqualTo: phoneNumber)
          .get();

      // Check if any documents were returned
      if (querySnapshot.docs.isNotEmpty) {
        // User exists, now check the password
        final DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Ensure the 'password' field exists in the document
        if (userDoc.exists && userDoc.data() != null) {
          final String storedPassword = userDoc.get(
              AppConstant.password); // Get the stored password

          // Compare the stored password with the provided password
          if (storedPassword == password) {
            final bool isActive = userDoc.get(
                AppConstant.isActive);
            if(isActive){
              await SharedPrefManager.saveData(AppConstant.userPhoneNumber, phoneNumber);
              SnackbarHelper.showSuccess("تم بنجاح");
              return true; // Password matches
            } else{
              SnackbarHelper.showWarning("القاضي غير مفعل, الرجاء متابعة المسؤول لتفعيل حسابك");
              return false; // Password matches
            }

          } else {
            SnackbarHelper.showError("كلمة السر خطأ");
            return false; // Password does not match
          }
          // Optionally, you can perform further checks with the password here if needed

        } else {
          // User does not exist
          SnackbarHelper.showError("القاضي غير موجد");
          return false;
        }
      }else{
        SnackbarHelper.showError("القاضي غير موجد");
        return false;
      }
    }catch(e){
      SnackbarHelper.showError("هناك مشكلة من الخادم");
      return false;
    }
  }


  // Method to check if a user is active based on phone number
  static Future<bool> isUserActive({required String phoneNumber}) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the `judge` users collection
      final CollectionReference usersCollection = firestore.collection(AppConstant.judge);

      // Query for a document with the given phone number
      final QuerySnapshot querySnapshot = await usersCollection
          .where(AppConstant.phoneNumber, isEqualTo: phoneNumber)
          .get();

      // Check if any documents were returned
      if (querySnapshot.docs.isNotEmpty) {
        // User exists, now check the isActive field
        final DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Ensure the 'isActive' field exists in the document
        if (userDoc.exists && userDoc.data() != null) {
          final bool isActive = userDoc.get(AppConstant.isActive);
          if (isActive) {
            return true; // User is active
          } else {
            SnackbarHelper.showWarning("القاضي غير مفعل, الرجاء متابعة المسؤول لتفعيل حسابك");
            return false; // User is not active
          }
        } else {
          SnackbarHelper.showError("القاضي غير موجد");
          return false; // User does not exist or is missing required fields
        }
      } else {
        SnackbarHelper.showError("القاضي غير موجد1");
        return false; // User does not exist
      }
    } catch (e) {
      SnackbarHelper.showError("هناك مشكلة من الخادم");
      return false;
    }
  }


}
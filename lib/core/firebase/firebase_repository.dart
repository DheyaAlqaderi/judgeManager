import 'package:cloud_firestore/cloud_firestore.dart';

import '../utills/helpers/snackbar_helper.dart';

class FirebaseRepository{

  static final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  /// Get all cases from the Firestore collection
  static Stream<QuerySnapshot> getAllCases({ required String phoneNumber, String procedure = " "}) {
    if(procedure == " "){
      return _firebaseFirestore.collection('cases').where('judge_number', isEqualTo: phoneNumber).snapshots();
    } else {
      return _firebaseFirestore
          .collection('cases')
          .where('judge_number', isEqualTo: phoneNumber)
          .where('procedure', isEqualTo: procedure)
          .snapshots();
    }

  }

  /// Get all cases filtered by a specific date
  static Stream<QuerySnapshot> getAllCasesByDate({required String date, required String phoneNumber, String procedure = " "}) {
    if(procedure == " "){
      return _firebaseFirestore
          .collection('cases')
          .where('session_date', isEqualTo: date)
          .where('judge_number', isEqualTo: phoneNumber)
          .where('isDeleted', isEqualTo: false)
          .snapshots();
    } else{
      return _firebaseFirestore
          .collection('cases')
          .where('session_date', isEqualTo: date)
          .where('judge_number', isEqualTo: phoneNumber)
          .where('isDeleted', isEqualTo: false)
          .where('procedure', isEqualTo: procedure)
          .snapshots();

    }

  }

  /// Get all cases filtered by a specific procedure
  static Stream<QuerySnapshot> getAllCasesByProcedure({required String procedure, required String phoneNumber}) {
    return _firebaseFirestore
        .collection('cases')
        .where('procedure', isEqualTo: procedure)
        .where('judge_number', isEqualTo: phoneNumber)
        .where('isDeleted', isEqualTo: false)
        .snapshots();
  }

  /// Get all procedure
  static Stream<QuerySnapshot> getAllProcedure() {
    return _firebaseFirestore
        .collection('procedures')
        .snapshots();
  }

  /// get judge document
  static Stream<DocumentSnapshot> getJudgeDocument(String phoneNumber) {
    return _firebaseFirestore
        .collection('judge')
        .doc(phoneNumber) // Reference to the document with the specific ID
        .snapshots();
  }

  // Function to update the 'isDelivered' field of the document 'case1'
  static Future<void> updateIsDeliveredIsPaidCaseState(
      {required String caseId, required bool isBool, required String fieldName}) async {
    try {
      await _firebaseFirestore
          .collection('cases')
          .doc(caseId) // Reference to the document 'case1'
          .update({
        fieldName: isBool, // Update the 'isDelivered' field
      });
    } catch (e) {
      SnackbarHelper.showError('failed $e');
    }
  }

  // Function to get all cases where session_date < "2024-08-06"
  static Stream<QuerySnapshot> getCasesBeforeDate(String date, String phoneNumber, {String procedure = " "}) {
    if(procedure == " "){
      return _firebaseFirestore
          .collection('cases')
          .where('session_date', isLessThan: date) // Query to filter dates
          .snapshots();
    }else{
      return _firebaseFirestore
          .collection('cases')
          .where('session_date', isLessThan: date) // Query to filter dates
          .snapshots();
    }

  }
}



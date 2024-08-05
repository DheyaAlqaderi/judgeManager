import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRepository{

  static final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  /// Get all cases from the Firestore collection
  static Stream<QuerySnapshot> getAllCases({ required String phoneNumber}) {
    return _firebaseFirestore.collection('cases').where('judge_number', isEqualTo: phoneNumber).snapshots();
  }

  /// Get all cases filtered by a specific date
  static Stream<QuerySnapshot> getAllCasesByDate({required String date, required String phoneNumber}) {
    return _firebaseFirestore
        .collection('cases')
        .where('session_date', isEqualTo: date)
        .where('judge_number', isEqualTo: phoneNumber)
        .snapshots();
  }

  /// Get all cases filtered by a specific procedure
  static Stream<QuerySnapshot> getAllCasesByProcedure({required String procedure, required String phoneNumber}) {
    return _firebaseFirestore
        .collection('cases')
        .where('procedure', isEqualTo: procedure)
        .where('judge_number', isEqualTo: phoneNumber)
        .snapshots();
  }

  /// Get all procedure
  static Stream<QuerySnapshot> getAllProcedure() {
    return _firebaseFirestore
        .collection('procedures')
        .snapshots();
  }

  static Stream<DocumentSnapshot> getJudgeDocument(String phoneNumber) {
    return _firebaseFirestore
        .collection('judge')
        .doc(phoneNumber) // Reference to the document with the specific ID
        .snapshots();
  }
}



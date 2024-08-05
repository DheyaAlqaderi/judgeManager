import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:judgemanager/core/utills/images/images_path.dart';

import '../../../../core/firebase/firebase_repository.dart';


class EditorHomeScreen extends StatefulWidget {
  const EditorHomeScreen({super.key,required this.phoneNumber,required this.name});
  final phoneNumber;
  final name;

  @override
  State<EditorHomeScreen> createState() => _EditorHomeScreenState();
}

class _EditorHomeScreenState extends State<EditorHomeScreen> {

  String? procedureValue;
  String? selectedProcedure;

  @override
  Widget build(BuildContext context) {
    // Check if phoneNumber is null
    if (procedureValue == null) {
      return const Center(child: CircularProgressIndicator()); // Or any other placeholder widget
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height:10 ,width: double.infinity,),
            // Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                  image: AssetImage(Images.judgeProfile),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            // Name
            Text(
              'القاضي: ${widget.name}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black
              ),
            ),
            const SizedBox(height: 5),
            // Email
            Text(widget.phoneNumber),
            const SizedBox(height: 10),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseRepository.getAllProcedure(),
              builder: (context, procedureSnapshot) {
                if (procedureSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (procedureSnapshot.hasError) {
                  return Center(child: Text('Error: ${procedureSnapshot.error}'));
                }

                if (!procedureSnapshot.hasData || procedureSnapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No procedures available'));
                }

                final documents = procedureSnapshot.data!.docs;
                final procedures = List<String>.generate(
                  3,
                      (index) => index < documents.length
                      ? (documents[index].data() as Map<String, dynamic>)['name'] as String? ?? ''
                      : '',
                );

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: procedures.map((procedure) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseRepository.getAllCasesByProcedure(
                        procedure: procedure,
                        phoneNumber: widget.phoneNumber,
                      ),
                      builder: (context, casesSnapshot) {
                        if (casesSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (casesSnapshot.hasError) {
                          return Center(child: Text('Error: ${casesSnapshot.error}'));
                        }

                        if (!casesSnapshot.hasData || casesSnapshot.data!.docs.isEmpty) {
                          return GestureDetector(
                            onTap: () {
                              print('Procedure clicked: $procedure');
                              setState(() {
                                selectedProcedure = procedure;
                              });
                            },
                            child: buildCounter("0", 'للأطلاع'),
                          );
                        }

                        final cases = casesSnapshot.data!.docs;
                        final procedureCount = cases.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return data['procedure'] == procedure;
                        }).length;

                        return GestureDetector(
                          onTap: () {
                            print('Procedure clicked: $procedure');
                            setState(() {
                              selectedProcedure = procedure;
                            });
                          },
                          child: buildCounter(procedureCount.toString(), procedure),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),


            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      // Get.to(()=> const FirstAddProperty());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                      child: SvgPicture.asset(
                        Images.addIcon,
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      // Get.to(()=> const FirstAddProperty());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.brown
                        ),
                        child: const Center(
                          child: Icon(Icons.filter_list),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (selectedProcedure != null)
            StreamBuilder(
                stream: FirebaseRepository.getAllCasesByProcedure(phoneNumber: widget.phoneNumber,procedure: selectedProcedure!),
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No cases available'));
                  }
                  final List<Widget> caseWidgets = snapshot.data!.docs.map((doc) {
                    final caseData = doc.data() as Map<String, dynamic>;

                    return Stack(
                      children: [
                        Container(
                          width: double.infinity, // Adjust width for better readability
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.grey, // Background color
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                caseData['case_title'] ?? 'No Title',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      caseData['appellant'] ?? 'Unknown',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.brown,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  const Text(
                                    ' :المدعي ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: [

                                  Expanded(
                                    child: Text(
                                      caseData['respondent'] ?? 'Unknown',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.brown,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),

                                  const Text(
                                    ' :المدعى عليه ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      caseData['case_number'] ?? 'Unknown',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.brown,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  const Text(
                                    ' :رقم القضية ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      caseData['procedure'] ?? 'Unknown',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.brown,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  const Text(
                                    ' :نوع القضية ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),

                        Positioned(
                          top: 0,
                          left: 0,
                          child: InkWell(
                            onTap: (){
                              // Show the alert dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('تأكيد الحذف'),
                                    content: const Text('هل أنت متأكد من حذف هذه القضية'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          // Cancel the deletion
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('رجوع',style: TextStyle(color: Colors.brown)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Confirm the deletion
                                          Navigator.of(context).pop();
                                          // Perform the delete operation here
                                          deleteItem(caseData['case_id']);
                                        },
                                        child: const Text('حذف', style: TextStyle(color: Colors.brown),),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey
                                ),
                                child: const Center(
                                  child: Icon(Icons.highlight_remove, color: Colors.brown,),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }).toList();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 15.0, // Horizontal space between containers
                      runSpacing: 15.0, // Vertical space between containers
                      children: caseWidgets,
                    ),
                  );
                }
            )

        ],
        ),
      ),

    );
  }

  Widget buildCounter(String count, String label) {
    return Column(
      children: [
        Container(
          height: 75,
          width: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFF3ECEC),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count ,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Future<void> deleteItem(item) async {
    // Implement your delete logic here
    try {
      // Get a reference to the Firestore collection and document
      await FirebaseFirestore.instance.collection('cases').doc(item).delete();
      print('Item deleted successfully');
    } catch (e) {
      print('Failed to delete item: $e');
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:judgemanager/core/utills/images/images_path.dart';
import 'package:judgemanager/features/add_case/persentation/pages/add_case.dart';

import '../../../../core/firebase/firebase_repository.dart';
import '../../../../core/utills/widgets/case_widget_common.dart';


class EditorHomeScreen extends StatefulWidget {
  const EditorHomeScreen({super.key,required this.phoneNumber,required this.name});
  final phoneNumber;
  final name;

  @override
  State<EditorHomeScreen> createState() => _EditorHomeScreenState();
}

class _EditorHomeScreenState extends State<EditorHomeScreen> {

  String? procedureValue = " ";
  String? selectedProcedure;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                        Get.to(()=>  AddCase(judgeNumber: widget.phoneNumber,));
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

                      return CaseWidgetCommon(
                        judgeNumber: caseData['judge_number'],
                          caseId: caseData['case_id'],
                          isAdmin:true,
                          appellant: caseData['appellant'] ?? 'Unknown',
                          caseNumber: caseData['case_number'] ?? 'Unknown',
                          dayName: caseData['day_name'] ?? 'Unknown',
                          isCaseStatus: caseData['case_status'] ?? false,
                          isDelivered: caseData['delivered'] ?? false,
                          isPaid: caseData['is_paid'] ?? false,
                          procedure: caseData['procedure'] ?? 'Unknown',
                          respondent: caseData['respondent'] ?? 'Unknown',
                          sessionDate: caseData['session_date'] ?? "",
                          sessionDateHijri: caseData['session_date_hijri']?? ' ',
                          yearHijri: caseData['year_hijri']?? ' ',
                        isCaseStatusFunction: () async {
                            await FirebaseRepository.updateIsDeliveredIsPaidCaseState(
                                caseId: caseData['case_id'],
                                isBool: caseData['case_status']?false:true,
                                fieldName: 'case_status'
                            );
                        },
                        deleteItem: () async {
                          await FirebaseRepository.updateIsDeliveredIsPaidCaseState(
                              caseId: caseData['case_id'],
                              isBool: caseData['isDeleted']?true:true,
                              fieldName: 'isDeleted'
                          );
                        },
                        isDeliveredFunction: () async {
                          await FirebaseRepository.updateIsDeliveredIsPaidCaseState(
                              caseId: caseData['case_id'],
                              isBool: caseData['delivered']?false:true,
                              fieldName: 'delivered'
                          );
                        },
                        isPaidFunction: () async {
                        await FirebaseRepository.updateIsDeliveredIsPaidCaseState(
                            caseId: caseData['case_id'],
                            isBool: caseData['is_paid']?false:true,
                            fieldName: 'is_paid'
                        );
                      },
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
}

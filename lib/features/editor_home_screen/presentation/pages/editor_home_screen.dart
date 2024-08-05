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
  @override
  Widget build(BuildContext context) {
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
                          return const Center(child: Text('No cases available'));
                        }

                        final cases = casesSnapshot.data!.docs;
                        final procedureCount = cases.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return data['procedure'] == procedure;
                        }).length;

                        return buildCounter(procedureCount.toString(), procedure);
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
                  // InkWell(
                  //   onTap: (){},
                  //   child: Container(
                  //     width: 52,
                  //     height: 40,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(100),
                  //       color: Theme.of(context).cardColor,
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: SvgPicture.asset(
                  //
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 20),


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
}

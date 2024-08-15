import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:judgemanager/core/firebase/firebase_repository.dart';

import '../../../features/edit_case/persentation/pages/edit_case.dart';

class CaseWidgetCommon extends StatefulWidget {
  CaseWidgetCommon({
    super.key,
    required this.caseNumber,
    required this.yearHijri,
    required this.procedure,
    required this.appellant,
    required this.respondent,
    required this.isCaseStatus,
    required this.isPaid,
    required this.isDelivered,
    required this.sessionDateHijri,
    required this.sessionDate,
    required this.dayName,
    required this.isAdmin,
  this.isCaseStatusFunction,
  this.isDeliveredFunction,
  this.isPaidFunction,
  this.deleteItem});

  String caseNumber;
  String yearHijri;
  String procedure;
  String appellant;
  String respondent;
  bool isCaseStatus;
  bool isPaid;
  bool isDelivered;
  String sessionDateHijri;
  String sessionDate;
  String dayName;
  bool isAdmin;
  dynamic isDeliveredFunction, isPaidFunction, isCaseStatusFunction, deleteItem;

  @override
  State<CaseWidgetCommon> createState() => _CaseWidgetCommonState();
}

class _CaseWidgetCommonState extends State<CaseWidgetCommon> {

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: widget.isCaseStatus?Colors.green:Colors.redAccent, width: 2.0), // Red border
                borderRadius: BorderRadius.circular(10.0), // Same border radius as the Card
              ),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditCase()));
                },
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0), // Ensure the border radius matches
                    ),

                  child:Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.caseNumber,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, // Make this text bold
                                ),
                              ),
                            ),
                            const Text(
                              "  :رقم القضية",
                              style: TextStyle(
                                  color: Colors.brown, // Use a lighter color for readability
                                  fontSize: 16
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8), // Add spacing between rows
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "هـ ${widget.yearHijri}",
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, // Make this text bold
                                ),
                              ),
                            ),
                            const Text(
                              "  :لسنة",
                              style: TextStyle(
                                  color: Colors.brown, // Use a lighter color for readability
                                  fontSize: 16
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.procedure,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, // Make this text bold
                                ),
                              ),
                            ),
                            const Text(
                              "  :قرار الجلسة",
                              style: TextStyle(
                                color: Colors.brown, // Use a lighter color for readability
                                fontSize: 16
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.appellant,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, // Make this text bold
                                ),
                              ),
                            ),
                            const Text(
                              "  :المستأنف",
                              style: TextStyle(
                                  color: Colors.brown, // Use a lighter color for readability
                                  fontSize: 16
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.respondent,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, // Make this text bold
                                ),
                              ),
                            ),
                            const Text(
                              "  :المستأنف ضده",
                              style: TextStyle(
                                  color: Colors.brown, // Use a lighter color for readability
                                  fontSize: 16
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Expanded(
                              child: Text(
                                "${widget.dayName}   ${widget.sessionDateHijri}   ${widget.sessionDate}",
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, // Make this text bold
                                ),
                              ),
                            ),
                            const Text(
                              "  :موعد الجلسة",
                              style: TextStyle(
                                  color: Colors.brown, // Use a lighter color for readability
                                  fontSize: 16
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )


                ),
              ),
            ),
          ),



          Positioned(
              top: 20,
              left: 20,
              child: InkWell(
                onTap: widget.isDeliveredFunction,
                child: Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: widget.isDelivered?Colors.brown:Colors.white,
                    border: Border.all(color: Colors.brown,width: 1)
                ),

                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Center(
                    child: widget.isDelivered
                        ?const Row(
                      children: [
                        Text(" تم إرجاع الملف ", style: TextStyle(color: Colors.white),),
                        Icon(Icons.check, color: Colors.white,)
                      ],
                    )
                        :const Row(
                      children: [
                        Text("لم يتم إرجاع الملف ", style: TextStyle(color: Colors.brown),),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          (widget.procedure != 'للأطلاع' && widget.procedure != 'حكم')?Positioned(
              top: 90,
              left: 20,
              child: InkWell(
                onTap: widget.isPaidFunction,
                child: Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: widget.isPaid?Colors.brown:Colors.white,
                    border: Border.all(color: Colors.brown,width: 1)
                ),

                child:  Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Center(
                    child: widget.isPaid?const Row(
                      children: [
                        Text(" تم إستلام الاتعاب ", style: TextStyle(color: Colors.white),),
                        Icon(Icons.check, color: Colors.white,)
                      ],
                    ):const Row(
                      children: [
                        Text("لم يتم إستلام الاتعاب ", style: TextStyle(color: Colors.brown),),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ):SizedBox(),

          widget.isAdmin?Positioned(
              top: 55,
              left: 20,
              child: InkWell(
                onTap: widget.isCaseStatusFunction,
                child: Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: widget.isCaseStatus?Colors.brown:Colors.white,
                    border: Border.all(color: Colors.brown,width: 1)
                ),

                child:  Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Center(
                    child: widget.isCaseStatus?const Row(
                      children: [
                        Text(" تم الأنجاز ", style: TextStyle(color: Colors.white),),
                        Icon(Icons.check, color: Colors.white,)
                      ],
                    ):const Row(
                      children: [
                        Text(" لم يتم الأنجاز ", style: TextStyle(color: Colors.brown),)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ):const SizedBox.shrink(),


          widget.isAdmin?Positioned(
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
                          onPressed: ()  {
                             widget.deleteItem(); // Call the deleteItem function
                            Navigator.of(context).pop(); // Close the dialog or page
                          },
                          child: const Text(
                            'حذف',
                            style: TextStyle(color: Colors.brown),
                          ),
                        )

                      ],
                    );
                  },
                );
              },
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red
                ),
                child: const Center(
                  child: Icon(Icons.highlight_remove, color: Colors.brown,),
                ),
              ),
            ),
          ):const SizedBox.shrink()
        ],
      );
  }
}

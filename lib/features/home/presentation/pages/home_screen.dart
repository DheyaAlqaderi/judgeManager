

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:judgemanager/core/constant/app_constant.dart';
import 'package:judgemanager/core/firebase/firebase_repository.dart';
import 'package:judgemanager/core/utills/helpers/functions_date/get_date.dart';
import 'package:judgemanager/core/utills/helpers/local_database/shared_pref.dart';
import 'package:collection/collection.dart';
import '../../../../core/utills/widgets/case_widget_common.dart';
import '../../../editor_home_screen/presentation/pages/editor_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 3;
  String tomorrow='';
  String? phoneNumber;


  Future<void> getPhoneNumber() async {
    final phone = await SharedPrefManager.getData(AppConstant.userPhoneNumber);
    if (phone != null && phone.isNotEmpty) {
      setState(() {
        phoneNumber = phone;
      });
      print(phoneNumber);
    }
  }


  final List<String> _options = ['الكل','للأطلاع', 'حكم', 'تحصيل'];
  String? _selectedProcedureValue;

  void _showDropdown() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _options.map((String option) {
              return ListTile(
                title: Text(option),
                onTap: () {
                  setState(() {
                    _selectedProcedureValue = option;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getPhoneNumber();
    setState(() {
      _selectedProcedureValue = _options[0];
    });
  }
  @override
  Widget build(BuildContext context) {
    // Check if phoneNumber is null
    if (phoneNumber == null) {
      return const Center(child: CircularProgressIndicator()); // Or any other placeholder widget
    }
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [

            Stack(
              children: [

                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.black54], // ألوان التدرج
                      begin: Alignment.bottomRight, // بداية التدرج
                      end: Alignment.topLeft, // نهاية التدرج
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20), // تحديد نصف قطر الزاوية السفلية اليسرى
                      bottomRight: Radius.circular(20), // تحديد نصف قطر الزاوية السفلية اليمنى
                    ),
                  ),
                ),


                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40,),
                        StreamBuilder(
                            stream:  FirebaseRepository.getJudgeDocument(phoneNumber!),
                            builder:(context, snapshot){
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              }

                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return const Center(child: Text('No data available'));
                              }
                              final docData = snapshot.data!.data() as Map<String, dynamic>;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text( "القاضي/ ${docData['name']}",style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) =>  EditorHomeScreen(name: docData['name'],phoneNumber: docData['phone_number'],)),
                                      );
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFFC67C4E), Colors.grey], // ألوان التدرج
                                          begin: Alignment.bottomRight, // بداية التدرج
                                          end: Alignment.topLeft, // نهاية التدرج
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                        color: const Color(0xFFC67C4E),
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.edit, color: Colors.white,),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }
                        ),

                        const SizedBox(height: 65,),
                        Row(
                          children: [
                            /// search
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 60,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFC67C4E), Colors.grey], // ألوان التدرج
                                      begin: Alignment.bottomRight, // بداية التدرج
                                      end: Alignment.topLeft, // نهاية التدرج
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: const Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Icon(Icons.search, color: Colors.white, size: 30),
                                      ),
                                      Text('...بحث', style: TextStyle(color: Colors.white, fontSize: 20)),
                                    ],
                                  ),
                                ),
                              ),
                            ),


                            /// filter
                            InkWell(
                              onTap: _showDropdown,
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFC67C4E), Colors.grey], // ألوان التدرج
                                    begin: Alignment.bottomRight, // بداية التدرج
                                    end: Alignment.topLeft, // نهاية التدرج
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  color: const Color(0xFFC67C4E),

                                ),
                                child: const Center(
                                  child: Icon(Icons.filter_alt_outlined, color: Colors.white, size: 30,),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            /// appbar section

            Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if(_selectedIndex == index){

                              }else {
                                _selectedIndex = index; // تحديث العنصر المحدد
                              }
                            });

                          },
                          child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: _selectedIndex == index ? Colors.grey : Colors.brown, // تغيير اللون بناءً على العنصر المحدد
                            ),
                            child:  Center(
                                child: Text(
                                  0 == index?"اليوم":(1 == index)?"غدًا":(2 == index)?"بعد غدًا":"الكل",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedIndex == index ? Colors.black : Colors.white
                                  ),
                                )
                            ),

                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5,),
             const SizedBox(height: 5,),
             (3 == _selectedIndex)
                 ?Column(
               children: [
                 // _buildStream(stream: FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getTodayDate(),procedure: _selectedProcedureValue==_options[0]?" ":_selectedProcedureValue!), dayH: GetDate.getDayH(),date: GetDate.getTodayDate()),
                 _buildStream(stream: FirebaseRepository.getAllCases(phoneNumber: phoneNumber!), dayH: GetDate.getDayH(),date: GetDate.getTodayDate()),
                 // _buildStream(stream: FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getNextDay(),procedure: _selectedProcedureValue==_options[0]?" ":_selectedProcedureValue!), dayH: GetDate.getNextDayH(),date: GetDate.getNextDay()),
                 // _buildStream(stream: FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getNextNextDay(),procedure: _selectedProcedureValue==_options[0]?" ":_selectedProcedureValue!), dayH: GetDate.getNextNextDayH(), date: GetDate.getNextNextDay()),
                 //
                 // _buildStream(stream: FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getNextNext1Day(),procedure: _selectedProcedureValue==_options[0]?" ":_selectedProcedureValue!), dayH: GetDate.getNextNext1DayH(),date: GetDate.getNextNext1Day()),
                 // _buildStream(stream: FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getNextNext2Day(),procedure: _selectedProcedureValue==_options[0]?" ":_selectedProcedureValue!), dayH: GetDate.getNextNext2DayH(),date: GetDate.getNextNext2Day()),
                 // _buildStream(stream: FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getNextNext3Day(),procedure: _selectedProcedureValue==_options[0]?" ":_selectedProcedureValue!), dayH: GetDate.getNextNext3DayH(), date: GetDate.getNextNext3Day()),
                 // _buildStream(stream: FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getNextNext4Day(),procedure: _selectedProcedureValue==_options[0]?" ":_selectedProcedureValue!), dayH: GetDate.getNextNext4DayH(), date: GetDate.getNextNext4Day()),

                 // const SizedBox(height: 20,),
                 // Text('كل القضايا ما قبل ${GetDate.getTodayDate()}', style: const TextStyle(fontWeight: FontWeight.bold),),
                 // _buildStream(stream: FirebaseRepository.getCasesBeforeDate(GetDate.getTodayDate(), phoneNumber!,procedure: _selectedProcedureValue==_options[0]?" ":_selectedProcedureValue!), dayH: GetDate.getNextNext4DayH(), date: GetDate.getNextNext4Day(), beforeYesterday: true),

               ],
             ):Column(
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Align(
                         alignment: Alignment.centerRight,
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text("${(2 == _selectedIndex) ?GetDate.getNextNextDayH():(1 == _selectedIndex) ?GetDate.getNextDayH()  : GetDate.getDayH()} - ${GetDate.getMonthH()} - ${GetDate.getYearH()}هـ", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.deepPurple),),
                         )
                     ),
                     Align(
                         alignment: Alignment.centerLeft,
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text((0 == _selectedIndex)?GetDate.getTodayDate():(1 == _selectedIndex)?GetDate.getNextDay():GetDate.getNextNextDay(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.deepPurple),),
                         )
                     ),
                   ],
                 ),
                 StreamBuilder<QuerySnapshot>(
                   stream: (0 == _selectedIndex)
                       ?FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getTodayDate(),procedure: _selectedProcedureValue==_options[0]?" ":_selectedProcedureValue!)
                       : (1 == _selectedIndex)
                       ?FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getNextDay(),procedure: _selectedProcedureValue==_options[0]?" ":_selectedProcedureValue!)
                       : (2 == _selectedIndex)
                       ?FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getNextNextDay(),procedure: _selectedProcedureValue==_options[0]?" ":_selectedProcedureValue!)
                       :FirebaseRepository.getAllCases(phoneNumber:phoneNumber??'0',procedure: _selectedProcedureValue==_options[0]?" ":_selectedProcedureValue!),
                   builder: (context, snapshot) {
                     if (snapshot.connectionState == ConnectionState.waiting) {
                       return const Center(child: CircularProgressIndicator());
                     }

                     if (snapshot.hasError) {
                       return Center(child: Text('Error: ${snapshot.error}'));
                     }

                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                       return const SizedBox();
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
                           yearHijri: caseData['year_hijri']?? ' ');
                     }).toList();

                     return Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Wrap(
                         spacing: 15.0, // Horizontal space between containers
                         runSpacing: 15.0, // Vertical space between containers
                         children: caseWidgets,
                       ),
                     );
                   },
                 ),
               ],
             ),

          ],
        ),
      ),
    );
  }

  _buildStream({required dynamic stream, required dynamic dayH,required dynamic date,bool beforeYesterday = false}){
    return Column(
      children: [
        // !beforeYesterday?Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Align(
        //         alignment: Alignment.centerRight,
        //         child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Text("$dayH - ${GetDate.getMonthH()} - ${GetDate.getYearH()}هـ", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.deepPurple),),
        //         )
        //     ),
        //     Align(
        //         alignment: Alignment.centerLeft,
        //         child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Text(date, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.deepPurple),),
        //         )
        //     ),
        //   ],
        // ):const SizedBox.shrink(),
        StreamBuilder<QuerySnapshot>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('لا يوجد قضايا هذا اليوم'));
            }

            // Filter cases based on selected procedure
            final cases = snapshot.data!.docs.where((doc) {
              final caseData = doc.data() as Map<String, dynamic>;

              if (_selectedProcedureValue == 'الكل') {
                return !caseData['isDeleted'];
              }

              return caseData['procedure'] == _selectedProcedureValue && !caseData['isDeleted'];
            }).toList();

            // Sort cases by session_date
            cases.sort((a, b) {
              final aDate = DateTime.parse((a.data() as Map<String, dynamic>)['session_date'] ?? '1970-01-01');
              final bDate = DateTime.parse((b.data() as Map<String, dynamic>)['session_date'] ?? '1970-01-01');
              return aDate.compareTo(bDate);
            });

            // Separate cases into today's cases, future cases, and past cases
            final now = DateTime.now();
            final todayCases = <QueryDocumentSnapshot>[];
            final futureCases = <QueryDocumentSnapshot>[];
            final pastCases = <QueryDocumentSnapshot>[];

            for (var doc in cases) {
              final sessionDate = DateTime.parse((doc.data() as Map<String, dynamic>)['session_date'] ?? '1970-01-01');
              if (sessionDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
                todayCases.add(doc);
              } else if (sessionDate.isAfter(now)) {
                futureCases.add(doc);
              } else {
                pastCases.add(doc);
              }
            }

            // Function to build case widgets
            List<Widget> buildCaseWidgets(List<QueryDocumentSnapshot> caseDocs) {
              final groupedCases = groupBy(caseDocs, (doc) {
                final caseData = doc.data() as Map<String, dynamic>;
                return caseData['session_date'] ?? 'Unknown';
              });

              final List<Widget> caseWidgets = [];
              groupedCases.forEach((sessionDate, docs) {
                final sessionDateTime = DateTime.parse(sessionDate);
                caseWidgets.add(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  convertToHijri(sessionDateTime),
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                                ),
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  sessionDate,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                                ),
                              )),
                        ],
                      ),
                      ...docs.map((doc) {
                        final caseData = doc.data() as Map<String, dynamic>;
                        return CaseWidgetCommon(
                          judgeNumber: caseData['judge_number'],
                          caseId: caseData['case_id'],
                          isAdmin: true,
                          appellant: caseData['appellant'] ?? 'Unknown',
                          caseNumber: caseData['case_number'] ?? 'Unknown',
                          dayName: caseData['day_name'] ?? 'Unknown',
                          isCaseStatus: caseData['case_status'] ?? false,
                          isDelivered: caseData['delivered'] ?? false,
                          isPaid: caseData['is_paid'] ?? false,
                          procedure: caseData['procedure'] ?? 'Unknown',
                          respondent: caseData['respondent'] ?? 'Unknown',
                          sessionDate: caseData['session_date'] ?? "",
                          sessionDateHijri: caseData['session_date_hijri'] ?? ' ',
                          yearHijri: caseData['year_hijri'] ?? ' ',
                          deleteItem: () async {
                            await FirebaseRepository.updateIsDeliveredIsPaidCaseState(
                                caseId: caseData['case_id'],
                                isBool: caseData['isDeleted'] ? true : true,
                                fieldName: 'isDeleted');
                          },
                          isDeliveredFunction: () async {
                            await FirebaseRepository.updateIsDeliveredIsPaidCaseState(
                                caseId: caseData['case_id'],
                                isBool: caseData['delivered'] ? false : true,
                                fieldName: 'delivered');
                          },
                          isPaidFunction: () async {
                            await FirebaseRepository.updateIsDeliveredIsPaidCaseState(
                                caseId: caseData['case_id'],
                                isBool: caseData['is_paid'] ? false : true,
                                fieldName: 'is_paid');
                          },
                          isCaseStatusFunction: () async {
                            await FirebaseRepository.updateIsDeliveredIsPaidCaseState(
                                caseId: caseData['case_id'],
                                isBool: caseData['case_status']?false:true,
                                fieldName: 'case_status'
                            );
                          },
                        );
                      }).toList(),
                    ],
                  ),
                );
              });
              return caseWidgets;
            }

            final List<Widget> caseWidgets = [
              ...buildCaseWidgets(todayCases),
              ...buildCaseWidgets(futureCases),
              ...buildCaseWidgets(pastCases),
            ];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 15.0, // Horizontal space between containers
                runSpacing: 15.0, // Vertical space between containers
                children: caseWidgets,
              ),
            );
          },
        )
      ],
    );
  }
  String convertToHijri(DateTime gregorianDate) {
    HijriCalendar.setLocal("ar");
    HijriCalendar hijriDate = HijriCalendar.fromDate(gregorianDate);
    final hijriYear = hijriDate.hYear;
    final hijriMonth = hijriDate.hMonth;
    final hijriMonthN = hijriDate.getLongMonthName(); // Get month name in Arabic
    final hijriDay = hijriDate.hDay;
    final hijriDayN = hijriDate.getDayName();

    return '$hijriYear - $hijriMonth - $hijriDay   ($hijriDayN - $hijriMonthN)';
  }
}


import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = -1;
  String tomorrow='';

  @override
  void initState() {
    super.initState();
    // tomorrow = getTomorrowDate(); // Initialize the value
  }
  final List<String> stringList = [
    'Container 1',
    'Container 2',
    'Container 3',
    'Container 4',
    'Container 5',
    'Container 6',
    'Container 7',
    'Container 8',
    'Container 9',
    'Container 10'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [

            /// appbar section
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Text('أحمد محب حمزة' ,style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.grey, Color(0xFFC67C4E)], // ألوان التدرج
                                  begin: Alignment.bottomRight, // بداية التدرج
                                  end: Alignment.topLeft, // نهاية التدرج
                                ),
                                borderRadius: BorderRadius.circular(25),
                                color: const Color(0xFFC67C4E),
                              ),
                              child: const Center(
                                child: Icon(Icons.settings, color: Colors.white,),
                              ),
                            )
                          ],
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
                                      colors: [Colors.grey, Color(0xFFC67C4E)], // ألوان التدرج
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
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.grey, Color(0xFFC67C4E)], // ألوان التدرج
                                  begin: Alignment.bottomRight, // بداية التدرج
                                  end: Alignment.topLeft, // نهاية التدرج
                                ),
                                borderRadius: BorderRadius.circular(25),
                                color: const Color(0xFFC67C4E),

                              ),
                              child: const Center(
                                child: Icon(Icons.filter_alt_outlined, color: Colors.white, size: 30,),
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
            Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(3, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = index; // تحديث العنصر المحدد

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
                                  2 == index?"اليوم":(1 == index)?"غدًا":"باقي الأيام",
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
             Column(
               children: [
                 Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${(1 == _selectedIndex) ? getNextDay(_getDay1())  : _getDay1()} - ${_getMonth()} - ${_getYear()}هـ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    )
                           ),

                 const SizedBox(height: 5,),
                 (02 == _selectedIndex)?StreamBuilder<QuerySnapshot>(
                   stream: FirebaseFirestore.instance
                       .collection('cases')
                       .where('session_date', isEqualTo: getTodayDate())
                       .snapshots(),
                   builder: (context, snapshot) {
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

                       return Container(
                         width: double.infinity, // Adjust width for better readability
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(18),
                           color: Colors.grey, // Background color
                         ),
                         padding: EdgeInsets.all(8.0),
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
                             SizedBox(height: 8.0),
                             Row(
                               crossAxisAlignment: CrossAxisAlignment.end,
                               children: [
                                 Expanded(
                                   child: Text(
                                     caseData['appellant'] ?? 'Unknown',
                                     style: TextStyle(
                                       fontWeight: FontWeight.bold,
                                       fontSize: 16.0,
                                       color: Colors.brown,
                                     ),
                                     textAlign: TextAlign.right,
                                   ),
                                 ),
                                 Text(
                                   ' :المدعي ',
                                   style: TextStyle(
                                     fontWeight: FontWeight.bold,
                                     color: Colors.black,
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 4.0),
                             Row(
                               children: [

                                 Expanded(
                                   child: Text(
                                     caseData['respondent'] ?? 'Unknown',
                                     style: TextStyle(
                                       fontWeight: FontWeight.bold,
                                       fontSize: 16.0,
                                       color: Colors.brown,
                                     ),
                                     textAlign: TextAlign.right,
                                   ),
                                 ),

                                 Text(
                                   ' :المدعى عليه ',
                                   style: TextStyle(
                                     fontWeight: FontWeight.bold,
                                     color: Colors.black,
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 4.0),
                             Row(
                               children: [
                                 Expanded(
                                   child: Text(
                                     caseData['case_number'] ?? 'Unknown',
                                     style: TextStyle(
                                       fontWeight: FontWeight.bold,
                                       fontSize: 16.0,
                                       color: Colors.brown,
                                     ),
                                     textAlign: TextAlign.right,
                                   ),
                                 ),
                                 Text(
                                   ' :رقم القضية ',
                                   style: TextStyle(
                                     fontWeight: FontWeight.bold,
                                     color: Colors.black,
                                   ),
                                 ),
                               ],
                             ),

                           ],
                         ),
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
                   },
                 )
                     :StreamBuilder<QuerySnapshot>(
                   stream: FirebaseFirestore.instance
                       .collection('cases')
                       .where('session_date', isEqualTo: getNextDayDate())
                       .snapshots(),
                   builder: (context, snapshot) {
                     if (snapshot.connectionState == ConnectionState.waiting) {
                       return const Center(child: CircularProgressIndicator());
                     }

                     if (snapshot.hasError) {
                       return Center(child: Text('Error: ${snapshot.error}'));
                     }

                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                       return const Center(child: Text('لا يوجد قضايا'));
                     }

                     final List<Widget> caseWidgets = snapshot.data!.docs.map((doc) {
                       final caseData = doc.data() as Map<String, dynamic>;

                       return Container(
                         width: double.infinity, // Adjust width for better readability
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(18),
                           color: Colors.grey, // Background color
                         ),
                         padding: EdgeInsets.all(8.0),
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
                             SizedBox(height: 8.0),
                             Row(
                               crossAxisAlignment: CrossAxisAlignment.end,
                               children: [
                                 Expanded(
                                   child: Text(
                                     caseData['appellant'] ?? 'Unknown',
                                     style: TextStyle(
                                       fontWeight: FontWeight.bold,
                                       fontSize: 16.0,
                                       color: Colors.brown,
                                     ),
                                     textAlign: TextAlign.right,
                                   ),
                                 ),
                                 Text(
                                   ' :المدعي ',
                                   style: TextStyle(
                                     fontWeight: FontWeight.bold,
                                     color: Colors.black,
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 4.0),
                             Row(
                               children: [

                                 Expanded(
                                   child: Text(
                                     caseData['respondent'] ?? 'Unknown',
                                     style: TextStyle(
                                       fontWeight: FontWeight.bold,
                                       fontSize: 16.0,
                                       color: Colors.brown,
                                     ),
                                     textAlign: TextAlign.right,
                                   ),
                                 ),

                                 Text(
                                   ' :المدعى عليه ',
                                   style: TextStyle(
                                     fontWeight: FontWeight.bold,
                                     color: Colors.black,
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 4.0),
                             Row(
                               children: [
                                 Expanded(
                                   child: Text(
                                     caseData['case_number'] ?? 'Unknown',
                                     style: TextStyle(
                                       fontWeight: FontWeight.bold,
                                       fontSize: 16.0,
                                       color: Colors.brown,
                                     ),
                                     textAlign: TextAlign.right,
                                   ),
                                 ),
                                 Text(
                                   ' :رقم القضية ',
                                   style: TextStyle(
                                     fontWeight: FontWeight.bold,
                                     color: Colors.black,
                                   ),
                                 ),
                               ],
                             ),

                           ],
                         ),
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
                   },
                 ),



               ],
             ),

          ],
        ),
      ),
    );
  }
  String getNextDayDate() {
    final now = DateTime.now();
    final nextDay = now.add(const Duration(days: 1));
    return '${nextDay.year}-${nextDay.month.toString().padLeft(2, '0')}-${nextDay.day.toString().padLeft(2, '0')}';
  }

  String getTodayDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  String _getDay1(){
    // Get the current date and time
    DateTime now = DateTime.now();

    // Get the day of the week as an integer (0 = Monday, 1 = Tuesday, ..., 6 = Sunday)
    int dayOfWeek = now.weekday;

    // Convert the day of the week integer to a readable string
    String dayName;
    switch (dayOfWeek) {
      case DateTime.monday:
        dayName = 'الأثنين';
        break;
      case DateTime.tuesday:
        dayName = 'الثلاثاء';
        break;
      case DateTime.wednesday:
        dayName = 'الأربعاء';
        break;
      case DateTime.thursday:
        dayName = 'الخميس';
        break;
      case DateTime.friday:
        dayName = 'الجمعة';
        break;
      case DateTime.saturday:
        dayName = 'السبت';
        break;
      case DateTime.sunday:
        dayName = 'الأحد';
        break;
      default:
        dayName = 'Unknown';
    }

    return dayName;
  }

  String _getMonth(){
    // Get the current Gregorian date
    DateTime now = DateTime.now();

    // Convert the Gregorian date to Hijri date
    HijriCalendar hijriDate = HijriCalendar.fromDate(now);

    // Get the current month in Hijri
    int hijriMonth = hijriDate.hMonth;
    String hijriMonthName;

    // Map Hijri month number to month name
    switch (hijriMonth) {
      case 1:
        hijriMonthName = 'مُحرَّم';
        break;
      case 2:
        hijriMonthName = 'صفر';
        break;
      case 3:
        hijriMonthName = 'ربيع الأول';
        break;
      case 4:
        hijriMonthName = 'ربيع الآخر';
        break;
      case 5:
        hijriMonthName = 'جمادى الأولى';
        break;
      case 6:
        hijriMonthName = 'جمادى الآخرة';
        break;
      case 7:
        hijriMonthName = 'رجب';
        break;
      case 8:
        hijriMonthName = 'شعبان';
        break;
      case 9:
        hijriMonthName = 'رمضان';
        break;
      case 10:
        hijriMonthName = 'شوّال';
        break;
      case 11:
        hijriMonthName = 'ذو القعدة';
        break;
      case 12:
        hijriMonthName = 'ذو الحجة';
        break;
      default:
        hijriMonthName = 'غير معروف';
    }

    // Print the current Hijri month
    return hijriMonthName;
  }

  String _getYear(){
    // Get the current Gregorian date
    DateTime now = DateTime.now();

    // Convert the Gregorian date to Hijri date
    HijriCalendar hijriDate = HijriCalendar.fromDate(now);

    int hijriYear = hijriDate.hYear;
    // Print the current Hijri month
    return hijriYear.toString();
  }
  String _getDay(int dayOfWeek) {
    // Convert the day of the week integer to a readable string
    switch (dayOfWeek) {
      case DateTime.monday:
        return 'الأثنين';
      case DateTime.tuesday:
        return 'الثلاثاء';
      case DateTime.wednesday:
        return 'الأربعاء';
      case DateTime.thursday:
        return 'الخميس';
      case DateTime.friday:
        return 'الجمعة';
      case DateTime.saturday:
        return 'السبت';
      case DateTime.sunday:
        return 'الأحد';
      default:
        return 'غير معروف';
    }
  }

  String getNextDay(String currentDay) {
    // Mapping of Arabic days to their English equivalents
    final Map<String, String> dayMapping = {
      'الأحد': 'Sunday',
      'الاثنين': 'Monday',
      'الثلاثاء': 'Tuesday',
      'الأربعاء': 'Wednesday',
      'الخميس': 'Thursday',
      'الجمعة': 'Friday',
      'السبت': 'Saturday'
    };

    // Reverse mapping for output
    final Map<String, String> reverseDayMapping = {
      'Sunday': 'الأحد',
      'Monday': 'الاثنين',
      'Tuesday': 'الثلاثاء',
      'Wednesday': 'الأربعاء',
      'Thursday': 'الخميس',
      'Friday': 'الجمعة',
      'Saturday': 'السبت'
    };

    // Get the English name of the current day
    final currentDayInEnglish = dayMapping[currentDay];
    if (currentDayInEnglish == null) {
      throw ArgumentError('Invalid day provided');
    }

    // List of days in English
    final List<String> daysOfWeek = [
      'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
    ];

    // Find the index of the current day
    final currentIndex = daysOfWeek.indexOf(currentDayInEnglish);

    // Calculate the index of the next day
    final nextIndex = (currentIndex + 1) % 7;

    // Get the next day in English
    final nextDayInEnglish = daysOfWeek[nextIndex];

    // Return the next day in Arabic
    return reverseDayMapping[nextDayInEnglish]!;
  }
}

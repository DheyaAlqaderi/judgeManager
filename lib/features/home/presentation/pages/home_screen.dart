

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:judgemanager/core/constant/app_constant.dart';
import 'package:judgemanager/core/firebase/firebase_repository.dart';
import 'package:judgemanager/core/utills/helpers/functions_date/get_date.dart';
import 'package:judgemanager/core/utills/helpers/local_database/shared_pref.dart';

import '../../../editor_home_screen/presentation/pages/editor_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = -1;
  String tomorrow='';
  String? phoneNumber;

  Future<void> getPhoneNumber()async{
    final phone = await SharedPrefManager.getData(AppConstant.userPhoneNumber);
    if(phone != null && phone.isNotEmpty){
      setState(() {
        phoneNumber = phone;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPhoneNumber();
  }
  @override
  Widget build(BuildContext context) {
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
                            stream:  FirebaseRepository.getJudgeDocument(phoneNumber??""),
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
                                      Navigator.of(context).pushReplacement(
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
                            Container(
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
                                  3 == index?"اليوم":(2 == index)?"غدًا":(1 == index)?"بعد غدًا":"باقي الأيام",
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
             (0 == _selectedIndex)
                 ?Column(
               children: [
                 _buildStream(stream: FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getTodayDate()), dayH: GetDate.getDayH(),date: GetDate.getTodayDate()),
                 _buildStream(stream: FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getNextDay()), dayH: GetDate.getNextDayH(),date: GetDate.getNextDay()),
                 _buildStream(stream: FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getNextNextDay()), dayH: GetDate.getNextNextDayH(), date: GetDate.getNextNextDay()),

                 _buildStream(stream: FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getNextNext1Day()), dayH: GetDate.getNextNext1DayH(),date: GetDate.getNextNext1Day()),
                 _buildStream(stream: FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getNextNext2Day()), dayH: GetDate.getNextNext2DayH(),date: GetDate.getNextNext2Day()),
                 _buildStream(stream: FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getNextNext3Day()), dayH: GetDate.getNextNext3DayH(), date: GetDate.getNextNext3Day()),
                 _buildStream(stream: FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getNextNext4Day()), dayH: GetDate.getNextNext4DayH(), date: GetDate.getNextNext4Day()),

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
                           child: Text("${(1 == _selectedIndex) ?GetDate.getNextNextDayH():(2 == _selectedIndex) ?GetDate.getNextDayH()  : GetDate.getDayH()} - ${GetDate.getMonthH()} - ${GetDate.getYearH()}هـ", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                         )
                     ),
                     Align(
                         alignment: Alignment.centerLeft,
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text((3 == _selectedIndex)?GetDate.getTodayDate():(2 == _selectedIndex)?GetDate.getNextDay():GetDate.getNextNextDay(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                         )
                     ),
                   ],
                 ),
                 StreamBuilder<QuerySnapshot>(
                   stream: (03 == _selectedIndex)
                       ?FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getTodayDate())
                       : (02 == _selectedIndex)
                       ?FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getNextDay())
                       : (01 == _selectedIndex)
                       ?FirebaseRepository.getAllCasesByDate(phoneNumber:phoneNumber!,date: GetDate.getNextNextDay())
                       :FirebaseRepository.getAllCases(phoneNumber:phoneNumber??'0'),
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

  _buildStream({required dynamic stream, required dynamic dayH,required dynamic date}){
    return Column(
      children: [
        const SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("$dayH - ${GetDate.getMonthH()} - ${GetDate.getYearH()}هـ", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                )
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(date, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                )
            ),
          ],
        ),

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
    );
  }
}

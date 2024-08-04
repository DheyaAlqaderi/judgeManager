import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:judgemanager/core/constant/app_constant.dart';
import 'package:judgemanager/core/utills/helpers/local_database/shared_pref.dart';
import 'package:judgemanager/core/utills/images/images_path.dart';
import 'package:judgemanager/features/login/domain/repository/login_repository.dart';
import 'package:judgemanager/features/login/presentation/pages/login_screen.dart';

import '../home/presentation/pages/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    getUserPhone();
  }

  Future<void> getUserPhone() async {
    // Retrieve the user phone number from shared preferences
    final userPhone = await SharedPrefManager.getData(AppConstant.userPhoneNumber);
    Future.delayed(const Duration(seconds: 1), () async {
      if (userPhone
          .toString()
          .isNotEmpty && userPhone != null) {
        bool checkIsActive = await LoginRepository.isUserActive(
            phoneNumber: userPhone.toString());
        if (checkIsActive) {
          // Navigate to HomeScreen if userPhone has a value
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // Navigate to LoginScreen if userPhone is null or empty
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      } else {
        // Navigate to LoginScreen if userPhone is null or empty
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Positioned(
            top: 0,
            right: 0,
            child: Hero(
                tag: 'image1',
                child: SvgPicture.asset(Images.circleImage,)),
          ),

          Center(
            child: Image.asset(Images.justiceImage),
          ),

          const Positioned(
            bottom: 40,
            right: 0,
            left: 0,
            child: Center(child: Text(
              '! مرحبًا بك',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),),
          ),
          const Positioned(
            bottom: 10,
            right: 0,
            left: 0,
            child: Center(child: CircularProgressIndicator(color: Colors.black,),),
          )
        ],
      ),
    );
  }
}

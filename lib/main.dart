import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:judgemanager/core/utills/helpers/local_database/shared_pref.dart';
import 'package:judgemanager/core/utills/widgets/case_widget_common.dart';
import 'package:judgemanager/features/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'features/login/presentation/provider/login_provider.dart';
import 'firebase_options.dart';

void main() async {

  /// 1
  WidgetsFlutterBinding.ensureInitialized();

  /// 2
  await SharedPrefManager.init();

  ///for buttery icons and notifications to be fixable in colors
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  /// firebase initialize
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await SharedPrefManager.deleteData(AppConstant.userPhoneNumber);
  // await SharedPrefManager.deleteData(AppConstant.userIsActive);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return   ChangeNotifierProvider<LoginProvider>(
      create: (context) => LoginProvider(),
      child:  const GetMaterialApp(
        title: 'Judge App',
        home: SplashScreen()
      ),
    );
  }
}
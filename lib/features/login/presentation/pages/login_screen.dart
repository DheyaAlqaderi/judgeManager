import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:judgemanager/features/home/presentation/pages/home_screen.dart';
import 'package:judgemanager/features/login/presentation/provider/login_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/utills/widgets/custome_text_field_widget.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginProvider>(
      create: (context) => LoginProvider(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: SvgPicture.asset("assets/svg/image4.svg"), // Use Image.asset instead of SvgPicture.asset for images
              ),
              Positioned(
                top: 50.0,
                right: 0,
                child: Hero(tag: "image1",child: SvgPicture.asset("assets/svg/image2.svg")),
              ),
              const Positioned(
                top: 100.0,
                left: 20.0,
                child: Column(
                  children: [
                    Text("تسجيل", style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),),

                    Text("الدخول", style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 300,left: 20,right: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextFieldWidget(
                          controller: _emailController,
                          hintText: "أدخل رقم هاتفك",
                          name: "أدخل رقم هاتفك",
                          textInputType: TextInputType.number,
                          isPassword: false,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFieldWidget(
                          controller: _passwordController,
                          hintText: "أدخل كلمة السر",
                          name: "أدخل كلمة السر",
                          textInputType: TextInputType.visiblePassword,
                          isPassword: true,
                        ),
                        const SizedBox(height: 30.0),
                        Consumer<LoginProvider>(
                          builder: (context,loginProvider,child) {
                          return SizedBox(
                            height: 61,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_emailController.text.isNotEmpty) {
                                  if (_passwordController.text.isNotEmpty) {
                                    await Provider.of<LoginProvider>(context,
                                            listen: false)
                                        .login(
                                            phoneNumber: _emailController.text
                                                .toString()
                                                .trim(),
                                            password: _passwordController.text
                                                .toString()
                                                .trim());
                                  }
                                }
                                if (context.read<LoginProvider>().isLogin) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen()));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: loginProvider.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'تسجيل',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                            ),
                          );
                        }),

                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

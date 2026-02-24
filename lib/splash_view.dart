import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notely/core/services/local_storage.dart';
import 'package:notely/core/utils/app_images.dart';
import 'package:notely/core/utils/colors.dart';
import 'package:notely/core/utils/go.dart';
import 'package:notely/views/home.dart';
import 'package:notely/views/login.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
    Timer(Duration(seconds: 1), () {
      checkState();
    });
  }

  void checkState() async {
    bool? isLogin = await LocalStorage.getBool('isLogin');

    if (isLogin == true) {
      Go.toWithAnimationAndPopUntil(context, HomeView(), 1, 0);
    } else {
      Go.toWithAnimationAndPopUntil(context, LoginView(), 1, 0);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF0b183f),
      body: Center(child: Image.asset(AppImages.appLogo)),
    );
  }
}
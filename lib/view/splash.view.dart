import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/login.view.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Get.to(const LoginView());
    });
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Image(
        image: AssetImage('assets/logo@2x.png'),
        width: 200, // Ancho deseado
        height: 100, // Alto deseado
      )
          // child: Text(
          //   'Relojeria',
          //   style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 55,
          //       fontWeight: FontWeight.bold,
          //       fontFamily: 'MiFuentePersonalizada'),
          // ),
          ),
    );
  }
}

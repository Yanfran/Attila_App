// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/global.colors.dart';

class ButtonGlobal extends StatelessWidget {
  final VoidCallback onPressed;
  const ButtonGlobal({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: 55,
        decoration: BoxDecoration(
            color: GlobalColors.mainColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
              )
            ]),
        child: const Text('Iniciar sesión',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            )),
      ),
    );
  }
}

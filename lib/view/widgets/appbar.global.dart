import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/global.colors.dart';
import 'package:flutter_application_1/view/login.view.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white, // Personaliza el color del título
        ),
      ),
      backgroundColor: GlobalColors.mainColor,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ), // Icono de cierre de sesión (puedes cambiarlo)
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const LoginView(),
              ),
              (route) =>
                  false, // Eliminar todas las rutas actuales del historial
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

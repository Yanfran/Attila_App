import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue, // Personaliza el color del encabezado
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(
                  //   Icons.home, // Cambia esto al icono que desees
                  //   color: Colors.white, // Cambia el color del ícono aquí
                  //   size: 40, // Tamaño del ícono
                  // ),
                  SizedBox(width: 10), // Espacio entre el ícono y el texto
                  Image(
                    image: AssetImage('assets/logo@2x.png'),
                    width: 200, // Ancho deseado
                    height: 100, // Alto deseado
                  )
                  // Text(
                  //   'Relojeria',
                  //   style: TextStyle(
                  //     color: Colors.white, // Personaliza el color del texto
                  //     fontSize: 60,
                  //     fontFamily: 'MiFuentePersonalizada',
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          // Resto del contenido del Drawer
        ],
      ),
    );
  }
}

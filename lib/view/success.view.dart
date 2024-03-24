import 'package:flutter/material.dart';
// import 'package:flutter_application_1/utils/global.colors.dart';
import 'package:flutter_application_1/view/home.view.dart';
import 'package:flutter_application_1/view/widgets/appbar.global.dart';
import 'package:flutter_application_1/view/widgets/drawe.global.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Éxito!',
      ),
      drawer: const CustomDrawer(),
      body: const Center(
        child: AnimatedCheck(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar de regreso a la pantalla de inicio (Home)
          // Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  const HomeView(), // Reemplaza la pantalla actual con HomeView
            ),
          );
        },
        child: const Icon(Icons.check), // Icono del botón (puedes cambiarlo)
      ),
    );
  }
}

class AnimatedCheck extends StatefulWidget {
  const AnimatedCheck({Key? key}) : super(key: key);
  @override
  AnimatedCheckState createState() => AnimatedCheckState();
}

class AnimatedCheckState extends State<AnimatedCheck>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final ButtonStyle saveImage = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.green,
    minimumSize: const Size(200, 46),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius:
          BorderRadius.circular(10.0), // Personaliza el radio de borde
    ),
  );

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Duración de la animación
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0, // Tamaño inicial
      end: 1.0, // Tamaño final
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // Curva de animación
    ));

    _controller.forward(); // Inicia la animación
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Color de fondo del icono
                  shape: BoxShape.circle, // Forma del contenedor
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.green.withOpacity(0.5), // Color de la sombra
                      spreadRadius: 5, // Radio de expansión de la sombra
                      blurRadius: 10, // Radio de desenfoque de la sombra
                      offset: const Offset(0,
                          3), // Desplazamiento de la sombra (horizontal, vertical)
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 150.0, // Tamaño del ícono
                ),
              ),
              const SizedBox(height: 16), // Espacio entre el ícono y el texto
              const Text(
                'Imagen enviada con éxito',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        );
      },
    );
  }
}

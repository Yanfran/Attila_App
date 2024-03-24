// ignore_for_file: avoid_print, unused_local_variable, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/global.colors.dart';
import 'package:flutter_application_1/view/home.view.dart';
import 'package:flutter_application_1/view/widgets/button.global.dart';
import 'package:flutter_application_1/view/widgets/text.form.global.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showSpinner = false;

  final storage = const FlutterSecureStorage();

  void _handleSignInButtonPressed(
      String email, String password, BuildContext context) async {
    showSpinner = true;
    String codigoEmpleado = emailController.text;
    String clave = passwordController.text;

    setState(() {
      showSpinner = true;
    });

    if (codigoEmpleado.isEmpty || clave.isEmpty) {
      // Campos vacíos, muestra una alerta personalizada
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alerta'),
            content: const Text('Por favor, completa todos los campos.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      setState(() {
        showSpinner = false; // Ocultar el spinner después de la solicitud
      });
      return;
    }

    // final Uri uri = Uri.parse(
    //     'https://relojeriamx.000webhostapp.com/ReferidosBack/api/login.php');

    final Uri uri = Uri.parse('http://187.188.105.205:8082/ReferidosBack/api/login.php');
    final request = http.MultipartRequest('POST', uri);

    request.fields['clave'] = clave;
    request.fields['codigo_empleado'] = codigoEmpleado;

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final parsedResponse = json.decode(responseData);

        if (parsedResponse['result'] == true) {
          print(parsedResponse['data']);
          // Convierte el mapa en una cadena JSON
          final jsonData = json.encode(parsedResponse['data']);

          // Almacena la cadena JSON en el almacenamiento seguro
          await storage.write(key: 'userData', value: jsonData);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeView(),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Alerta'),
                content: const Text('Credenciales invalidas.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          print('Error en la solicitud: ${parsedResponse['msg']}');
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Alerta'),
              content: const Text('Ups, ocurrio un error inesperado.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alerta'),
            content: const Text('Ups, ocurrio un error inesperado.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      print('Error en la solicitud: $e');
    } finally {
      setState(() {
        showSpinner = false; // Ocultar el spinner después de la solicitud
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Container(
                alignment: Alignment.center,
                child: const Image(
                  image: AssetImage('assets/logo@2x.png'),
                  width: 200, // Ancho deseado
                  height: 100, // Alto deseado
                )
                // child: Text(
                //   'Relojeria',
                //   style: TextStyle(
                //       color: GlobalColors.mainColor,
                //       fontSize: 55,
                //       fontWeight: FontWeight.bold,
                //       fontFamily: 'MiFuentePersonalizada'),
                // ),
                ),
            const SizedBox(height: 50),
            Text(
              'Ingrese a su cuenta',
              style: TextStyle(
                color: GlobalColors.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15),

            // EMIL
            TextFormGlobal(
              controller: emailController,
              text: 'Código empleado',
              textInputType: TextInputType.emailAddress,
              // obscure: false,
              isPassword: false,
            ),
            // PASSWORD
            const SizedBox(height: 6),

            TextFormGlobal(
              controller: passwordController,
              text: 'Clave',
              textInputType: TextInputType.text,
              // obscure: true,
              isPassword: true,
            ),
            const SizedBox(height: 25),

            ButtonGlobal(
              onPressed: () => _handleSignInButtonPressed(
                  emailController.text, passwordController.text, context),
            ),
            const SizedBox(height: 6),

            Center(
              child: Stack(
                alignment: Alignment.center, // Centra el spinner en la pantalla
                children: [
                  const SingleChildScrollView(
                      // Tu contenido de diseño
                      ),
                  if (showSpinner)
                    const CircularProgressIndicator(), // Spinner circular
                ],
              ),
            ),
          ],
        ),
      ),
    )));
  }
}

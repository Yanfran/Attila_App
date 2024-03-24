// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:math';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/success.view.dart';
import 'package:flutter_application_1/view/widgets/appbar.global.dart';
import 'package:flutter_application_1/view/widgets/drawe.global.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final storage = const FlutterSecureStorage();
  Map<String, dynamic>?
      userData; // Variable para almacenar los datos recuperados
  String? imagePath;
  String? base64Image;
  // final String apiUrl =
  //     'https://relojeriamx.000webhostapp.com/ReferidosBack/api/register_assists.php';
  final String apiUrl =
      'http://187.188.105.205:8082/ReferidosBack/api/register_assists.php';
  bool showSpinner = false;
  double? latitudDispositivo;
  double? longitudeDispositivo;
  double? latitudBD;
  double? longitudeBD;
  bool isButtonEnabled = false;
  double? distancia;
  double? distanciaFinal;

  @override
  void initState() {
    super.initState();
    _getUserData();
    getCurrentLocation();
  }

  // OBTENER COORDENADAS DEL DISPOSITIVO
  Future<Position> determinePotition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Error');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  // Función para calcular la distancia en metros entre dos ubicaciones
  double calcularDistancia(
      double latitud1, double longitud1, double latitud2, double longitud2) {
    const radioTierra = 6371000.0; // Radio de la Tierra en metros (aproximado)

    // Convertir las latitudes y longitudes de grados a radianes
    final latitud1Rad = latitud1 * (pi / 180);
    final longitud1Rad = longitud1 * (pi / 180);
    final latitud2Rad = latitud2 * (pi / 180);
    final longitud2Rad = longitud2 * (pi / 180);

    // Diferencias entre las latitudes y longitudes
    final deltaLatitud = latitud2Rad - latitud1Rad;
    final deltaLongitud = longitud2Rad - longitud1Rad;

    // Calcular la distancia utilizando la fórmula de Haversine
    final a = pow(sin(deltaLatitud / 2), 2) +
        cos(latitud1Rad) * cos(latitud2Rad) * pow(sin(deltaLongitud / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distancia = radioTierra * c;

    distanciaFinal = distancia;

    // print(distancia);

    return distancia;
  }

  // void mostrarModal() {
  //   print("latitud db" + " " + userData?['sede']['latitud']);
  //   print("longitud db" + " " + userData?['sede']['longitud']);
  //   print("latitud dispositivo" + " " + '${latitudDispositivo}');
  //   print("longitud dispositivo" + " " + 'longitudeDispositivo');

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Data'),
  //         content: userData != null
  //             ? Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text('Bienvenido, ${userData?['nombre']}'),
  //                   Text(
  //                       'Descripción de la sede: ${userData?['sede']['descripcion']}'),
  //                   Text('Latitud de la sede: ${userData?['sede']['latitud']}'),
  //                   Text(
  //                       'Longitud de la sede: ${userData?['sede']['longitud']}'),
  //                   Text('Longitud del dispositivo: $latitudDispositivo',
  //                       style: const TextStyle(color: Colors.red)),
  //                   Text('Longitud del dispositivo: $longitudeDispositivo',
  //                       style: const TextStyle(color: Colors.red)),
  //                 ],
  //               )
  //             : const Text('Bienvenido'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // DATA ALMACENADA DEL USUARIO
  Future<void> _getUserData() async {
    try {
      final userDataString = await storage.read(key: 'userData');
      if (userDataString != null) {
        setState(() {
          userData = json.decode(userDataString);
        });
      }
    } catch (e) {
      print('Error al obtener los datos del usuario: $e');
    }
  }

  // FUNCION PARA OBTENER COORDENADAS
  Future<void> getCurrentLocation() async {
    final position = await determinePotition();
    setState(() {
      latitudDispositivo = position.latitude;
      longitudeDispositivo = position.longitude;
    });

    // Ahora que tenemos las coordenadas, podemos calcular la distancia y mostrarla.
    if (userData != null &&
        latitudDispositivo != null &&
        longitudeDispositivo != null) {
      double distancia = calcularDistancia(
        latitudDispositivo!,
        longitudeDispositivo!,
        double.parse(userData?['sede']['latitud']),
        double.parse(userData?['sede']['longitud']),
      );

      print(
          "La distancia entre la ubicación del dispositivo y la sede es de ${distancia.toStringAsFixed(2)} metros.");

      // Determinar si el botón debe estar habilitado o deshabilitado
      if (distancia > 100.00) {
        setState(() {
          isButtonEnabled = false;
        });
      } else {
        setState(() {
          isButtonEnabled = true;
        });
      }
    }
  }

  // FUNCION PARA GUARDAR IMAGEN EN EL SERVE
  void _saveImage(
      String imagePath,
      double latitudDispositivo,
      double longitudeDispositivo,
      String nombre,
      String codigoEmpleado,
      String idsede,
      BuildContext context) async {
    setState(() {
      showSpinner = true; // Mostrar el spinner
    });

    final compressedImage = await FlutterImageCompress.compressWithFile(
      imagePath,
      minWidth: 1200,
      minHeight: 700,
      quality: 50,
    );

    final compressedImageList = compressedImage?.toList();
    base64Image = base64Encode(compressedImageList!);

    try {
      // Aquí puedes agregar otros parámetros como campos adicionales en el FormData
      final formData = dio.FormData.fromMap({
        'imagen': dio.MultipartFile.fromBytes(
          compressedImageList,
          filename: 'imagen.png',
        ),
        'latitud': latitudDispositivo,
        'longitud': longitudeDispositivo,
        'nombre': nombre,
        'codigoEmpleado': codigoEmpleado,
        'idsede': idsede
      });

      final response = await dio.Dio().post(apiUrl, data: formData);

      if (response.statusCode == 200) {
        final responseData = response.data;
        // Aquí puedes acceder a los datos de responseData y mostrarlos como desees
        if (responseData["result"] == true) {
          // La inserción fue exitosa, puedes mostrar un mensaje de éxito
          print("Éxito: ${responseData["msg"]}");
          // print("Éxito: ${responseData["imagen"]}");
          // print("Éxito: ${responseData["latitud"]}");
          // print("Éxito: ${responseData["longitud"]}");
          // print("Éxito: ${responseData["nombre"]}");
          // print("Éxito: ${responseData["codigoEmpleado"]}");
          // print("Éxito: ${responseData["idsede"]}");

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  const SuccessView(), // Reemplaza la pantalla actual con HomeView
            ),
          );
        } else {
          // Hubo un error en el backend, puedes mostrar un mensaje de error
          print("Error: ${responseData["msg"]}");
        }
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Ups hubo un error, vuelve a intentar.'),
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
      }
    } catch (e) {
      print('Error al procesar la imagen: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Ups hubo un error, verifica tu conexion a internet.'),
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
    } finally {
      setState(() {
        showSpinner = false; // Ocultar el spinner después de la solicitud
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: userData != null
            ? 'Bienvenido, ${userData!['nombre']}'.toString()
            : 'Bienvenido',
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Capturar una imagen',
              style: TextStyle(
                fontSize: 26,
              ),
            ),
          ),
          (imagePath == null)
              ? Expanded(
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.70,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 5.0, color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Ink(
                              width: 150.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: (BoxShape.circle),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                                iconSize: 46,
                                onPressed: isButtonEnabled
                                    ? () async {
                                        // mostrarModal();
                                        setState(() {
                                          showSpinner = true;
                                        });

                                        final ImagePicker picker =
                                            ImagePicker();
                                        XFile? photo = await picker.pickImage(
                                            source: ImageSource.camera);

                                        if (photo != null) {
                                          setState(() {
                                            imagePath = photo.path;
                                            showSpinner = false;
                                          });
                                        } else {
                                          setState(() {
                                            showSpinner = false;
                                          });
                                        }
                                      }
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 3.0,
                                color: distanciaFinal != null &&
                                        distanciaFinal! > 100.0
                                    ? Colors.red
                                    : Colors.green),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Center(
                              child: Text(
                                distanciaFinal != null
                                    ? distanciaFinal! > 100.0
                                        ? "No te encuentras en tu puesto de trabajo."
                                        : "Te encuentras en una instalación autorizada, favor de enviar la foto."
                                    : "Distancia no disponible",
                                style: TextStyle(
                                  color: distanciaFinal != null &&
                                          distanciaFinal! > 100.0
                                      ? Colors.red
                                      : Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Expanded(
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.70,
                          // width: 400,
                          // height: 650,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 5.0, color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.file(
                                File(imagePath!),
                                width: 400,
                                height: 800,
                                fit: BoxFit
                                    .cover, // Ajusta la imagen al tamaño del contenedor
                              ),
                              if (showSpinner)
                                CircularProgressIndicator(
                                  strokeAlign: 5,
                                  strokeWidth: 10,
                                  backgroundColor: Colors.white,
                                  color: Colors.blue.shade900,
                                  semanticsLabel: 'Enviado...',
                                ), // Spinner circular
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(3.0),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Ink(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              iconSize: 36,
                              onPressed: () {
                                setState(() {
                                  imagePath = null;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Ink(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.upload,
                                color: Colors.white,
                              ), // Icono para enviar
                              iconSize: 36, // Tamaño del icono
                              onPressed: () {
                                _saveImage(
                                    imagePath!,
                                    latitudDispositivo!,
                                    longitudeDispositivo!,
                                    userData?['nombre'],
                                    userData?['codigo_empleado'],
                                    userData?['id_sede'],
                                    context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

          // COMENTARIOSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TextFormGlobal extends StatefulWidget {
  const TextFormGlobal({
    Key? key,
    required this.controller,
    required this.text,
    required this.textInputType,
    required this.isPassword,
  }) : super(key: key);

  final TextEditingController controller;
  final String text;
  final TextInputType textInputType;
  final bool isPassword; // Propiedad para determinar si es una contraseña

  @override
  _TextFormGlobalState createState() => _TextFormGlobalState();
}

class _TextFormGlobalState extends State<TextFormGlobal> {
  bool _obscureText = true; // Inicialmente oculto si es una contraseña

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.only(top: 3, left: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 7,
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.textInputType,
        obscureText: widget.isPassword ? _obscureText : false,
        decoration: InputDecoration(
          hintText: widget.text,
          border: InputBorder.none,
          // contentPadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.fromLTRB(15, 12, 0,
              12), // Ajusta el valor superior (top) según sea necesario
          hintStyle: const TextStyle(
            height: 1,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  bool? isObsecre =true;
  bool? enabled =true;

  CustomTextField({
    this.controller,
    this.data,
    this.hintText,
    this.isObsecre,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color:Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF0A0348).withOpacity(0.3),
              blurRadius: 4,
              offset: Offset(3, 3), // Shadow position
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10))),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(15.0),
      child: TextFormField(
        enabled:enabled,
        controller: controller,
        obscureText: isObsecre!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color:Color(0xFF0A0348),
        ),
        focusColor: Theme.of(context).primaryColor,
        hintText: hintText,
        ),
      ),

    );
  }
}

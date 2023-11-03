import 'dart:async';
import 'package:flutter/material.dart';
import '../auth_Screen/auth_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer(){
    Timer(const Duration(seconds: 8),() async{
      Navigator.push(context, MaterialPageRoute(builder: (c)=>const AuthScreen()));
    });
  }

  @override
  void initState(){
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child:Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(55.0, 0.0, 55.0, 0.0),
                child: Image.asset("imag/img2.png"),
              ),

              const Padding(
                padding: EdgeInsets.all(1.0),
                child:Text("Buy Your Favourite Food",textAlign: TextAlign.center,style: TextStyle(
                color: Colors.black54,
                fontSize:30,
                fontFamily: 'Signatra',
                ),)
              )
            ],
          ),
        ),
      )
    );
  }

}

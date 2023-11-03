import 'package:flutter/material.dart';
import 'register.dart';

import 'login.dart';
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
              ),
            ),
            automaticallyImplyLeading: false,
            title: const Text("N Food",
            style: TextStyle(
                fontSize: 50,
                color:Color(0xFF0A0348),
                fontFamily: "Signatra",
            ),),
            centerTitle: true,
            bottom: const TabBar(
                tabs: [
                   Tab(
                     icon:Icon(Icons.lock,color:Color(0xFF0A0348),),
                     text:"Login",
              ),
                  Tab(
                    icon:Icon(Icons.app_registration, color:Color(0xFF0A0348),),
                    text:"Register",
                  ),
            ],
            indicatorColor:Colors.indigo,
              indicatorWeight:6,
            ),
          ),
          body: Container(
            child: const TabBarView(
             children: [
              LoginScreen(),
              SignUpScreen(),
              ],
          ),
        ),
        )
    );
  }
}

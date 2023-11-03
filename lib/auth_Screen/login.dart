import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfood/widgets/error_dialog.dart';
import 'package:nfood/widgets/loding.dart';

import '../global/user_data.dart';
import '../mainScreens/home_screen.dart';
import '../widgets/custom_text_field.dart';
 class LoginScreen extends StatefulWidget {
   const LoginScreen({super.key});

   @override
   State<LoginScreen> createState() => _LoginScreenState();
 }

 class _LoginScreenState extends State<LoginScreen> {
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   TextEditingController emailController=TextEditingController();
   TextEditingController passwordController=TextEditingController();

   formValidation(){
     if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
       loginNow();
     }
     else{
       showDialog(
           context: context,
           builder:(c){
             return ErrorDialog(message: "Please write email and password",);
           });
     }
   }

   loginNow() async{
     showDialog(
         context: context,
         builder: (c){
           return LodingDialog(
             massage: "Registering Account",
           );
         }
     );
     User? currentUser;
     final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
     await firebaseAuth.signInWithEmailAndPassword(
       email: emailController.text.trim(),
       password: passwordController.text.trim(),
     ).then((auth) {
       currentUser=auth.user!;
       UserData.uid=currentUser?.uid;
     }).catchError((error){
       Navigator.pop(context);
       showDialog(
           context: context,
           builder: (c)
           {
             return ErrorDialog(
               message: error.message.toString(),
             );
           }
       );
     }
     );
     if(currentUser != null){
       Navigator.pop(context);
       Route newroute = MaterialPageRoute(builder:(c)=>HomeScreen() );
       Navigator.push(context, newroute);
     }
   }


   @override
   Widget build(BuildContext context) {
     return SingleChildScrollView(
       child: Column(
         mainAxisSize: MainAxisSize.max,
         children: [
           Container(
             alignment: Alignment.bottomCenter,
         child:Padding(
             padding: const EdgeInsets.only(
           top: 30,
           left: 10, // Left padding
           right: 10, // Right padding
           bottom: 30, // Bottom padding
         ),
             child: Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(35), // Adjust the radius as needed
                 boxShadow:  [
                   BoxShadow(
                     color:Color(0xFF0A0348).withOpacity(0.5),// Shadow color
                     offset: Offset(4, 3), // Offset of the shadow
                     blurRadius: 6, // Spread of the shadow
                     spreadRadius: 0, // Extra space added to the shadow
                   ),
                 ],
               ),
               child: ClipRRect(
                 borderRadius: BorderRadius.circular(35),
                 child: Image.asset(
                   "imag/img.png",
                   height: 180,
                   width: 500,
                 ),
               ),
             ),

         )
           ),
           Form(
             key:_formKey,
             child: Column(
               children: [
                 CustomTextField(
                   data:Icons.email,
                   controller: emailController,
                   hintText: "Email",
                   isObsecre: false,
                 ),
                 CustomTextField(
                   data:Icons.lock,
                   controller: passwordController,
                   hintText: "Password",
                   isObsecre: true,
                 ),
               ],
             ),
           ),
           const SizedBox( height: 5,),
           ElevatedButton(
             style: ElevatedButton.styleFrom(
                 primary: Colors.blueAccent,
                 padding: EdgeInsets.symmetric(horizontal: 40,vertical: 10)
             ),
             onPressed: (){
               formValidation();
             },
             child:const Text("SIGN IN",style:TextStyle(color: Colors.white),),

           )
         ],

       ),
     );
   }
 }

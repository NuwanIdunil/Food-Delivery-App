//import 'dart:html';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nfood/mainScreens/home_screen.dart';
import 'package:nfood/widgets/error_dialog.dart';
import 'package:nfood/widgets/loding.dart';
import '../global/user_data.dart';
import '../widgets/custom_text_field.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController locationController=TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker=ImagePicker();
  String imgurl='';

  Future<void> _getimage() async{
    imageXFile= await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }

  Future<void> formvalidation() async{
    if(passwordController.text == confirmPasswordController.text){
      if(confirmPasswordController.text.isNotEmpty && passwordController.text.isNotEmpty && nameController.text.isNotEmpty && emailController.text.isNotEmpty&& phoneController.text.isNotEmpty)
      {
       showDialog(
           context: context,
           builder: (c){
             return LodingDialog(
               massage: "Registering Account",
             );
           }
       );
        if(imageXFile != null) {
          String filemane = DateTime
              .now()
              .millisecondsSinceEpoch
              .toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref()
              .child("customer")
              .child(filemane);
          fStorage.UploadTask uploadTask = reference.putFile(
              File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot = await uploadTask
              .whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            imgurl = url;
            signUpAndAuthenticate();
          });
        }
        else{
          signUpAndAuthenticate();
        }
      }
      else{
        showDialog(
            context: context,
            builder: (c)
            {
              return ErrorDialog(
                message: "Please enter the required info for Registration",
              );
            }
        );
      }
    }
    else{
      showDialog(
          context: context,
          builder: (c)
      {
        return ErrorDialog(
          message: "Password do not match",
        );
      }
      );
    }
  }

  void signUpAndAuthenticate()async
  {
    User? currentuser;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.createUserWithEmailAndPassword(
        email:emailController.text.trim() ,
        password:passwordController.text.trim(),
    ).then((auth){
      currentuser=auth.user;
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

    });

    if (currentuser != null){
      saveDataToFirestore(currentuser!).then((value) {
       UserData.uid = currentuser?.uid;
        Navigator.pop(context);
        Route newroute = MaterialPageRoute(builder:(c)=>HomeScreen() );
        Navigator.push(context, newroute);
      });
    }
  }

  Future saveDataToFirestore(User currentuser) async{
    FirebaseFirestore.instance.collection("customer").doc(currentuser.uid).set({
      "customerId":currentuser.uid,
      "customerEmail":currentuser.email,
      "customerName":nameController.text.trim(),
      "customerimage":imgurl,
      "phone":phoneController.text.trim(),

    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children:[
            const SizedBox(height: 10,),
            InkWell(
              onTap:(){
                _getimage();
              } ,
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width*0.20,
                backgroundColor: Color(0xFF0A0348),
                backgroundImage: imageXFile == null? null: FileImage(File(imageXFile!.path)),
                child: imageXFile == null ?
                Icon(
                    Icons.add_photo_alternate,
                    size: MediaQuery.of(context).size.width*0.20,
                    color: Colors.grey,
                ):null,
              ),
            ),
            const SizedBox(height: 10,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data:Icons.person,
                    controller: nameController,
                    hintText: "Name",
                    isObsecre: false,
                  ),
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
                  CustomTextField(
                    data:Icons.lock,
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    isObsecre: true,
                  ),
                  CustomTextField(
                    data:Icons.phone,
                    controller: phoneController,
                    hintText: "Phone",
                    isObsecre: false,
                  ),
                ],
              ),

            ),
            const SizedBox( height: 10,),
          ElevatedButton(
              child:const Text("SIGN UP",style:TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF0A0348),
                padding: EdgeInsets.symmetric(horizontal: 80,vertical: 10)
              ),
            onPressed: (){
              formvalidation();
            },

          )
          ],
        ),
      ),
    );
  }
}

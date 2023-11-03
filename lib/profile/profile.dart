import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../global/user_data.dart';
import 'register.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userDataUid = UserData.uid;
  String customerName = " ";
  String customerEmail = "";
  String? customerphone;
  String customerImage = "";

  @override
  void initState() {
    super.initState();
    readDataFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(),
        ),
        title: const Text(
          "N Food",
          style: TextStyle(
            fontSize: 40,
            color: Color(0xFF0A0348),
            fontFamily: "Signatra",
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.network(
                customerImage.isNotEmpty
                    ? customerImage
                    : 'https://firebasestorage.googleapis.com/v0/b/nfood-c3088.appspot.com/o/food%2Fdownload.jpeg?alt=media&token=ed062712-bfe5-4e86-9ce0-13366b619583',
                cacheHeight: 150,
                cacheWidth: 150,
              ),
            ),
            Text(customerEmail, style: TextStyle(
              fontSize: 18,
              color: Colors.indigo.withOpacity(0.6),
              fontFamily: "Bebas",
            )),
            SizedBox(height: 40),
            Row(
              children: [
                Text(customerName, style: TextStyle(
                  fontSize: 18,
                  color: Colors.indigo.withOpacity(0.6),
                  fontFamily: "Bebas",
                )),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    showEditDialog("Name", customerName, (newName) {
                      updateUserData(newName, customerphone ?? "");
                    });
                  },
                  child: Icon(Icons.edit),
                ),
              ],
            ),
            Row(
              children: [
                Text(customerphone != null ? customerphone! : "No Phone", style: TextStyle(
                  fontSize: 18,
                  color: Colors.indigo.withOpacity(0.6),
                  fontFamily: "Bebas",
                )),
                SizedBox(width: 40),
                GestureDetector(
                  onTap: () {
                    showEditDialog("Phone", customerphone ?? "", (newPhone) {
                      updateUserData(customerName, newPhone);
                    });
                  },
                  child: Icon(Icons.edit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> readDataFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("customer")
        .doc(userDataUid)
        .get();

    if (snapshot.exists) {
      setState(() {
        customerEmail = snapshot.data()?["customerEmail"] ?? "";
        customerName = snapshot.data()?["customerName"] ?? "";
        customerImage = snapshot.data()?["customerimage"] ?? "";
        customerphone = snapshot.data()?["phone"] ?? "";
      });
    }
  }

  Future<void> updateUserData(String newCustomerName, String newCustomerPhone) async {
    final customerRef = FirebaseFirestore.instance.collection("customer").doc(userDataUid);

    try {
      await customerRef.update({
        "customerName": newCustomerName,
        "phone": newCustomerPhone,
      });

      setState(() {
        customerName = newCustomerName;
        customerphone = newCustomerPhone;
      });
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  void showEditDialog(String fieldName, String initialValue, Function(String) onEdit) {
    TextEditingController textController = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit $fieldName"),
          content: TextField(
            controller: textController,
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                onEdit(textController.text);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}

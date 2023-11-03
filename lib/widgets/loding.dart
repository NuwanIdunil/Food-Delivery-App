import 'package:flutter/material.dart';
import 'progress.dart';

class LodingDialog extends StatelessWidget {

  final String? massage;
  LodingDialog({this.massage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key:key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          SizedBox(height: 10,),
          Text(massage! + "Please wait"),
        ],
      ),
    );
  }
}

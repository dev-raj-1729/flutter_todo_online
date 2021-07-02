import 'package:flutter/material.dart';

class Alerts {
  static Future<bool?> confirmDelete(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Todo?'),
        content: Text('Are you sure you want to delete this?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  static void errorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_rounded,
              color: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

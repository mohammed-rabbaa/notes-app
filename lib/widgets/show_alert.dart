import 'package:flutter/material.dart';

showAlert(
  context,
  String title,
  String content,
) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(color: Colors.red, fontSize: 17),
          ),
          content: Text(content),
        );
      });
}

showLoading(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

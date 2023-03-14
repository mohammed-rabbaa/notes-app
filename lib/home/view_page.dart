// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class ViewNote extends StatelessWidget {
  const ViewNote({super.key, this.notes});
  final notes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Note'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.network(
                    '${notes['image Url']}',
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '${notes['Title Note']}',
                  style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    '${notes['Subtitle Note']}',
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SavedText extends StatelessWidget {
  final String savedText;

  const SavedText({Key? key, required this.savedText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Document ', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              savedText,
              style: TextStyle(
                fontSize: 16.0,
                // Add more styles as needed
              ),
            ),
          ),
        ),),)
          ],
        ),
      ),
    );
  }
}

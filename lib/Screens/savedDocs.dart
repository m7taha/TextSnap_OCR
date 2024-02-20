import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:textSnap_OCR/Screens/saved_text.dart';

class SavedDocuments extends StatefulWidget {
  const SavedDocuments({Key? key}) : super(key: key);

  @override
  State<SavedDocuments> createState() => _SavedDocumentsState();
}

class _SavedDocumentsState extends State<SavedDocuments> {
  List<Map<String, String>> files = [];

  @override
  void initState() {
    super.initState();
    loadFiles();
  }

  Future<void> loadFiles() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? keys = prefs.getKeys().toList();

      if (keys != null) {
        List<Map<String, String>> loadedFiles = [];
        for (String key in keys) {
          String? savedText = prefs.getString(key);
          if (savedText != null) {
            loadedFiles.add({'fileName': key, 'fileText': savedText});
          }
        }

        setState(() {
          files = loadedFiles;
        });
      }
    } catch (e) {
      print('Error loading files from SharedPreferences: $e');
      // Handle errors accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.folder),
            title: Text(files[index]['fileName'] ?? ''),
            onTap: () => navigateToRecognizedPage(files[index]),
          );
        },
      ),
    );
  }

  void navigateToRecognizedPage(Map<String, String> file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SavedText(savedText: file['fileText'] ?? ''),
      ),
    );
  }


}

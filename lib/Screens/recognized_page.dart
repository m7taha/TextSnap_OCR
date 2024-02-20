import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class RecognizedPage extends StatefulWidget {
  final String path;

  const RecognizedPage({super.key, required this.path});

  @override
  State<RecognizedPage> createState() => _RecognizedPageState();
}

class _RecognizedPageState extends State<RecognizedPage> {
  bool _isBusy = false;
  TextEditingController controller = TextEditingController();
  TextEditingController fileNameController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    processImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
              'Recognize Screen', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(icon: const Icon(Icons.check, color: Colors.white,),
              onPressed: () async {
               saveText(context);
              },)
          ],

        ),
        body: _isBusy == true
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                controller: controller,
                maxLines: MediaQuery
                    .of(context)
                    .size
                    .height
                    .toInt(),
                decoration: const InputDecoration(hintText: 'Text goes here'),
              ),
            ));
  }

  Future<void> processImage() async {
    final InputImage inputImage = InputImage.fromFilePath(widget.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(
          inputImage);
      controller.text = recognizedText.text;
    } catch (e) {
      print('Error processing image: $e');
      // Handle errors accordingly
    } finally {
      setState(() {
        _isBusy = false;
      });
    }
  }

  Future<void> saveText(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter File Name'),
          content: TextField(
            controller: fileNameController,
            decoration: const InputDecoration(labelText: 'File Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String fileName = fileNameController.text.trim();
                if (fileName.isNotEmpty) {
                  try {
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('$fileName', controller.text);

                    // Check if the widget is still mounted before navigating
                    if (mounted) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage()));
                    }
                  } catch (e) {
                    // Handle the exception (print or log the error details)
                    print('Error saving text: $e');
                  }
                }
              },
              child: const Text('Save'),
            ),

          ],
        );
      },
    );

  }
}
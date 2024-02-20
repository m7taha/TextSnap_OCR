import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textSnap_OCR/Screens/recognized_page.dart';
import 'package:textSnap_OCR/Screens/savedDocs.dart';
import 'package:textSnap_OCR/Screens/text_to_speech_screen.dart';


import '../Utils/image_cropper.dart';
import '../Utils/image_picker.dart';
import '../Utils/strings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 8),
                child: Text(
                  _currentIndex == 0 ? 'Home' : 'Saved Documents',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  MainPage(),
                  SavedDocuments(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 8,
        selectedItemColor: Colors.blue,
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.save_rounded), label: "Saved Documents")
        ],
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildContent(
            context: context,
            cardTitle: "Extract text from an image",
            cardDescription:
                "Use a photo from your gallery and extract the text",
            cardImage: AssetImage(imageText),
            onTap: () {
              // Show bottom sheet or perform any other action
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              pickImage(source: ImageSource.camera)
                                  .then((value) {
                                if (value != '') {
                                  imageCropperView(value, context)
                                      .then((value) {
                                    if (value != '') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => RecognizedPage(
                                            path: value,
                                          ),
                                        ),
                                      );
                                    }
                                  });
                                }
                              });
                            },
                            child: Card(
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Text(
                                    "Camera",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 0.025,
                          ),
                          GestureDetector(
                            onTap: () {
                              pickImage(source: ImageSource.gallery)
                                  .then((value) {
                                if (value != '') {
                                  imageCropperView(value, context)
                                      .then((value) {
                                    if (value != '') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => RecognizedPage(
                                            path: value,
                                          ),
                                        ),
                                      );
                                    }
                                  });
                                }
                              });
                            },
                            child: Card(
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Text(
                                    "Gallery",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          _buildContent(
            context: context,
            cardTitle: "Text to Speech",
            cardDescription: "Convert text into audio and listen to it",
            cardImage: AssetImage(audioBook),
            destinationScreen: const TextToSpeech(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required String cardTitle,
    required String cardDescription,
    required AssetImage cardImage,
    VoidCallback? onTap,
    Widget? destinationScreen,
  }) {
    return GestureDetector(
      onTap: onTap ??
          () {
            if (destinationScreen != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => destinationScreen,
                ),
              );
            }
          },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image(image: cardImage),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        cardTitle,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        bottom: MediaQuery.of(context).size.height * 0.04,
                      ),
                      child: Text(
                        cardDescription,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(2, 2),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'ffi.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Egg-Spector",
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Network CNN = Network();
  File? _img;
  int _isDamaged = 0;
  String displayText = "";
  ImagePicker imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final File imageFile = File(file.path);

      final img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

      if (image != null) {
        final img.Image resizedImage = img.copyResize(image, width: 500, height: 500);

        String newPath = '${imageFile.parent.path}/resized_image.png';

        final File resizedImageFile = File(newPath)..writeAsBytesSync(img.encodePng(resizedImage));

        setState(() {
          _isDamaged = CNN.run(newPath);
          if (_isDamaged == 1) {
            displayText = "Oops! Your egg is cracked!";
          } else {
            displayText = "Good news! Your egg is intact!";
          }

          _img = resizedImageFile;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Egg-Spector"),
        backgroundColor: Colors.amberAccent,
        centerTitle: true,
        elevation: 10,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        backgroundColor: Colors.amberAccent,
        child: Icon(Icons.add_a_photo, size: 30, color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _img != null
                ? Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.amber, width: 5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amberAccent.withOpacity(0.6),
                              spreadRadius: 5,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Image.file(
                          _img!,
                          height: 300,
                        ),
                      ),
                      SizedBox(height: 20),
                      AnimatedSwitcher(
                        duration: Duration(seconds: 1),
                        child: Text(
                          displayText,
                          key: ValueKey<String>(displayText),
                          style: TextStyle(
                            fontSize: 24,
                            color: _isDamaged == 1 ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Upload an image of your egg!",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

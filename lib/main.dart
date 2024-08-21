import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Egg-Spector",
      theme: ThemeData(
        primarySwatch: Colors.amber
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget{

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  File? _img;

  ImagePicker imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file!=null) {
      final File imageFile = File(file.path);

      final img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

      if (image!=null) {
        final img.Image resizedImage = img.copyResize(image, width: 500, height: 500);

        final File resizedImageFile = File('${imageFile.parent.path}/resized_image.png')
          ..writeAsBytesSync(img.encodePng(resizedImage));

        setState(() {
          _img = resizedImageFile;
        });
      }

      
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Egg-Spector")
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: "Pick files",
        child: Icon(Icons.add_a_photo)
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _img != null 
              ? Image.file(_img!)
              : Text("Upload an image")
          ],

          )
      )
    );
  }
}
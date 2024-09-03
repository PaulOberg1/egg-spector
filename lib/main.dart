import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'ffi.dart';

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

  Network CNN = Network();

  File? _img;

  int _isDamaged = 0;

  String displayText = "";

  ImagePicker imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file!=null) {
      final File imageFile = File(file.path);

      final img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

      if (image!=null) {
        final img.Image resizedImage = img.copyResize(image, width: 500, height: 500);

        String newPath = '${imageFile.parent.path}/resized_image.png';

        final File resizedImageFile = File(newPath)
          ..writeAsBytesSync(img.encodePng(resizedImage));

        setState(() {
          _isDamaged = CNN.run(newPath);
          displayText="result: $_isDamaged";
          
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
              ? Column(children: [
                Image.file(_img!),
                Text("Result: $displayText")
              ],)
              : Text("Upload an image")
          ],

          )
      )
    );
  }
}
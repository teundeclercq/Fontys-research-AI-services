import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File _image;
  String screenText = 'Maak een foto';
  Color clrRed = Colors.red[500];
  Color clrBlue = Colors.blue[500];

  Color clrSave = Colors.red[500];
  Color clrCamera = Colors.blue[500];
  Color clrOcr = Colors.red[500];

  Future getImage() async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    var image = File(pickedFile.path);
    setState(() {
      _image = image;
      clrSave = clrRed;
      clrOcr = clrBlue;
      clrCamera = clrBlue;
    });
  }

  Future ocr() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(_image);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    setState(() {
      _image = null;
      screenText = readText.text;

      if (screenText != "") {
        clrSave = clrBlue;
        clrOcr = clrRed;
        clrCamera = clrBlue;
      } else {
        clrSave = clrRed;
        clrOcr = clrRed;
        clrCamera = clrBlue;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCR',
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('OCR'),
            backgroundColor: clrBlue,
          ),
          body: new Center(
            child: _image == null
                ? new Text(screenText.toString())
                : new Image.file(_image),
          ),
          floatingActionButton:
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            FloatingActionButton(
              child: Icon(Icons.short_text),
              backgroundColor: clrOcr,
              onPressed: () => ocr(),
              heroTag: null,
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              child: Icon(Icons.add_a_photo),
              backgroundColor: clrCamera,
              onPressed: () => getImage(),
              heroTag: null,
            )
          ])),
    );
  }
}

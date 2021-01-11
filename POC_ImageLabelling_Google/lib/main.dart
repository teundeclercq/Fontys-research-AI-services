import 'dart:io';
import 'dart:math';

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
  Color clrBlue = Colors.blue[500];
  Color clrCamera = Colors.blue[500];

  Future getImage() async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    var image = File(pickedFile.path);
    setState(() {
      _image = image;
      clrCamera = clrBlue;
    });

    if (_image != null) {
      labeling();
    }
  }

  List<Chip> chips = [];

  Future labeling() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(_image);
    ImageLabeler recognizeLabel = FirebaseVision.instance.imageLabeler();
    List<ImageLabel> readText = await recognizeLabel.processImage(ourImage);
    screenText = "";
    List colors = [Colors.red, Colors.green, Colors.purple];
    Random random = new Random();

    for (ImageLabel imagelabel in readText) {
      setState(() {
        chips.add(new Chip(
          label: Text(
            imagelabel.text,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: colors[random.nextInt(3)],
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCR',
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('IMAGE LABEL'),
            backgroundColor: clrBlue,
          ),
          body: new Center(
            child: _image != null
                ? ListView(
                    children: <Widget>[
                      Image.file(_image),
                      Wrap(
                        spacing: 4.0,
                        runSpacing: 2.0,
                        children: <Widget>[...chips],
                      )
                    ],
                  )
                : Text(screenText.toString()),
          ),
          floatingActionButton:
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
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

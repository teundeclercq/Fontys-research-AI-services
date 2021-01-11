import 'dart:io' as oi;

import 'package:CvPrototype/models/cv_detail.dart';
import 'package:CvPrototype/providers/cv_details.dart';
import 'package:CvPrototype/screens/result_screen.dart';
import 'package:CvPrototype/screens/tips_screen.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imgPack;
import 'package:image_picker/image_picker.dart';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:ui' as ui;

class PhotoScreen extends StatefulWidget {
  static const routeName = '/photo';
  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

enum Smiling {
  BIG,
  NORMAL,
  NOT,
}

enum Eyes {
  OPEN,
  TIGHT,
  CLOSED,
}

class _PhotoScreenState extends State<PhotoScreen> {
  var _loadedInitData = false;
  //File _image;
  int _selectedPageIndex = 1;
  final picker = ImagePicker();
  String screenText = 'Maak een foto';
  bool _recognized = false;
  double grade = 10;
  Color colorDetail;
  IconData iconDetail;
  String synonymDetail;

  oi.File _imageFile;
  List<Face> _faces;
  bool isLoading = false;
  bool cropped = false;
  Color gradecolor;
  bool _noFace = false;

  imgPack.Image _imgCv;
  double smiling = 0;
  Smiling smile;
  Eyes eyes;

  String detailSubtitle;

  @override
  void didChangeDependencies() {
    if (!_loadedInitData) {
      // _imageFile = ModalRoute.of(context).settings.arguments;
      detectFaces(ModalRoute.of(context).settings.arguments);
      _loadedInitData = true;
    }
    super.didChangeDependencies();
  }

  detectFaces(oi.File imageFile) async {
    final image = FirebaseVisionImage.fromFile(imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector(
        FaceDetectorOptions(
            mode: FaceDetectorMode.accurate,
            enableLandmarks: true,
            enableClassification: true));
    List<Face> faces = await faceDetector.processImage(image);
    if (mounted) {
      setState(() {
        _imageFile = imageFile;
        _faces = faces;
        cropimage();
      });
    }
  }

  cropimage() async {
    if (_faces.length == 0) {
      setState(() {
        _noFace = true;
        showAlertDialog(context);
      });
    } else {
      imgPack.Image imgCv = imgPack.decodeImage(_imageFile.readAsBytesSync());
      Rect rectFace = _faces[0].boundingBox;
      _imgCv = imgPack.copyCrop(
          imgCv,
          rectFace.left.toInt() - 50,
          rectFace.top.toInt() - 50,
          rectFace.width.toInt() + 100,
          rectFace.height.toInt() + 100);
      _checkSmiling(_faces[0]);
      //_checkSmiling(_faces[0]);
      setState(() {
        cropped = true;
        _recognized = true;
      });
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context)
            .popAndPushNamed(ResultScreen.routeName, arguments: _imageFile);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("GEEN GEZICHT GEVONDEN"),
      content: Text("Er wordt geadviseerd om een foto op je cv te plaatsen."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _selectPage(int index) {
    if (cropped && _recognized) {
      if (_selectedPageIndex != 1) {
        setState(() {
          _selectedPageIndex = index;
        });
      }

      switch (index) {
        case 0:
          Navigator.of(context)
              .popAndPushNamed(ResultScreen.routeName, arguments: _imageFile);
          break;

        case 1:
          //Navigator.of(context)
          //    .popAndPushNamed(PhotoScreen.routeName, arguments: _imageFile);
          break;

        case 2:
          Navigator.of(context)
              .popAndPushNamed(TipsScreen.routeName, arguments: _imageFile);
          break;
      }
    }
  }

  void _checkSmiling(Face face) {
    var dblSmile = face.smilingProbability * 10;
    var dbleyeleft = face.leftEyeOpenProbability * 10;
    var dbleyeright = face.rightEyeOpenProbability * 10;

    grade = (dblSmile / 2) + (dbleyeleft / 4) + (dbleyeright / 4);

    if (grade >= 5.5) {
      gradecolor = Colors.green;
    } else {
      gradecolor = Colors.red;
    }

    if (dblSmile > 8) {
      smile = Smiling.BIG;
    } else {
      if (dblSmile > 5) {
        smile = Smiling.NORMAL;
      } else {
        smile = Smiling.NOT;
      }
    }

    if ((dbleyeleft + dbleyeright - 10) > 8) {
      eyes = Eyes.OPEN;
    } else {
      if ((dbleyeleft + dbleyeright - 10) > 5) {
        eyes = Eyes.TIGHT;
      } else {
        eyes = Eyes.CLOSED;
      }
    }
  }

  void generateSmileOutput() {
    switch (smile) {
      case Smiling.BIG:
        {
          colorDetail = Colors.green;
          iconDetail = Icons.sentiment_very_satisfied;
          detailSubtitle =
              'Je hebt een brede glimlach en dit is goed voor je CV!';
        }
        break;

      case Smiling.NORMAL:
        {
          colorDetail = Color.fromRGBO(255, 128, 0, 1);
          iconDetail = Icons.sentiment_satisfied;
          detailSubtitle =
              'Je het een mooie normale glimlach maar hij mag breder!';
        }
        break;

      case Smiling.NOT:
        {
          colorDetail = Color.fromRGBO(255, 0, 0, 1);
          iconDetail = Icons.sentiment_neutral;
          detailSubtitle = 'Je bent vrijwel niet aan het glimlachen.';
        }
        break;
    }
  }

  void generateEyeOutput() {
    switch (eyes) {
      case Eyes.OPEN:
        {
          colorDetail = Colors.green;
          iconDetail = Icons.remove_red_eye;
          detailSubtitle =
              'Je hebt je ogen duidelijk open. Dit geeft een vertouwelijk gevoel';
        }
        break;

      case Eyes.TIGHT:
        {
          colorDetail = Color.fromRGBO(255, 128, 0, 1);
          iconDetail = Icons.remove_red_eye;
          detailSubtitle = 'Je het je ogen vrijwel open maar dit kan beter! ';
        }
        break;

      case Eyes.CLOSED:
        {
          colorDetail = Color.fromRGBO(255, 0, 0, 1);
          iconDetail = Icons.remove_red_eye;
          detailSubtitle = 'Je hebt je ogen vrijwel gesloten.';
        }
        break;
    }
  }

  Widget feedbackWidget(String detailName) {
    return Card(
      child: ListTile(
        leading: Icon(
          iconDetail,
          size: 40,
          color: colorDetail,
        ),
        title: Text(detailName),
        subtitle: Text(detailSubtitle),
        contentPadding: EdgeInsets.all(8),
      ),
    );
  }

  List<Widget> showFeedbackAndGrades() {
    List<Widget> widgets = new List<Widget>();

    // colorDetail = Color.fromRGBO(255, 0, 0, 1);
    colorDetail = Color.fromRGBO(255, 128, 0, 1);

    generateSmileOutput();
    widgets.add(feedbackWidget('Glimlach'));

    widgets.add(SizedBox(
      height: 5,
    ));

    generateEyeOutput();
    widgets.add(feedbackWidget('Ogen'));

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(21, 43, 83, 1),
        title: Text('Feedback'),
      ),
      body: _noFace
          ? Center(
              child: Container(),
            )
          : !cropped && !_recognized
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: 200,
                                height: 270,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: Image.memory(
                                              imgPack.encodeJpg(_imgCv))
                                          .image),
                                )),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            'Door middel van het analyseren van jou gezicht impressie geven we jouw glimlach een'),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      grade.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 60,
                                        fontWeight: FontWeight.bold,
                                        color: gradecolor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 2,
                          height: 30,
                        ),
                        if (_recognized)
                          ...showFeedbackAndGrades()
                        else
                          CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Color.fromRGBO(21, 43, 83, 1),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.amber,
        currentIndex: _selectedPageIndex,
        // type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Feedback'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            title: Text('Foto'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stars),
            title: Text('Tips'),
          ),
        ],
      ),
    );
  }
}

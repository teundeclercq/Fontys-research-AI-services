import 'dart:io' as oi;

import 'package:CvPrototype/models/cv_detail.dart';
import 'package:CvPrototype/providers/cv_details.dart';
import 'package:CvPrototype/screens/Photo_screen.dart';
import 'package:CvPrototype/screens/tips_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class ResultScreen extends StatefulWidget {
  static const routeName = '/results';
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  var _loadedInitData = false;
  oi.File _image;
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;
  final picker = ImagePicker();
  String screenText = 'Maak een foto';
  List<String> _uploaded_cv_details = new List<String>();
  CvDetails cvDetails = new CvDetails();
  bool _recognized = false;
  bool _containDetail = false;
  bool _containSynonym = false;
  double grade = 10;
  Color gradecolor;
  Color colorDetail;
  IconData iconDetail;
  String synonymDetail;

  @override
  void initState() {
    // ...
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_loadedInitData) {
      // getImage();
      _image = ModalRoute.of(context).settings.arguments;
      ocr();
      _loadedInitData = true;
    }
    super.didChangeDependencies();
  }

  void _selectPage(int index) {
    if (_recognized) {
      if (_selectedPageIndex != 0) {
        setState(() {
          _selectedPageIndex = index;
        });
      }

      switch (index) {
        case 0:
          // Navigator.of(context)
          //    .popAndPushNamed(ResultScreen.routeName, arguments: _image);
          break;

        case 1:
          Navigator.of(context)
              .popAndPushNamed(PhotoScreen.routeName, arguments: _image);
          break;

        case 2:
          Navigator.of(context)
              .popAndPushNamed(TipsScreen.routeName, arguments: _image);
          break;
      }
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = oi.File(pickedFile.path);
        ocr();
      } else {
        print('No image selected.');
      }
    });
  }

  Future ocr() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(_image);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await recognizeText.processImage(ourImage);

    setState(() {
      screenText = visionText.text;
      for (TextBlock block in visionText.blocks) {
        for (TextLine cvLine in block.lines) {
          _uploaded_cv_details.add(cvLine.text.toLowerCase());
        }
      }
      _recognized = true;
      showFeedbackAndGrades();
    });
  }

  String filterText(String cvLine) {
    //  String cvLineFiltered = cvLine;
    //  for (String filterDetail in cvDetails.filters) {
    //     try {
    //      cvLineFiltered = cvLineFiltered.replaceAll(filterDetail, '');
    //     } catch (e) {}
    //   }
    //   print(cvLineFiltered);
    //   return cvLineFiltered;
  }

  List<Widget> showFeedbackAndGrades() {
    List<Widget> widgets = new List<Widget>();
    List<Widget> _dontContain = new List<Widget>();
    List<Widget> _synonymContain = new List<Widget>();
    List<Widget> _contain = new List<Widget>();

    String detailUsage = '';
    String detailName = '';
    grade = 10;

    for (CvDetail detail in cvDetails.details) {
      //String uploadedCvDetail in _uploaded_cv_details
      _containDetail = false;
      _containSynonym = false;

      for (String uploadedCvDetail in _uploaded_cv_details) {
        if (uploadedCvDetail.contains(detail.name)) {
          _containDetail = true;
        }
      }

      if (!_containDetail) {
        colorDetail = Color.fromRGBO(255, 0, 0, 1);
        // colorDetail = Colors.grey;
        iconDetail = Icons.assignment_ind;

        for (String uploadedCvDetail in _uploaded_cv_details) {
          if (detail.synonyms != null) {
            for (String synonym in detail.synonyms) {
              if (uploadedCvDetail.contains(synonym)) {
                colorDetail = Color.fromRGBO(255, 128, 0, 1);
                //colorDetail = Colors.grey;
                iconDetail = Icons.message;
                synonymDetail = synonym.toString()[0].toUpperCase() +
                    synonym.toString().substring(1);
                _containSynonym = true;
              }
            }
          }
        }

        if (!_containSynonym) {
          grade -= detail.grading;
        }

        detailUsage = detail.usageInPercentage.toString()[0].toUpperCase() +
            detail.usageInPercentage.toString().substring(1);
        detailName = detail.name[0].toUpperCase() + detail.name.substring(1);

        Widget detailCard = Card(
          child: ListTile(
            leading: Icon(
              iconDetail,
              size: 40,
              color: colorDetail,
            ),
            title: Text(detailName),
            subtitle: Text(_containSynonym
                ? '$detailUsage% van de studenten gebruikt het synoniem "$detailName" in plaats van "$synonymDetail"'
                : '$detailUsage% van de studenten zet hun "$detailName" in hun cv'),
            contentPadding: EdgeInsets.all(8),
          ),
        );

        if (_containSynonym) {
          _synonymContain.add(detailCard);
        } else {
          _dontContain.add(detailCard);
        }

        //widgets.add(SizedBox(
        //  height: 5,
        //));
      } else {
        iconDetail = Icons.check_box;
        colorDetail = Colors.green;
        _contain.add(
          Card(
            child: ListTile(
              leading: Icon(
                iconDetail,
                size: 40,
                color: colorDetail,
              ),
              title: Text(detailName),
              subtitle:
                  Text('Goed op weg! "$detailName" bevind zich in je cv.'),
              contentPadding: EdgeInsets.all(8),
            ),
          ),
        );
      }
    }

    if (grade >= 5.5) {
      gradecolor = Colors.green;
    } else {
      gradecolor = Colors.red;
    }

    for (Widget _dontcontain in _dontContain) {
      widgets.add(_dontcontain);
      widgets.add(SizedBox(
        height: 5,
      ));
    }

    for (Widget _dontcontain in _synonymContain) {
      widgets.add(_dontcontain);
      widgets.add(SizedBox(
        height: 5,
      ));
    }

    for (Widget _dontcontain in _contain) {
      widgets.add(_dontcontain);
      widgets.add(SizedBox(
        height: 5,
      ));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(21, 43, 83, 1),
        title: Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _image != null
                      ? Image(
                          image: FileImage(_image),
                          fit: BoxFit.fill,
                          width: 200,
                          height: 270,
                        )
                      : Container(),
                  _recognized
                      ? Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        'Met gebruik van de andere 400 geuploade stage-cvs geven we je jou een'),
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
                        )
                      : Container()
                ],
              ),
              Divider(
                thickness: 2,
                height: 30,
              ),
              if (_recognized)
                ...showFeedbackAndGrades()
              else
                Container(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                )
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
            backgroundColor: Colors.amber,
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

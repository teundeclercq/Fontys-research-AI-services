import 'package:CvPrototype/screens/Photo_screen.dart';
import 'package:CvPrototype/screens/result_screen.dart';
import 'package:CvPrototype/screens/tips_screen.dart';
import 'package:CvPrototype/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as oi;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => MyHomePage(),
        ResultScreen.routeName: (ctx) => ResultScreen(),
        PhotoScreen.routeName: (ctx) => PhotoScreen(),
        TipsScreen.routeName: (ctx) => TipsScreen()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _picker = ImagePicker();
  oi.File _image;

  void navigateToResults(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(ResultScreen.routeName, arguments: _image);
  }

  Future getImage(BuildContext ctx, bool isCamera) async {
    PickedFile pickedFile;
    if (isCamera) {
      pickedFile = await _picker.getImage(source: ImageSource.camera);
    } else {
      pickedFile = await _picker.getImage(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      _image = oi.File(pickedFile.path);
      navigateToResults(ctx);
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Background(),
                Positioned(
                  left: mediaQuery.size.width / 2 - 70,
                  bottom: mediaQuery.size.height / 2 + 30,
                  width: 145,
                  height: 150,
                  child: Image(
                    image: AssetImage("assets/images/home_uploadIcon.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                    width: mediaQuery.size.width,
                    bottom: mediaQuery.size.height / 2,
                    child: Text(
                      'Upload eerst je',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )),
                Positioned(
                  width: mediaQuery.size.width,
                  bottom: mediaQuery.size.height / 2 - 30,
                  child: Text(
                    'Curriculum Vitae',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  left: 35,
                  bottom: mediaQuery.size.height / 2 - 165,
                  child: RaisedButton(
                    onPressed: () => getImage(context, false),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xffff7700), Color(0xfff79c35)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_library,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Open Gallerij',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                Positioned(
                  left: 220,
                  bottom: mediaQuery.size.height / 2 - 165,
                  child: RaisedButton(
                    onPressed: () => getImage(context, true),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xffff7700), Color(0xfff79c35)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Maak Foto',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 70,
                    width: mediaQuery.size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo,
                          size: 40,
                          color: Color.fromRGBO(21, 43, 83, 1),
                        ),
                        Text(
                          'Upload je CV gelijk vanuit je gallerij!',
                          style:
                              TextStyle(color: Color.fromRGBO(21, 43, 83, 1)),
                        )
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

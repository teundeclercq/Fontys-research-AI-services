import 'package:CvPrototype/models/tip.dart';
import 'package:CvPrototype/providers/tips.dart';
import 'package:CvPrototype/screens/photo_screen.dart';
import 'package:CvPrototype/screens/result_screen.dart';
import 'package:CvPrototype/widgets/matchCard.dart';
import 'package:flutter/material.dart';
import 'dart:io' as oi;

class TipsScreen extends StatefulWidget {
  static const routeName = '/tips';
  TipsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TipsScreen> {
  List<Widget> _cardList;
  int _selectedPageIndex = 2;
  oi.File _image;
  var _loadedInitData = false;

  void _removeCard(index) {
    setState(() {
      _cardList.removeAt(index);
      if (_cardList.length == 0) {
        _cardList = _getMatchCard();
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (!_loadedInitData) {
      _image = ModalRoute.of(context).settings.arguments;
    }
    super.didChangeDependencies();
  }

  void _selectPage(int index) {
    if (_selectedPageIndex != 2) {
      setState(() {
        _selectedPageIndex = index;
      });
    }

    switch (index) {
      case 0:
        Navigator.of(context)
            .popAndPushNamed(ResultScreen.routeName, arguments: _image);
        break;

      case 1:
        Navigator.of(context)
            .popAndPushNamed(PhotoScreen.routeName, arguments: _image);
        break;
    }
  }

  @override
  void initState() {
    _cardList = _getMatchCard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(21, 43, 83, 1),
        title: Text('Tips'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: _cardList,
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

  List<Widget> _getMatchCard() {
    List<MatchCard> cards = new List();
    List<Tip> tips = new Tips().tips;
    Color fontColor = Color.fromRGBO(255, 255, 255, 1);
    Color backgroundColor = Color.fromRGBO(21, 43, 83, 1);
    bool isEven = false;
    int count = 0;

    for (Tip tip in tips) {
      count++;
      if (!isEven) {
        fontColor = Color.fromRGBO(255, 255, 255, 1);
        backgroundColor = Color.fromRGBO(21, 43, 83, 1);
      } else {
        fontColor = Color.fromRGBO(21, 43, 83, 1);
        backgroundColor = Color.fromRGBO(255, 255, 255, 1);
      }

      cards.add(MatchCard(
        backgroundColor,
        fontColor,
        tip.icon,
        count * 10,
        tip.text,
        count,
        _removeCard,
      ));
    }
    return cards;
  }
}

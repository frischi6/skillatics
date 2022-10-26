import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillatics/custom_icons_icons.dart';
import 'package:skillatics/menuPage.dart';

class RandomColorPage2 extends StatefulWidget {
  RandomColorPage2(
      {Key? key,
      required this.listSelectedColors,
      required this.listSelectedArrows,
      required this.listSelectedNumbers,
      required this.anzColorsOnPage,
      required this.secChangeColor,
      required this.secLengthRound,
      required this.secLengthRest,
      required this.anzRounds,
      required this.currentCountry})
      : super(key: key);

  var listSelectedColors;
  var listSelectedArrows;
  var listSelectedNumbers;
  int anzColorsOnPage;
  int secChangeColor;
  int secLengthRound;
  int secLengthRest;
  int anzRounds;
  String currentCountry;

  @override
  _RandomColorPage2 createState() => _RandomColorPage2();
}

class _RandomColorPage2 extends State<RandomColorPage2> {
  var start = DateTime.now().millisecondsSinceEpoch;
  var listWithSelectedColors = []; //gefüllt mit ColorsCheckbox-Elemente
  var listWithSelectedHex = []; //gefüllt mit Hex-Werten (int)
  var listHeight4Container = [];
  var listToFillContainersHex = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12
  ]; //nur Füllwerte

  var listWithSelectedArrows = [];
  var listWithSelectedNumbers = [];
  var listWithSelectedIcons =
      []; //beinhaltet listWithSelectedArrows + listWithSelectedNumbers
  var listToFillContainersIcon = [
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north)
  ];

  //var list4RandomHex = [0xffff0000, 0xffff0000, 0xffff0000, 0xffff0000];
  int anzColorsOnPage2 = 1;
  int secChangeColor2 = 1;
  int secLengthRound2 = 1;
  int secLengthRest2 = 1;
  int anzRounds2 = 1;

  late Timer _timer;
  int anzRoundsDone = 1;
  int secsLengthRoundCD = 1;
  int minsLengthRoundCD = 1;
  int secsLengthRestCD = 1;
  int minsLengthRestCD = 1;
  bool isRest = false;
  var colorRestText = 0xffffffff;
  var restText = '';
  var paddingTopRestText = 0.0;
  var fontsizeRestText = 0.0;

  String rundeSg = 'rundeSg'.tr;
  String rundePl = 'rundePl'.tr;

  int currentSecsCD = 0;
  int currentMinsCD = 0;

  double footerPercentage = 0.05;
  double bodyPercentage =
      0.95; //1-footerPercentage-> dieser Platz muss aufgeteilt werden um Farben anzuzeigen
  double thicknessVerticalDividerFooter = 0.5;

  void initState() {
    _initializeSettinvariables();
    _initializeListHeight4Containers();
    _initializeListWithAllHex();
    _initializeListSelectedArrows();
    organizeRound();
    _timer = Timer.periodic(
        Duration(seconds: 1),
        (Timer timer) => setState(() {
              timemanagement();
            }));

    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async =>
          false), //damit swipe back(ios) bzw. Back Button (android) deaktiviert
      child: Scaffold(
        backgroundColor: Color(0xff000000),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[
                      0]), //noch ersetzen mit 1/"wie viele farben aufs mal anzeigen"
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(this.listToFillContainersHex[0]),
                border: Border(bottom: BorderSide(color: Colors.black)),
              ),
              child: Stack(
                children: [
                  Center(child: listToFillContainersIcon[0]),
                  Center(
                    child: Text(
                      this.restText,
                      style: TextStyle(
                          color: Color(this.colorRestText),
                          fontSize: this.fontsizeRestText,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: listToFillContainersIcon[1],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[1]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.listToFillContainersHex[1]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              child: listToFillContainersIcon[2],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[2]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.listToFillContainersHex[2]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              child: listToFillContainersIcon[3],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[3]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.listToFillContainersHex[3]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              child: listToFillContainersIcon[4],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[4]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.listToFillContainersHex[4]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              child: listToFillContainersIcon[5],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[5]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.listToFillContainersHex[5]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              child: listToFillContainersIcon[6],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[6]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.listToFillContainersHex[6]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              child: listToFillContainersIcon[7],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[7]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.listToFillContainersHex[7]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              child: listToFillContainersIcon[8],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[8]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.listToFillContainersHex[8]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              child: listToFillContainersIcon[9],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[9]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.listToFillContainersHex[9]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              child: listToFillContainersIcon[10],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[10]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(this.listToFillContainersHex[10]),
                border: Border(bottom: BorderSide(color: Colors.black)),
              ),
            ),
            Container(
              child: listToFillContainersIcon[11],
              color: Color(this.listToFillContainersHex[11]),
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[11]),
              width: MediaQuery.of(context).size.width,
            ),

            //footer
            Container(
              height: MediaQuery.of(context).size.height * (footerPercentage),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey.shade700,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        this.anzRoundsDone.toString() +
                            '/' +
                            this.anzRounds2.toString() +
                            ' ' +
                            getRundeSgPl(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    width: (MediaQuery.of(context).size.width -
                            thicknessVerticalDividerFooter) /
                        4,
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        currentMinsCD.toString().padLeft(2, '0') +
                            ':' +
                            currentSecsCD.toString().padLeft(2, '0'),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    width: (MediaQuery.of(context).size.width -
                            thicknessVerticalDividerFooter) /
                        4,
                  ),
                  VerticalDivider(
                    color: Colors.black,
                    thickness: 0.5,
                    width: 0.5,
                  ),
                  Container(
                    child: TextButton(
                      child: Text(
                        'hauptmenü'.tr,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      autofocus: false,
                      onPressed: changeToPage1,
                      onLongPress: changeToPage1,
                    ),
                    width: (MediaQuery.of(context).size.width -
                            thicknessVerticalDividerFooter) /
                        4,
                  ),
                  Container(
                    child: TextButton(
                      child: Text(
                        'neustart'.tr,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      autofocus: false,
                      onPressed: neustart,
                      onLongPress: neustart,
                    ),
                    width: (MediaQuery.of(context).size.width -
                            thicknessVerticalDividerFooter) /
                        4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /**
   * Initialisiert die Settingvariablen in Page2 mit den korrekten Werten aus Page1, da diese nicht direkt als lokale Variable gebraucht werden können
  */
  void _initializeSettinvariables() {
    this.anzColorsOnPage2 = widget.anzColorsOnPage;
    this.secChangeColor2 = widget.secChangeColor;
    this.secLengthRound2 = widget.secLengthRound;
    this.secLengthRest2 = widget.secLengthRest;
    this.anzRounds2 = widget.anzRounds;

    this.minsLengthRoundCD = (this.secLengthRound2 / 60).toInt();
    this.secsLengthRoundCD = this.secLengthRound2 % 60;
    this.minsLengthRestCD = (this.secLengthRest2 / 60).toInt();
    this.secsLengthRestCD = this.secLengthRest2 % 60;
  }

  //füllt listWithSelectedColors ab aus widget.
  void _initializeListSelectedColors() {
    this.listWithSelectedColors = widget.listSelectedColors;
  }

  void _initializeListSelectedArrows() {
    this.listWithSelectedArrows = widget.listSelectedArrows;
    _initializeListSelectedNumbers();
    _initializeListSelectedIcons();
  }

  void _initializeListSelectedNumbers() {
    this.listWithSelectedNumbers = widget.listSelectedNumbers;
  }

  void _initializeListSelectedIcons() {
    this.listWithSelectedIcons =
        this.listWithSelectedArrows + this.listWithSelectedNumbers;
  }

  /**
   * füllt listWithSelectedHex mit Hexcodes aus listWithSelectedColors ab
   */
  void _initializeListWithAllHex() {
    this.listWithSelectedHex.clear();
    _initializeListSelectedColors();
    String hexxcode = '0xff';
    int theHexCode = 0;

    for (String item in listWithSelectedColors) {
      hexxcode = '0xff' + item;
      theHexCode = (int.parse(hexxcode));
      this.listWithSelectedHex.add(theHexCode);
    }
  }

  /**
   * initialisiert listHeight4Containers
   * beinhaltet den Wert, der für die Höhe jedes Containers gebraucht wird
   * Sollte in diesem Schema eingesetzt werden können height: MediaQuery.of(context).size.height*(listHeight4Containers[0])
   * 
   */
  void _initializeListHeight4Containers() {
    this.listHeight4Container.clear();
    for (int i = 0; i < 12; i++) {
      if (i < anzColorsOnPage2) {
        listHeight4Container.add(bodyPercentage / anzColorsOnPage2);
      } else {
        listHeight4Container.add(0);
      }
    }
  }

  /**
   * diese methode muss bei einem restart zusätzlich zu den anderen 3 _initialize..-Methoden aufgerufen werden
   * bringt alle variabeln, die sonst von anfang an schon korrekt initialisiert sind, wieder in ihren anfangszustand
   */
  void _initializeResetVariables() {
    this.anzRoundsDone = 1;
    this.isRest = false;
    this.currentSecsCD = 0;
    this.currentMinsCD = 0;
  }

/**
 * füllt listToFillContainersIcon mit korrektem icon und farbe inkl ob arrow sichtbar ist oder selbe farbe hat wie hintergrund
 */
  void addToListToFillContainersIcon(index, arrowDirection, arrowVisible) {
    var sizeIcon = 60.0;
    if (arrowVisible) {
      if (arrowDirection == 'north') {
        listToFillContainersIcon[index] =
            Icon(Icons.north, color: Colors.black, size: sizeIcon);
      } else if (arrowDirection == 'east') {
        listToFillContainersIcon[index] =
            Icon(Icons.east, color: Colors.black, size: sizeIcon);
      } else if (arrowDirection == 'south') {
        listToFillContainersIcon[index] =
            Icon(Icons.south, color: Colors.black, size: sizeIcon);
      } else if (arrowDirection == 'west') {
        listToFillContainersIcon[index] =
            Icon(Icons.west, color: Colors.black, size: sizeIcon);
      } else if (arrowDirection == 'northeast') {
        listToFillContainersIcon[index] =
            Icon(Icons.north_east, color: Colors.black, size: sizeIcon);
      } else if (arrowDirection == 'northwest') {
        listToFillContainersIcon[index] =
            Icon(Icons.north_west, color: Colors.black, size: sizeIcon);
      } else if (arrowDirection == 'southeast') {
        listToFillContainersIcon[index] =
            Icon(Icons.south_east, color: Colors.black, size: sizeIcon);
      } else if (arrowDirection == 'southwest') {
        listToFillContainersIcon[index] =
            Icon(Icons.south_west, color: Colors.black, size: sizeIcon - 10);
      } else if (arrowDirection == 'one') {
        listToFillContainersIcon[index] =
            Icon(CustomIcons.one, color: Colors.black, size: sizeIcon - 10);
      } else if (arrowDirection == 'two') {
        listToFillContainersIcon[index] =
            Icon(CustomIcons.two, color: Colors.black, size: sizeIcon - 10);
      } else if (arrowDirection == 'three') {
        listToFillContainersIcon[index] =
            Icon(CustomIcons.three, color: Colors.black, size: sizeIcon - 10);
      } else if (arrowDirection == 'four') {
        listToFillContainersIcon[index] =
            Icon(CustomIcons.four, color: Colors.black, size: sizeIcon - 10);
      } else if (arrowDirection == 'five') {
        listToFillContainersIcon[index] =
            Icon(CustomIcons.five, color: Colors.black, size: sizeIcon - 10);
      } else if (arrowDirection == 'six') {
        listToFillContainersIcon[index] =
            Icon(CustomIcons.six, color: Colors.black, size: sizeIcon - 10);
      } else if (arrowDirection == 'seven') {
        listToFillContainersIcon[index] =
            Icon(CustomIcons.seven, color: Colors.black, size: sizeIcon - 10);
      } else if (arrowDirection == 'eight') {
        listToFillContainersIcon[index] =
            Icon(CustomIcons.eight, color: Colors.black, size: sizeIcon - 10);
      } else if (arrowDirection == 'nine') {
        listToFillContainersIcon[index] =
            Icon(CustomIcons.nine, color: Colors.black, size: sizeIcon - 10);
      }
    } else {
      //arrow should not be visible
      listToFillContainersIcon[index] =
          Icon(Icons.north, color: Color(listToFillContainersHex[index]));
    }
  }

  /**
   * wird nur bei wechsel von rest zu round aufgerufen und ganz am Anfang bei Start page2 
   */
  void organizeRound() {
    _initializeListHeight4Containers(); //damit nach rest wieder alle Grössen der Container stimmen
    this.currentSecsCD = secsLengthRoundCD;
    this.currentMinsCD = minsLengthRoundCD;
    int randomInt;
    Random random = new Random();
    for (var i = 0; i < this.anzColorsOnPage2; i++) {
      randomInt = random.nextInt(listWithSelectedColors.length);
      //damit nicht gleiche Farben aufs Mal angezeigt werden
      if (i == 0 || listWithSelectedHex[randomInt] == 4294901502) {
        //4294901502 ist wert, als der 0xfffefefe geparst in listWithSelectedHex gespeichert ist
        listToFillContainersHex[i] = listWithSelectedHex[randomInt];
        this.colorRestText =
            listToFillContainersHex[i]; //damit Text nicht erkennbar
        this.restText = ''; //damit pfeil gute Position hat
        this.paddingTopRestText = 0.0; //damit pfeil gute Position hat
        this.fontsizeRestText = 0.0; //damit pfeil gute Position hat
      } else {
        while (
            listToFillContainersHex[i - 1] == listWithSelectedHex[randomInt]) {
          randomInt = random.nextInt(listWithSelectedColors.length);
        }
        listToFillContainersHex[i] = listWithSelectedHex[randomInt];
      }
    }
    //organize arrows
    for (int i = 0; i < listToFillContainersHex.length; i++) {
      if (listToFillContainersHex[i] != int.parse('0xfffefefe')) {
        //arrow not visible
        addToListToFillContainersIcon(i, null, false);
      } else {
        //arrow visible
        String arrowDirection =
            listWithSelectedIcons[random.nextInt(listWithSelectedIcons.length)];
        addToListToFillContainersIcon(i, arrowDirection, true);
      }
    }
  }

  /**
   * wird nur bei wechsel von round zu rest aufgerufen 
   */
  void organizeRest() {
    this.currentSecsCD = this.secsLengthRestCD;
    this.currentMinsCD = this.minsLengthRestCD;
    for (var i = 0; i < this.anzColorsOnPage2; i++) {
      //this.list4RandomHex[i] = 0xff000000;
      this.listToFillContainersHex[i] = 0xff000000;
      this.listHeight4Container[i] = 0; //damit Rest angezeigt werden kann
    }
    this.listHeight4Container[0] = bodyPercentage /
        1; //damit Rest angezeigt werden kann-> 1. container nimmt 100% ein
    this.colorRestText = 0xffffffff;
    this.restText = 'pause'.tr;
    this.paddingTopRestText = MediaQuery.of(context).size.height / 3;
    this.fontsizeRestText = 80.0;
    for (int i = 0; i < listToFillContainersHex.length; i++) {
      //damit alle pfeile schwarz und somit nicht sichtbar in pause
      listToFillContainersIcon[i] = Icon(Icons.north, color: Colors.black);
    }
  }

  /**
   * Methode, die jede Sekunde wegen _timer aufgerufen wird
   * managt farbwechsel, ende der Übung und Countdown
   */
  void timemanagement() {
    int randomInt;
    Random random = new Random();
    if (this.anzRoundsDone <= this.anzRounds2) {
      outerloop:
      if (isRest) {
        //management change
        if (this.secsLengthRestCD == 1 && this.minsLengthRestCD == 0) {
          isRest = false;
          this.anzRoundsDone++;
          if (this.anzRoundsDone <= this.anzRounds2) {
            //dass nicht organizeRound aufgerufen wird wenn eig fertig wäre
            organizeRound();
          } else {
            this.secsLengthRestCD--;
            this.currentSecsCD = this.secsLengthRestCD;
          }
          this.minsLengthRestCD = (this.secLengthRest2 / 60)
              .toInt(); //damit ready für nächsten durchgang
          this.secsLengthRestCD = this.secLengthRest2 % 60;
        } else {
          //management time
          if (this.secsLengthRestCD > 0) {
            this.secsLengthRestCD--;
          } else if (this.minsLengthRestCD > 0) {
            this.minsLengthRestCD--;
            this.secsLengthRestCD = 59;
            this.currentMinsCD = this.minsLengthRestCD;
          }
          this.currentSecsCD = this.secsLengthRestCD;
        }
      } else {
        //isRound
        //management change
        if (this.secsLengthRoundCD == 1 && this.minsLengthRoundCD == 0) {
          isRest = true;
          organizeRest();
          this.minsLengthRoundCD = (this.secLengthRound2 / 60)
              .toInt(); //damit ready für nächsten durchgang
          this.secsLengthRoundCD = this.secLengthRound2 % 60;
          break outerloop;
        } else {
          //management time
          if (this.secsLengthRoundCD > 0) {
            this.secsLengthRoundCD--;
          } else if (this.minsLengthRoundCD > 0) {
            this.minsLengthRoundCD--;
            this.secsLengthRoundCD = 59;
            this.currentMinsCD = minsLengthRoundCD;
          }
          this.currentSecsCD = this.secsLengthRoundCD;
        }
        //management color
        if ((this.secLengthRound2 -
                        (this.secsLengthRoundCD +
                            this.minsLengthRoundCD * 60)) %
                    this.secChangeColor2 ==
                0 &&
            (this.secsLengthRoundCD != 0 || this.minsLengthRoundCD != 0)) {
          //color wechseln
          for (var i = 0; i < this.anzColorsOnPage2; i++) {
            randomInt = random.nextInt(listWithSelectedColors.length);

            //damit nicht gleiche Farben aufs Mal angezeigt werden
            if (i == 0 || listWithSelectedHex[randomInt] == 4294901502) {
              listToFillContainersHex[i] = listWithSelectedHex[randomInt];
              colorRestText = listToFillContainersHex[i];
            } else {
              while (listToFillContainersHex[i - 1] ==
                  listWithSelectedHex[randomInt]) {
                randomInt = random.nextInt(listWithSelectedColors.length);
              }
              listToFillContainersHex[i] = listWithSelectedHex[randomInt];
            }
          }

          //organize arrows
          for (int i = 0; i < listToFillContainersHex.length; i++) {
            if (listToFillContainersHex[i] != int.parse('0xfffefefe')) {
              //arrow not visible
              addToListToFillContainersIcon(i, null, false);
            } else {
              //arrow visible
              String arrowDirection = listWithSelectedIcons[
                  random.nextInt(listWithSelectedIcons.length)];
              addToListToFillContainersIcon(i, arrowDirection, true);
            }
          }
        }
      }
    } else {
      this._timer.cancel();
      showDialog(
          context: context,
          builder: (_) => alertDialogFinish(),
          barrierDismissible: false);
      //Navigator.push(context, MaterialPageRoute(builder: (context) => alertDialog()));
    }
  }

  /**
   * AlertDialog das bei Ende von Übung erscheint
   */
  Widget alertDialogFinish() {
    this.anzRoundsDone--;
    return AlertDialog(
      //ähnlich wie modalWindow
      content: Text('trainingEnde'.tr),
      actions: [
        TextButton(
            onPressed: changeToPage1,
            child: Text(
              'hauptmenü'.tr,
              style: TextStyle(color: Color.fromARGB(177, 0, 0, 0)),
            )),
        TextButton(
            onPressed: changeToPage2,
            child: Text(
              'neustart'.tr,
              style: TextStyle(color: Color.fromARGB(177, 0, 0, 0)),
            )),
      ],
    );
  }

  /**
   * Damit Anzeige in Fusszeile korrekt mit 1 Runde bzw >1 Runden
   */
  String getRundeSgPl() {
    if (this.anzRounds2 == 1) {
      return this.rundeSg;
    } else {
      return this.rundePl;
    }
  }

  /**
   * Methode, die alle Variablen etc wieder in den anfangszustand bringt, damit page2 nochmals von null aus abgespielt werden kann
   * timer wird absichtlich nicht verändert da nicht nötig
   */
  void neustart() {
    _initializeSettinvariables();
    _initializeListHeight4Containers();
    _initializeListWithAllHex();
    _initializeListSelectedArrows();
    _initializeResetVariables();
    organizeRound();
  }

  /**
   * Wechsel von page2 to page1
   */
  void changeToPage1() {
    this._timer.cancel();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  title: 'Skillatics',
                  currentCountry: widget.currentCountry,
                )));
  }

  /**
   * neustart der page2
   * wird nach alertDialogFinish aufgerufen weil neustart() nicht funktioniert
   */
  void changeToPage2() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RandomColorPage2(
                  listSelectedColors: this.listWithSelectedColors,
                  listSelectedArrows: this.listWithSelectedArrows,
                  listSelectedNumbers: this.listWithSelectedNumbers,
                  anzColorsOnPage: this.anzColorsOnPage2,
                  secChangeColor: this.secChangeColor2,
                  secLengthRound: this.secLengthRound2,
                  secLengthRest: this.secLengthRest2,
                  anzRounds: this.anzRounds2,
                  currentCountry: widget.currentCountry,
                )));
  }
}

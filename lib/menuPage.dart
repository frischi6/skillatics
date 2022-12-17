import 'dart:async'; //damit Timer gebraucht werden kann
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:skillatics/custom_icons_icons.dart';
import 'package:skillatics/skillatics_icon_icons.dart';
import 'package:skillatics/trainingPage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    required this.title,
    required this.currentCountry,
  }) : super(key: key);

  final String title;
  String currentCountry;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String hexxcode = '0xff';
  int theHexCode = 0;
  String textFehlermeldung = '';
  bool isGerman = true;
  String currentCountry = "GB"; //flagge die aktuell oben rechts angezeigt wird
  String keyString = '1';
  int keyInt = 1;

//Variabeln für Einstellungen, siehe Skizze, werden an Page2 übergeben
  int anzColorsOnPage = 2;
  int secChangeColor = 5;
  int secLengthRound = 210; //=roundDisplayedSec+roundDisplayedMin in sekunden
  int secLengthRest = 90; //=restDisplayedSec+restDisplayedMin in sekunden
  int anzRounds = 5;

//Werte, die in applescroll angezeigt werden aber nicht so an Page2 übergeben werden können weil Min und Sec gemischt
  int roundDisplayedSec = 30;
  int roundDisplayedMin = 3;
  int restDisplayedSec = 30;
  int restDisplayedMin = 1;

//Checkboxen, mit allen gewünschten Farben
  var selectedColors = [];
  var selectedArrows = [];
  var selectedNumbers = [];
  var selectedItems = []; //total

//Pop-Up in dem User nach Bewertung/Rezession schreiben gefragt wird
  final RateMyApp rateMyApp = RateMyApp(
    minDays: 5,
    minLaunches: 5,
    remindDays: 9,
    remindLaunches: 4,
    //googlePlayIdentifier: https://www.youtube.com/watch?v=aoq5VDku2Bc
    //appStoreIdentifier: diese hat man noch nicht wenn noch nicht in store
  );

/**
 * erzeugt Emoji mit Flagge mit entsprechendem Wert currentCountry
 */
  String countryFlag() {
    //https://stackoverflow.com/questions/56999448/display-country-flag-character-in-flutter
    int flagOffset = 0x1F1E6;
    int asciiOffset = 0x41;

    int firstChar = currentCountry.codeUnitAt(0) - asciiOffset + flagOffset;
    int secondChar = currentCountry.codeUnitAt(1) - asciiOffset + flagOffset;

    String emoji =
        String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
    return emoji;
  }

  void changeKey() {
    this.keyInt++;
    this.keyString = keyInt.toString();
  }

  //Wechsel auf Seite 2 mit den angezeigten Farben
  void _changeToPage2() {
    organizeArrowsColors();

    //überprüft, ob Werte gültig sind
    if (this.selectedItems.length == 0 && this.selectedArrows.length == 0) {
      setState(() {
        this.textFehlermeldung = 'fehlerColorsNull'.tr;
      });
    } else if (this.selectedItems.length == 1 && this.anzColorsOnPage > 1) {
      setState(() {
        this.textFehlermeldung = 'fehlerColorsAnz'.tr;
      });
    } else if (this.secLengthRound <= 0) {
      setState(() {
        this.textFehlermeldung = 'fehlerDurchgangNull'.tr;
      });
    } else if (this.secChangeColor > this.secLengthRound) {
      setState(() {
        this.textFehlermeldung = 'fehlerWechselDurchlauf'.tr;
      });
    } else if (this.secLengthRest <= 0) {
      setState(() {
        this.textFehlermeldung = 'fehlerPauseNull'.tr;
      });
    } else {
      //Wechsel möglich
      showDialog(
        context: context,
        builder: (_) => alertDialogCD(),
      );

      Timer(Duration(seconds: 3), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RandomColorPage2(
              listSelectedColors: this.selectedItems,
              listSelectedArrows: this.selectedArrows,
              listSelectedNumbers: this.selectedNumbers,
              anzColorsOnPage: this.anzColorsOnPage,
              secChangeColor: this.secChangeColor,
              secLengthRound: this.secLengthRound,
              secLengthRest: this.secLengthRest,
              anzRounds: this.anzRounds,
              currentCountry: this.currentCountry,
            ),
          ),
        );
      });
    }
  }

  /**
   * Initializes selectedArrows[] and sets correct color for arrows in selectedcolors that there are only hex and no strings like 'north' etc
   */
  void organizeArrowsColors() {
    this.selectedItems = selectedColors + selectedNumbers + selectedArrows;
    for (int i = 0; i < selectedItems.length; i++) {
      if (selectedItems[i].length != 6) {
        //selectedArrows.add(selectedItems[i]);
        selectedItems[i] =
            'fefefe'; //weisser hintergrund aber nicht ffffff damit später erkennbar dass dort arrows angezeigt werden müssen
      } //else ist bereits ein hexcode in selectedColors und kein arrow
    }
  }

  /**
   * Returnt einen AlertDialog, damit der User Zeit hat auf Position zu gehen
   */
  Widget alertDialogCD() {
    return AlertDialog(
      content: Center(
        heightFactor: 1.2,
        child: Text('bereit'.tr),
      ),
    );
  }

  void _showSkillaticsInfos() {
    showDialog(
      context: context,
      builder: (_) => skillaticsDialog(),
    );
  }

  Widget skillaticsDialog() {
    return AlertDialog(
      content: Container(
        child: Center(
          child: Column(
            children: [
              Text(''),
              Text('Skillatics Neuroathletik'),
              Text(''),
              Text('+41 79 663 48 52'),
              Text('info@skillatics.ch'),
              Text('www.skillatics.ch'),
            ],
          ),
        ),
        height: 120,
      ),
    );
  }

/**
 * returnt ein MultiSelectContainer, in dem alle Farben ausgewählt werden können
 */
  MultiSelectContainer buildColorselect() {
    return MultiSelectContainer(
      key: Key(this
          .keyString), //https://jelenaaa.medium.com/how-to-force-widget-to-redraw-in-flutter-2eec703bc024
      //UniqueKey(), //damit Unterschied in Widget entdeckt wird und somit Widget rebuild wird
      prefix: MultiSelectPrefix(
          selectedPrefix: const Padding(
        padding: EdgeInsets.only(right: 5),
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 14,
        ),
      )),
      items: [
        MultiSelectCard(
          value: 'f5ff00',
          label: 'Gelb'.tr,
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.yellow.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(10))),
        ),
        MultiSelectCard(
          value: 'ff5f1f',
          label: 'Orange'.tr,
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10))),
        ),
        MultiSelectCard(
          value: 'ff0000',
          label: 'Rot'.tr,
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(10))),
        ),
        MultiSelectCard(
          value: 'f500ab',
          label: 'Pink'.tr,
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.pink, borderRadius: BorderRadius.circular(10))),
        ),
        MultiSelectCard(
          value: '6600a1',
          label: 'Violett'.tr,
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 102, 0, 161).withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 102, 0, 161),
                  borderRadius: BorderRadius.circular(10))),
        ),
        MultiSelectCard(
          value: '00b2ee',
          label: 'Hellblau'.tr,
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(10))),
        ),
        MultiSelectCard(
          value: '00008b',
          label: 'Dunkelblau'.tr,
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 00, 0, 139).withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 00, 0, 139),
                  borderRadius: BorderRadius.circular(10))),
        ),
        MultiSelectCard(
          value: '00ee00',
          label: 'Hellgrün'.tr,
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.lightGreen.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(10))),
        ),
        MultiSelectCard(
          value: '006400',
          label: 'Dunkelgrün'.tr,
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 100, 0).withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 100, 0),
                  borderRadius: BorderRadius.circular(10))),
        ),
        MultiSelectCard(
          value: '00868b',
          label: 'Türkis'.tr,
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 134, 139).withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 134, 139),
                  borderRadius: BorderRadius.circular(10))),
        ),
        MultiSelectCard(
          value: 'a8a8a8',
          label: 'Grau'.tr,
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 168, 168, 168).withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 168, 168, 168),
                  borderRadius: BorderRadius.circular(10))),
        ),
        MultiSelectCard(
          value: '000000',
          label: 'Schwarz'.tr,
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10))),
          textStyles: MultiSelectItemTextStyles(
            selectedTextStyle: TextStyle(color: Colors.white),
          ),
        ),
        MultiSelectCard(
          value: 'bd9b16',
          label: 'Gold'.tr,
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 189, 155, 22).withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 189, 155, 22),
                  borderRadius: BorderRadius.circular(10))),
        ),
        MultiSelectCard(
          value: 'ffffff',
          label: 'Weiss'.tr,
          textStyles: const MultiSelectItemTextStyles(
              selectedTextStyle: TextStyle(color: Colors.black)),
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 203, 203, 203).withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all())),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
      ],
      onChange: (allSelectedItems, selectedItem) {
        this.selectedColors = allSelectedItems;
      },
    );
  }

  /**
 * returnt ein MultiSelectContainer, in dem alle Pfeile ausgewählt werden können
 */
  MultiSelectContainer buildArrowselect() {
    return MultiSelectContainer(
      key: Key(this
          .keyString), //https://jelenaaa.medium.com/how-to-force-widget-to-redraw-in-flutter-2eec703bc024
      //UniqueKey(), //damit Unterschied in Widget entdeckt wird und somit Widget rebuild wird
      prefix: MultiSelectPrefix(
          selectedPrefix: const Padding(
        padding: EdgeInsets.only(right: 5),
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 14,
        ),
      )),
      items: [
        MultiSelectCard(
          value: 'north',
          child: Icon(Icons.north),
          textStyles: const MultiSelectItemTextStyles(
              selectedTextStyle: TextStyle(color: Colors.black)),
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all())),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
        MultiSelectCard(
          value: 'east',
          child: Icon(Icons.east),
          textStyles: const MultiSelectItemTextStyles(
              selectedTextStyle: TextStyle(color: Colors.black)),
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all())),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
        MultiSelectCard(
          value: 'south',
          child: Icon(Icons.south),
          textStyles: const MultiSelectItemTextStyles(
              selectedTextStyle: TextStyle(color: Colors.black)),
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all())),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
        MultiSelectCard(
          value: 'west',
          child: Icon(Icons.west),
          textStyles: const MultiSelectItemTextStyles(
              selectedTextStyle: TextStyle(color: Colors.black)),
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all())),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
        MultiSelectCard(
          value: 'northwest',
          child: Icon(Icons.north_west),
          textStyles: const MultiSelectItemTextStyles(
              selectedTextStyle: TextStyle(color: Colors.black)),
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all())),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
        MultiSelectCard(
          value: 'northeast',
          child: Icon(Icons.north_east),
          textStyles: const MultiSelectItemTextStyles(
              selectedTextStyle: TextStyle(color: Colors.black)),
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all())),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
        MultiSelectCard(
          value: 'southeast',
          child: Icon(Icons.south_east),
          textStyles: const MultiSelectItemTextStyles(
              selectedTextStyle: TextStyle(color: Colors.black)),
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all())),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
        MultiSelectCard(
          value: 'southwest',
          child: Icon(Icons.south_west),
          textStyles: const MultiSelectItemTextStyles(
              selectedTextStyle: TextStyle(color: Colors.black)),
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all())),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
      ],
      onChange: (allSelectedItems, selectedItem) {
        this.selectedArrows = allSelectedItems;
      },
    );
  }

  /**
 * returnt ein MultiSelectContainer, in dem alle Nummern ausgewählt werden können
 */
  MultiSelectContainer buildNumberselect() {
    return MultiSelectContainer(
      key: Key(this
          .keyString), //https://jelenaaa.medium.com/how-to-force-widget-to-redraw-in-flutter-2eec703bc024
      //UniqueKey(), //damit Unterschied in Widget entdeckt wird und somit Widget rebuild wird
      prefix: MultiSelectPrefix(
          selectedPrefix: const Padding(
        padding: EdgeInsets.only(right: 5),
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 14,
        ),
      )),
      items: [
        MultiSelectCard(
          value: 'one',
          label: '1',
          textStyles: const MultiSelectItemTextStyles(
              textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              selectedTextStyle:
                  TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all())),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
        MultiSelectCard(
          value: 'two',
          label: '2',
          textStyles: const MultiSelectItemTextStyles(
              textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              selectedTextStyle:
                  TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all())),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
        MultiSelectCard(
          value: 'three',
          label: '3',
          textStyles: const MultiSelectItemTextStyles(
              textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              selectedTextStyle:
                  TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all())),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
        MultiSelectCard(
          value: 'four',
          label: '4',
          textStyles: const MultiSelectItemTextStyles(
              textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              selectedTextStyle:
                  TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all())),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
        MultiSelectCard(
          value: 'five',
          label: '5',
          textStyles: const MultiSelectItemTextStyles(
              textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              selectedTextStyle:
                  TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all())),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
        MultiSelectCard(
          value: 'six',
          label: '6',
          textStyles: const MultiSelectItemTextStyles(
              textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              selectedTextStyle:
                  TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all())),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
        MultiSelectCard(
          value: 'seven',
          label: '7',
          textStyles: const MultiSelectItemTextStyles(
              textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              selectedTextStyle:
                  TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all())),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
        MultiSelectCard(
          value: 'eight',
          label: '8',
          textStyles: const MultiSelectItemTextStyles(
              textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              selectedTextStyle:
                  TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all())),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
        MultiSelectCard(
          value: 'nine',
          label: '9',
          textStyles: const MultiSelectItemTextStyles(
              textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              selectedTextStyle:
                  TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          decorations: MultiSelectItemDecorations(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all())),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
      ],
      onChange: (allSelectedItems, selectedItem) {
        this.selectedNumbers = allSelectedItems;
      },
    );
  }

  void initState() {
    this.currentCountry = widget.currentCountry;
    super.initState();
  }

  // This method is rerun every time setState is called
  @override
  Widget build(BuildContext context) {
    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(
          context,
          title: 'bewertenTitel'.tr,
          message: 'bewertenText'.tr,
          rateButton: 'bewertenJetzt'.tr,
          noButton: 'bewertenNein'.tr,
          laterButton: 'bewertenSpaeter'.tr,
          onDismissed: () =>
              rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (isGerman) {
                  Get.updateLocale(Locale('en', 'US'));
                  isGerman = false;
                  this.currentCountry = "DE";
                } else {
                  //is English
                  Get.updateLocale(Locale('de', 'DE'));
                  isGerman = true;
                  this.currentCountry = "GB";
                }
                changeKey();
              },
              child: Text(
                countryFlag(),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
          centerTitle: true,
          automaticallyImplyLeading: false //damit kein zurück-Pfeil oben links
          ),
      body: SingleChildScrollView(
        child: //damit scrollable wenn content grösser ist als bildschirmgrösses
            Padding(
          padding: EdgeInsets.only(left: 5, right: 5, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //Checkbox - Mit welchen Farben trainieren
              //SizedBox(height: 20,),
              Text(
                'selItems'.tr,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 18),
              Text(
                'farben'.tr,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(),
                child: buildColorselect(),
              ),
              SizedBox(height: 15),
              Text(
                'pfeile'.tr,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(),
                child: buildArrowselect(),
              ),
              SizedBox(height: 15),
              Text(
                'zahlen'.tr,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(),
                child: buildNumberselect(),
              ),
              SizedBox(height: 15),
              Divider(
                color: Colors.black,
                height: 15,
                indent: 30,
                endIndent: 30,
              ),
              //Dropdown - wie viele Farben aufs Mal angezeigt werden
              SizedBox(height: 12),
              Text(
                'selAnzFarben'.tr,
                style: TextStyle(fontSize: 15),
              ),
              NumberPicker(
                value: anzColorsOnPage,
                minValue: 1,
                maxValue: 12,
                step: 1,
                itemHeight: 20,
                selectedTextStyle: TextStyle(fontSize: 22),
                textStyle: TextStyle(fontSize: 13),
                onChanged: (value) => setState(() => anzColorsOnPage = value),
              ),
              SizedBox(height: 12),

              Divider(
                color: Colors.black,
                height: 15,
                indent: 30,
                endIndent: 30,
              ),

//Applescroll - Farbwechsel nach wie vielen Sekunden
              SizedBox(height: 12),
              Text(
                'selWechselSek'.tr,
                style: TextStyle(fontSize: 15),
              ),
              NumberPicker(
                value: secChangeColor,
                minValue: 1,
                maxValue: 59,
                step: 1,
                itemHeight: 20,
                selectedTextStyle: TextStyle(fontSize: 22),
                textStyle: TextStyle(fontSize: 13),
                onChanged: (value) => setState(() => secChangeColor = value),
              ),
              SizedBox(height: 12),

              Divider(
                color: Colors.black,
                height: 15,
                indent: 30,
                endIndent: 30,
              ),

//Applescroll - Dauer eines Durchlaufs
              SizedBox(height: 12),
              Text(
                'selDurchlauf'.tr,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 18,
              ), //Für Abstand
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      NumberPicker(
                        value: roundDisplayedMin,
                        minValue: 0,
                        maxValue: 59,
                        step: 1,
                        itemHeight: 20,
                        selectedTextStyle: TextStyle(fontSize: 22),
                        textStyle: TextStyle(fontSize: 13),
                        onChanged: (value) => setState(
                          () {
                            roundDisplayedMin = value;
                            secLengthRound =
                                roundDisplayedSec + roundDisplayedMin * 60;
                          },
                        ),
                      ),
                    ],
                  ),
                  Text('min'.tr),
                  Column(
                    children: [
                      NumberPicker(
                        value: roundDisplayedSec,
                        minValue: 0,
                        maxValue: 59,
                        step: 1,
                        itemHeight: 20,
                        selectedTextStyle: TextStyle(fontSize: 22),
                        textStyle: TextStyle(fontSize: 13),
                        onChanged: (value) => setState(
                          () {
                            roundDisplayedSec = value;
                            secLengthRound =
                                roundDisplayedSec + roundDisplayedMin * 60;
                          },
                        ),
                      ),
                    ],
                  ),
                  Text('sek'.tr),
                ],
              ),
              SizedBox(height: 12),

              Divider(
                color: Colors.black,
                height: 15,
                indent: 30,
                endIndent: 30,
              ),

//Applescroll - Dauer einer Pause
              SizedBox(height: 12),
              Text(
                'selPause'.tr,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 18,
              ), //Für Abstand
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      NumberPicker(
                        value: restDisplayedMin,
                        minValue: 0,
                        maxValue: 59,
                        step: 1,
                        itemHeight: 20,
                        selectedTextStyle: TextStyle(fontSize: 22),
                        textStyle: TextStyle(fontSize: 13),
                        onChanged: (value) => setState(
                          () {
                            restDisplayedMin = value;
                            secLengthRest = restDisplayedSec +
                                restDisplayedMin *
                                    60; //als Methode weil 2x vorkommt?
                          },
                        ),
                      ),
                    ],
                  ),
                  Text('min'.tr),
                  Column(
                    children: [
                      NumberPicker(
                        value: restDisplayedSec,
                        minValue: 0,
                        maxValue: 59,
                        step: 1,
                        itemHeight: 20,
                        selectedTextStyle: TextStyle(fontSize: 22),
                        textStyle: TextStyle(fontSize: 13),
                        onChanged: (value) => setState(
                          () {
                            restDisplayedSec = value;
                            secLengthRest = restDisplayedSec +
                                restDisplayedMin *
                                    60; //als Methode weil 2x vorkommt?
                          },
                        ),
                      ),
                    ],
                  ),
                  Text('sek'.tr),
                ],
              ),
              SizedBox(height: 12),

              Divider(
                color: Colors.black,
                height: 15,
                indent: 30,
                endIndent: 30,
              ),

//Dropdown - Anzahl Durchgänge
              SizedBox(height: 12),
              Text(
                'selAnzDurchg'.tr,
                style: TextStyle(fontSize: 15),
              ),
              NumberPicker(
                value: anzRounds,
                minValue: 1,
                maxValue: 99,
                step: 1,
                itemHeight: 20,
                selectedTextStyle: TextStyle(fontSize: 22),
                textStyle: TextStyle(fontSize: 13),
                onChanged: (value) => setState(() => anzRounds = value),
              ),
              SizedBox(height: 12),

              Divider(
                color: Colors.black,
                height: 15,
                indent: 30,
                endIndent: 30,
              ),

              SizedBox(height: 10),
              Text(
                this.textFehlermeldung + '\n',
                key: Key(keyString), //funktioniert nicht
                style: TextStyle(color: Colors.red),
              ),
              TextButton(
                child: Text(
                  'start'.tr,
                ),
                style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey.shade700)),
                autofocus: true,
                onPressed: _changeToPage2,
                onLongPress: _changeToPage2,
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 47,
                child: TextButton(
                  onPressed: _showSkillaticsInfos,
                  child: Image.asset(('assets/skillatics_schwarzWeiss.png')),
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

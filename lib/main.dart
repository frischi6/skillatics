import 'dart:io'; //um zu checken ob es ios oder android ist

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillatics/TranslationText.dart';
import 'package:skillatics/constant.dart';
import 'package:skillatics/menuPage.dart';
import 'store_config.dart';

void main() {
  print('in main');
  if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(
      store: Store.appleStore,
      apiKey: appleApiKey,
    );
  } else if (Platform.isAndroid) {
    // Run the app passing --dart-define=AMAZON=true
    const useAmazon = bool.fromEnvironment("amazon");
    StoreConfig(
      store: useAmazon ? Store.amazonAppstore : Store.googlePlay,
      apiKey: useAmazon ? amazonApiKey : googleApiKey,
    );
  }
  runApp(MyApp());
}

//damit primaryswatch in materialapp themedata customized color haben kann
Map<int, Color> color = {
  50: Color.fromRGBO(188, 250, 0, .1),
  100: Color.fromRGBO(188, 250, 0, .2),
  200: Color.fromRGBO(188, 250, 0, .3),
  300: Color.fromRGBO(188, 250, 0, .4),
  400: Color.fromRGBO(188, 250, 0, .5),
  500: Color.fromRGBO(188, 250, 0, .6),
  600: Color.fromRGBO(188, 250, 0, .7),
  700: Color.fromRGBO(188, 250, 0, .8),
  800: Color.fromRGBO(188, 250, 0, .9),
  900: Color.fromRGBO(188, 250, 0, 1),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MaterialColor colorCustom = MaterialColor(0xffbcfa00, color);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Skillatics',
      theme: ThemeData(
        primarySwatch: colorCustom,
        //unselectedWidgetColor: Colors.black, //noch nötig?
      ),
      home: MyHomePage(
        title: 'Skillatics',
        currentCountry: "GB", //aktuelle Flagge die oben rechts erscheint
      ),
      translations: TranslationText(),
      locale: Locale('de', 'DE'),
    );
  }
}

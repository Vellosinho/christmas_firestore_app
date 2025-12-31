import 'package:christmas_firestore_app/consts/color_palette.dart';
import 'package:christmas_firestore_app/consts/text_consts.dart';
import 'package:christmas_firestore_app/games/beer_game/game_base/game_base.dart';
import 'package:christmas_firestore_app/games/beer_game/game_client/game_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:universal_html/universal_html.dart' as html;

import 'package:pretty_qr_code/pretty_qr_code.dart';

class BeerGameDesktop extends StatefulWidget {
  const BeerGameDesktop({super.key});

  @override
  State<BeerGameDesktop> createState() => _BeerGameDesktopState();
}

class _BeerGameDesktopState extends State<BeerGameDesktop> {
  String url = '';
  bool showQrCode = false;

  @override
  Widget build(BuildContext context) {
    String userAgent = "";
    userAgent = html.window.navigator.userAgent.toLowerCase();
    if (userAgent.contains("windows")) {
      userAgent = "windows";
    } else {
      userAgent = "phone";
    }

    return Scaffold(
      body: (userAgent == "windows") ? GameBase() : PhonePage()
      // body: (userAgent == "windows") ? PhonePage() : GameBase() 
    );
  }
}


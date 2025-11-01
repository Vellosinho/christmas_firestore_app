import 'package:cloudflare_test/consts/color_palette.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;

import 'package:pretty_qr_code/pretty_qr_code.dart';

class BeerGameDesktop extends StatelessWidget {
  const BeerGameDesktop({super.key});

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
      body: (userAgent == "windows") ? Stack(
        children: [
          Image.asset("assets/beer_game/cloth_background.png", width: MediaQuery.of(context).size.width, fit: BoxFit.cover,),
          Positioned(bottom: -48, right: 0,child: ScanQRCode())
        ],
      ) : PhonePage()
    );
  }
}

class PhonePage extends StatelessWidget {
  const PhonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      TextField()
    ],);
  }
}

class ScanQRCode extends StatelessWidget {

  const ScanQRCode({super.key});

  @override
  Widget build(BuildContext context) {

    final QrCode qrCode = QrCode.fromData(
      data: 'https://reg-van-drop-strength.trycloudflare.com',
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );
    
    QrImage qrImage = QrImage(qrCode);

    late PrettyQrDecoration decoration = const PrettyQrDecoration(
      shape: PrettyQrSmoothSymbol(
        color: ColorPalette.billCoverColor,
      ),
      background: Colors.transparent,
      quietZone: PrettyQrQuietZone.zero,
    );

    return Transform.rotate(
      angle: -0.2,
      child: SizedBox(height: 704,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 64),
              height: 640,
              width: 880,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.black, blurRadius: 4),
                ],
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: ColorPalette.billCoverColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 496),
              child: SizedBox(
                width: 328,
                height: 392,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: ColorPalette.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 64),
                      Text(
                        "E so escanear para comecar a jogar",
                        style: GoogleFonts.poorStory(
                          fontSize: 40,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 96),
                        child: PrettyQrView(
                          qrImage: qrImage,
                          decoration: decoration,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
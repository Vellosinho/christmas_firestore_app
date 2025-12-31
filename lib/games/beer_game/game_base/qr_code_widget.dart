import 'package:christmas_firestore_app/consts/color_palette.dart';
import 'package:christmas_firestore_app/consts/text_consts.dart';
import 'package:christmas_firestore_app/messageing/messaging_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ScanQRCode extends StatelessWidget {
  final String url;

  const ScanQRCode({super.key, required this.url});

  @override
  Widget build(BuildContext context) {

    final QrCode qrCode = QrCode.fromData(
      data: url,
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
                height: 508,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: ColorPalette.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height:64),
                      Text(
                        "E so escanear para comecar a jogar",
                        style: TextStyles.commonText,
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
                      SizedBox(height: 32),
                      Text(
                        "Ou acessar o link:",
                        style: TextStyles.commonText,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        url,
                        style: TextStyles.commonUrlText,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 100,
              child: SizedBox(
                height: 200,
                width: 330,
                child: SizedBox(
                    child: Transform.rotate(
                      angle: 0.25,
                      child: FirebaseAnimatedList(
                        query: MessagingRepository().databaseAdminReferenceQuery,
                        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                          Map user = snapshot.value as Map;
                          String userName = user['userName'] ?? '';
                                        
                          return (userName.toLowerCase() == 'nem') ? Stack(
                            children: [
                              SizedBox(
                                height: 200,
                                width: 330,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: PlayerColors.nemColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 100,
                                child: SizedBox(
                                  height: 36,
                                  width: 330,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: ColorPalette.creditCardGray,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ) : SizedBox();}
                      ),
                    ),
                  ),
                ),
            ),
        ])
      ),
    ); 
  }
}
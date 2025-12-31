import 'package:christmas_firestore_app/consts/color_palette.dart';
import 'package:christmas_firestore_app/consts/text_consts.dart';
import 'package:christmas_firestore_app/games/beer_game/game_base/game_base_controller.dart';
import 'package:christmas_firestore_app/games/beer_game/game_base/qr_code_widget.dart';
import 'package:christmas_firestore_app/games/beer_game/game_base/round_info/round_info.dart';
import 'package:christmas_firestore_app/messageing/messaging_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameBase extends StatefulWidget {
  const GameBase({super.key});

  @override
  State<GameBase> createState() => _GameBaseState();
}

class _GameBaseState extends State<GameBase> {

  @override
  void initState() {
    MessagingRepository().cleanGame();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
            
    FirebaseDatabase.instance.ref().child('events').onValue.listen((onData) {
      Map map = onData.snapshot.children.last.value as Map;
      if (map['event'] == "Jump_to_page") {
        GameBaseController controller = context.read<GameBaseController>();
        controller.addRound();
        controller.setAfterTimerFunction(
          () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RoundPage(roundNumber: 1)));
          }
        );
        controller.startTimerToNextRound();
      }
    });
    
    return Consumer<GameBaseController>(
      builder: (BuildContext context, controller, _) {
      return Stack(
          children: [
            Image.asset("assets/beer_game/cloth_background.png", width: MediaQuery.of(context).size.width, fit: BoxFit.cover,),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: !controller.showQrCode ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withAlpha(155),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      onChanged: (value) => controller.setUrl(value),
                    ),
                  ),
                  TextButton(
                    child: Text('Teste'),
                    onPressed: () {
                      controller.setQrCode(true);
                    }
                  )
                ]
              ) : null),
              controller.showQrCode ? controller.timerVisible ?
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width / 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white
                    ),
                    child: Center(
                      child: SizedBox(child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Proxima rodada em:', style: TextStyles.bigText),
                            SizedBox(height: 64),
                            Text(controller.timerToNextRound.toString(), style: TextStyles.giantTimerTextDesktop),
                          ],
                        )
                      )
                    ),
                  )
                )
              ) :  Column(
                children: [
                  Flexible(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: FirebaseAnimatedList(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        query: MessagingRepository().databasePlayerReferenceQuery,
                        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                          Map user = snapshot.value as Map;
                      
                          return (index < 5) ? UnconstrainedBox(
                            child: SizedBox(
                              height: 320,
                              width: 320, 
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: PlayerColors.playerColorList[index],
                                  borderRadius: const BorderRadius.all(Radius.circular(160))
                                ),
                                child: Center(child: Text(user['userName'], style: TextStyles.playerNameText))
                              )
                            ),
                            
                          ) : SizedBox();
                        }
                      ),
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: FirebaseAnimatedList(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        query: MessagingRepository().databasePlayerReferenceQuery,
                        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                          Map user = snapshot.value as Map;
                      
                          return ((index >= 5) && (index < 8)) ? UnconstrainedBox(
                            child: SizedBox(
                              height: 320,
                              width: 320, 
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: PlayerColors.playerColorList[index],
                                  borderRadius: const BorderRadius.all(Radius.circular(160))
                                ),
                                child: Center(child: Text(user['userName'], style: TextStyles.playerNameText))
                              )
                            ),
                            
                          ) : SizedBox();
                        }
                      ),
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: FirebaseAnimatedList(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        query: MessagingRepository().databasePlayerReferenceQuery,
                        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                          Map user = snapshot.value as Map;
                      
                          return ((index >= 8) && (index < 10)) ? UnconstrainedBox(
                            child: Padding(
                              padding: EdgeInsets.only(top: (index == 8) ? 6: 0),
                              child: SizedBox(
                                height: 320,
                                width: 320, 
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: PlayerColors.playerColorList[index],
                                    borderRadius: const BorderRadius.all(Radius.circular(160))
                                  ),
                                  child: Center(child: Text(user['userName'], style: TextStyles.playerNameText))
                                )
                              ),
                            ),
                            
                          ) : SizedBox();
                        }
                      ),
                    ),
                  ),
                ],
              ) : SizedBox(),
              Positioned(bottom: -48, right: 0, child: (controller.showQrCode && !controller.timerVisible) ? ScanQRCode(url: controller.url) : SizedBox()),
          ],
        );
      }
    );
  }
}

class PlayerIcon extends StatelessWidget {
  final int index;
  final String player;
  const PlayerIcon({super.key, required this.index, required this.player});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameBaseController>(
      builder: (context, controller, _) => SizedBox(
        height: 320,
        width: 320, 
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: (player != '') ? PlayerColors.playerColorList[index] : Colors.transparent,
            // color: Colors.red,
            borderRadius: const BorderRadius.all(Radius.circular(160))
          ),
          child: Center(child: Text(player, style: TextStyles.playerNameText))
        )
      ),
    );
  }
}
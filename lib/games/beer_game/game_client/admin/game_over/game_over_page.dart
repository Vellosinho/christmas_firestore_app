import 'package:christmas_firestore_app/consts/color_palette.dart';
import 'package:christmas_firestore_app/consts/text_consts.dart';
import 'package:christmas_firestore_app/games/beer_game/game_client/admin/select_answer/select_answer_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameOverPage extends StatefulWidget {
  final String playerName;
  GameOverPage({super.key, required this.playerName});

  @override
  State<GameOverPage> createState() => _GameOverPageState();
}

class _GameOverPageState extends State<GameOverPage> {
  late  SharedPreferences prefs;


  bool get isNem => widget.playerName.toLowerCase() == 'nem';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Consumer<SelectAnswerController>(
        builder: (context, controller, _) => Stack(
          children: [
            Container(
              color:  isNem ? PlayerColors.nemColor : PlayerColors.playerTwoLightColor,
              child: Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: SizedBox(
                          height: 64,
                          width: 64,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                              color: Colors.white.withAlpha(125),
                            ),
                            child: Center(child: Text(widget.playerName[0].toUpperCase(), style: TextStyles.commonText,))
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 48),
                  Center(child: Text('Fim de jogo', style: TextStyles.phoneCommonText,)),
                ]
              ),
            ),
            Center(child: controller.timerVisible ? Text(controller.timerToNextRound.toString(), style: TextStyles.giantTimerText,) : SizedBox())
          ],
        ),
      ),
    );
  }
}
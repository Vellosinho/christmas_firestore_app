import 'package:christmas_firestore_app/consts/text_consts.dart';
import 'package:christmas_firestore_app/games/beer_game/game_base/game_base_controller.dart';
import 'package:christmas_firestore_app/models/round_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameOverBasePage extends StatelessWidget {
  const GameOverBasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameBaseController>(
      builder: (BuildContext context, controller, _) {
      return Scaffold(
        body: Stack(
            children: [
              Image.asset("assets/beer_game/cloth_background.png", width: MediaQuery.of(context).size.width, fit: BoxFit.cover,),
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width / 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white
                    ),
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Resultado:', style: TextStyles.bigText),
                            SizedBox(height: 64),
                            Text('Campeao: ${controller.finalResults.first.playerName} - ${controller.finalResults.first.points}', style: TextStyles.bigText),
                            GridView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              ),
                              itemCount: controller.finalResults.length - 1,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 32
                                  ),
                                  child: Text('${controller.finalResults[index + 1].playerName} - ${controller.finalResults[index + 1].points}', style: TextStyles.playerNameTextBlack,));
                              },
                            ),
                          ],
                      )
                    ),
                  )
                ),
              ),
            ],
          ),
      );
      }
    );
  }
}
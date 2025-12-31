import 'package:christmas_firestore_app/consts/text_consts.dart';
import 'package:christmas_firestore_app/games/beer_game/game_base/game_base_controller.dart';
import 'package:christmas_firestore_app/games/beer_game/game_base/game_over/game_base_game_over.dart';
import 'package:christmas_firestore_app/models/round_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoundPage extends StatelessWidget {
  final int roundNumber;
  const RoundPage({super.key, required this.roundNumber});

  @override
  Widget build(BuildContext context) {
            
    FirebaseDatabase.instance.ref().child('events').onValue.listen((onData) {
      Map map = onData.snapshot.children.last.value as Map;
      if ((map['event'] == "Jump_to_page") && (map['roundnum'] > roundNumber)) {
        GameBaseController controller = context.read<GameBaseController>();
        controller.addRound();
        controller.setAfterTimerFunction(
          () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RoundPage(roundNumber: map['roundnum'])));
          }
        );
        controller.startTimerToNextRound();
      } else if (map['event'] == "finish_game") {
          
          GameBaseController controller = context.read<GameBaseController>();

          controller.setAfterTimerFunction(
            () {
              controller.generateGameResults();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GameOverBasePage()));
            }
          );
          controller.startTimerToNextRound();
      }
    });

    FirebaseDatabase.instance.ref().child('rounds').child('round_$roundNumber').onValue.listen((onData) {
      Map map = onData.snapshot.children.last.value as Map;
      if (map['userName'].toLowerCase() == 'nem'){
        context.read<GameBaseController>().setRoundAnswer(map['answer']);
      }
        context.read<GameBaseController>().addRoundVote(Vote(player: map['userName'], vote: map['answer']));
    });
    
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
                      child: SizedBox(child: controller.timerVisible ?  
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Proxima rodada em:', style: TextStyles.bigText),
                            SizedBox(height: 64),
                            Text(controller.timerToNextRound.toString(), style: TextStyles.giantTimerTextDesktop),
                          ],
                        ):
                        Text('Rodada $roundNumber', style: TextStyles.roundNumber,)
                      )
                    ),
                  )
                )
              ),
              // Center(child: controller.timerVisible ? Text(controller.timerToNextRound.toString(), style: TextStyles.giantTimerText,) : SizedBox())
            ],
          ),
      );
      }
    );
  }
}
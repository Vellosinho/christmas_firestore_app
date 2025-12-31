import 'package:christmas_firestore_app/consts/color_palette.dart';
import 'package:christmas_firestore_app/consts/text_consts.dart';
import 'package:christmas_firestore_app/games/beer_game/game_client/admin/game_over/game_over_page.dart';
import 'package:christmas_firestore_app/games/beer_game/game_client/admin/select_answer/select_answer_controller.dart';
import 'package:christmas_firestore_app/messageing/messaging_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoundPageSelectAnswer extends StatefulWidget {
  final int roundNumber;
  final String playerName;
  RoundPageSelectAnswer({super.key, required this.roundNumber, required this.playerName});

  @override
  State<RoundPageSelectAnswer> createState() => _RoundPageSelectAnswerState();
}

class _RoundPageSelectAnswerState extends State<RoundPageSelectAnswer> {
  late  SharedPreferences prefs;


  bool get isNem => widget.playerName.toLowerCase() == 'nem';

  @override
  Widget build(BuildContext context) {

    FirebaseDatabase.instance.ref().child('events').onValue.listen((onData) {
      Map map = onData.snapshot.children.last.value as Map;
      if ((map['event'] == "Jump_to_page") && (map['roundnum'] > widget.roundNumber)) {
        SelectAnswerController controller = context.read<SelectAnswerController>();

        controller.setAfterTimerFunction(
          () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RoundPageSelectAnswer(roundNumber: map['roundnum'], playerName: widget.playerName,)));
          }
        );
        controller.startTimerToNextRound();
      } else if (map['event'] == "finish_game") {
          
          SelectAnswerController controller = context.read<SelectAnswerController>();

          controller.setAfterTimerFunction(
            () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GameOverPage(playerName: widget.playerName,)));
            }
          );
          controller.startTimerToNextRound();
      }
    });

    return Scaffold(
      body: Consumer<SelectAnswerController>(
        builder: (context, controller, _) => Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              color:  isNem ? PlayerColors.nemColor : PlayerColors.playerTwoLightColor,
              child: SingleChildScrollView(
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
                        SizedBox(
                          child: isNem ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorPalette.buttonBackgroundColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))
                                ),
                                child: Text('Encerrar Jogo', style: TextStyles.phoneButtonText),
                                onPressed: () {
                                  MessagingRepository().addEvent("finish_game", widget.roundNumber + 1);
                                }
                              ),
                            ),
                          ) : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ((controller.lastRoundVoted < widget.roundNumber) || isNem) && (controller.selectedAnswer != "") ? ColorPalette.buttonBackgroundColor : ColorPalette.creditCardGray,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))
                              ),
                              child: Text(((controller.lastRoundVoted == widget.roundNumber) && isNem) ? 'Proxima rodada' :'Enviar Resposta', style: TextStyles.phoneButtonText),
                              onPressed: () {
                                if ((controller.selectedAnswer != "")) {
                                  if ((controller.lastRoundVoted < widget.roundNumber) && (controller.selectedAnswer != "")) {
                                      MessagingRepository().setAnswer(widget.playerName, controller.selectedAnswer, widget.roundNumber);
                                      controller.setAnsweredToRound(widget.roundNumber);
                                  } else {
                                    if (isNem) {
                                      MessagingRepository().addEvent("Jump_to_page", widget.roundNumber + 1);
                                    }
                                  }
                                }
                              }
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 20),
                    Column(
                      children: [
                        Text((controller.lastRoundVoted == widget.roundNumber) ? 'Resposta Enviada' : 'Insira a resposta certa', style: TextStyles.phoneCommonText,),
                        SizedBox(height: 24),
                      ],
                    ),
                    SizedBox(
                      child: (controller.lastRoundVoted == widget.roundNumber) ? SizedBox() :FirebaseAnimatedList(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        query: MessagingRepository().databaseOptionsReferenceQuery,
                        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                          Map value = snapshot.value as Map;
                      
                          return SizedBox(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            // child: Text(value['option'], textAlign: TextAlign.center, style: TextStyles.phoneCommonText,),
                            child: SelectionButton(value: value['option'], selectAnswerController: controller,)
                          );
                        }
                      ),
                    ),
                  ]
                ),
              ),
            ),
            Center(child: controller.timerVisible ? Text(controller.timerToNextRound.toString(), style: TextStyles.giantTimerText,) : SizedBox())
          ],
        ),
      ),
    );
  }
}

class SelectionButton extends StatelessWidget {
  final String value;
  final SelectAnswerController selectAnswerController;
  const SelectionButton({super.key, required this.value, required this.selectAnswerController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 72, vertical: 8),
      child: GestureDetector(
        onTap: () {
          selectAnswerController.setSelectedAnswer(value);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: 72,
          decoration: BoxDecoration(
              // border: OutlineInputBorder(
          color: selectAnswerController.selectedAnswer == value ? Color(0xffFFF15B).withAlpha(155) :Colors.white.withAlpha(155),
          
              borderRadius: BorderRadius.all(Radius.circular(40)),
              //   borderSide: BorderSide(color: Colors.black),
              //   borderRadius: BorderRadius.all(Radius.circular(40)),
              // ),
          ),
              child: Center(child: Text(value, textAlign: TextAlign.center, style: TextStyles.phoneCommonText,))
        ),
      ),
    );
  }
}

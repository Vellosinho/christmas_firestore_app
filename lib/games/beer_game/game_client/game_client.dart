import 'package:christmas_firestore_app/consts/color_palette.dart';
import 'package:christmas_firestore_app/consts/text_consts.dart';
import 'package:christmas_firestore_app/games/beer_game/game_client/admin/add_options/admin_add_options.dart';
import 'package:christmas_firestore_app/games/beer_game/game_client/admin/select_answer/select_answer.dart';
import 'package:christmas_firestore_app/games/beer_game/game_client/admin/select_answer/select_answer_controller.dart';
import 'package:christmas_firestore_app/messageing/messaging_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  static final GlobalKey<FormFieldState<String>> _addPlayerKey = GlobalKey<FormFieldState<String>>();

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {

  Color playerInitialColor = PlayerColors.noPlayerBaseColor;
  Color playerColor = PlayerColors.noPlayerBaseColor;
  TextEditingController textController = TextEditingController();
  FocusNode clientFocus = FocusNode();

  @override
  void initState() {
    getSessionLocally();
    super.initState();
  } 

  void getSessionLocally() async {
    SelectAnswerController controller = context.read<SelectAnswerController>();
    await controller.getSessionLocally();
    textController.text = controller.playerName;
    updateBackgroundColor(controller);
  }

  void updateBackgroundColor(SelectAnswerController controller) {
    if (controller.playerName != '') {
      if(controller.isNem) {
        controller.setBackgroundColor(PlayerColors.nemColor);
      } else {
        controller.setBackgroundColor(PlayerColors.playerTwoLightColor);
    }} else {
      controller.setBackgroundColor(PlayerColors.noPlayerBaseColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    SelectAnswerController selectAnswerController = context.read<SelectAnswerController>();
    
    FirebaseDatabase.instance.ref().child('events').onValue.listen((onData) {
      Map map = onData.snapshot.children.last.value as Map;
      if ((map['event'] == "Jump_to_page") && (selectAnswerController.playerReady)) {
        SelectAnswerController controller = context.read<SelectAnswerController>();

        controller.setAfterTimerFunction(
          () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RoundPageSelectAnswer(roundNumber: map['roundnum'], playerName: controller.playerName,)));
          }
        );
        controller.startTimerToNextRound();
      }
    });

    return Consumer<SelectAnswerController>(
      builder: (context, controller, _) => AnimatedContainer(
        color: controller.screenBackgroundColor,
        duration: Duration(milliseconds: 500),
        child: Stack(
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
                        child: Center(child: Text(controller.playerName != '' ? controller.playerName[0].toUpperCase() : '?', style: TextStyles.commonText,))
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !controller.playerReady ? ColorPalette.buttonBackgroundColor : ColorPalette.creditCardGray,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))
                        ),
                        child: Text('Entrar no jogo', style: TextStyles.phoneButtonText),
                        onPressed: () async {
                          if (!controller.playerReady) { 
                            controller.setPlayerReady(true);
                            await controller.saveSessionLocally();
                            MessagingRepository().addUser(controller.playerName, []);
                            if(controller.isNem) {
                              FocusScope.of(context).unfocus();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => AdminAddOptionsPage()));
                            } else {
                              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RoundPageSelectAnswer(roundNumber: 1, playerName: name,)));
                            }
                          }
                          // MessagingRepository().cleanGame();
                        }
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 10),
                  Column(
                    children: [
                      Text('Insira o seu nome', style: TextStyles.phoneCommonText,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                        child: TextField(
                          enabled: !controller.playerReady,
                          key: PhonePage._addPlayerKey,
                          controller: textController,
                          textAlign: TextAlign.center,
                          style: TextStyles.phoneCommonText,
                          cursorHeight: 32,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            filled: true,
                            fillColor: Colors.white.withAlpha(155),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                            ),
                          ),
                          onChanged: (value) => !controller.playerReady ? setState(() {
                            controller.setPlayerName(value);
                            updateBackgroundColor(controller);
                          }) : () {},  
                        ),
                      ),
                    ],
                  ),
                  Column(children: [
              
                  ],)
                ]
              ),
            Center(child: controller.timerVisible ? Text(controller.timerToNextRound.toString(), style: TextStyles.giantTimerText,) : SizedBox())
          ],
        ),
      ),
    );
  }
}


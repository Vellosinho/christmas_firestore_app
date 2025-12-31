import 'package:christmas_firestore_app/consts/color_palette.dart';
import 'package:christmas_firestore_app/consts/text_consts.dart';
import 'package:christmas_firestore_app/games/beer_game/game_client/admin/select_answer/select_answer.dart';
import 'package:christmas_firestore_app/games/beer_game/game_client/admin/select_answer/select_answer_controller.dart';
import 'package:christmas_firestore_app/messageing/messaging_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminAddOptionsPage extends StatefulWidget {
  const AdminAddOptionsPage({super.key});

  @override
  State<AdminAddOptionsPage> createState() => _AdminAddOptionsPageState();
}

class _AdminAddOptionsPageState extends State<AdminAddOptionsPage> {
  
  late  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController adminAddOptionsController = TextEditingController();
    FocusNode adminAddOptions = FocusNode();
    
    FirebaseDatabase.instance.ref().child('events').onValue.listen((onData) {
      Map map = onData.snapshot.children.last.value as Map;
      if ((map['event'] == "Jump_to_page") && (map['roundnum'] == (1))) {
        SelectAnswerController controller = context.read<SelectAnswerController>();

        controller.setAfterTimerFunction(
          () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RoundPageSelectAnswer(roundNumber: 1, playerName: "Nem",)));
          }
        );
        controller.startTimerToNextRound();
      }
    });


    return Scaffold(
      body: Consumer<SelectAnswerController>(
        builder: (context, controller, _) => Container(
          height: MediaQuery.of(context).size.height,
          color: PlayerColors.nemColor,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          child: Center(child: Text('N', style: TextStyles.commonText,))
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalette.buttonBackgroundColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))
                          ),
                          child: Text('Comecar Jogo', style: TextStyles.phoneButtonText),
                          onPressed: () {
                              MessagingRepository().addEvent('Jump_to_page', 1);
                          }
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalette.buttonBackgroundColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))
                          ),
                          child: Text('Adicionar Opcao', style: TextStyles.phoneButtonText),
                          onPressed: () {
                            MessagingRepository().adminAddOptions(adminAddOptionsController.text);
                            adminAddOptionsController.text = '';
                          }
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 20),
                    Column(
                      children: [
                        Text('Insira as cervejas', style: TextStyles.phoneCommonText,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(adminAddOptions);
                            },
                            child: OptionsNameField(textController: adminAddOptionsController)
                          ),
                        ),
                      ],
                    ),
                    FirebaseAnimatedList(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      query: MessagingRepository().databaseOptionsReferenceQuery,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                        Map value = snapshot.value as Map;
                    
                        return SizedBox(
                          height: 64,
                          width: MediaQuery.of(context).size.width,
                          child: Text(value['option'], textAlign: TextAlign.center, style: TextStyles.phoneCommonText,),
                        );
                      }
                    ),
                  ]
                ),
              ),
              Center(child: controller.timerVisible ? Text(controller.timerToNextRound.toString(), style: TextStyles.giantTimerText,): null)
            ],
          ),
        ),
      ),
    );
  }
}

class OptionsNameField extends StatefulWidget {
  final TextEditingController textController;
  const OptionsNameField({super.key, required this.textController});

  @override
  State<OptionsNameField> createState() => _OptionsNameFieldState();
}

class _OptionsNameFieldState extends State<OptionsNameField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      // key: AdminAddOptionsPage._addOptionKey,
      controller: widget.textController,
      textAlign: TextAlign.center,
      style: TextStyles.phoneCommonText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 4),
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
    );
  }
}


import 'package:engine_control/CodeControl.dart';
import 'package:engine_control/ConfigPage.dart';
import 'package:engine_control/dataBase/DataBaseHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sms/sms.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = "Engine Control";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        home: EngineControl(),
        debugShowCheckedModeBanner: false);
  }
}

class EngineControl extends StatefulWidget {
  @override
  _EngineControlState createState() => _EngineControlState();
}

enum Options_Menu {Modifier, Aide}

class _EngineControlState extends State<EngineControl> {
  String appBarTitle = "Engine control";
  String messageUpdate = "Vous recevez ici les sms entrants de votre appareil ...\nIl vous faut des sms pour manipuler cette application !";
  //Database instance
  final DataBaseHelper dataBaseHelper = DataBaseHelper.dataBaseHelperInstance;
  final CodeControl codeControl = CodeControl();

  @override
  void initState() {
    // TODO: implement initState
    getInComingSMS();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<Options_Menu>(
                onSelected: (Options_Menu result) {
                  onOptionMenuItemClick(result);
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<Options_Menu>>[
                      const PopupMenuItem<Options_Menu>(
                        child: Text("Modifier"),
                        value: Options_Menu.Modifier,
                      ),
                      const PopupMenuItem(
                          child: Text("Aide"), value: Options_Menu.Aide)
                    ])
          ],
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                    reverse: true,
                    child: Container(
                        child: SelectableText(
                          messageUpdate,
                          toolbarOptions: ToolbarOptions(copy: true),
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)
                        ),
                        padding: EdgeInsets.only(left: 2.0))),
                Container(
                  padding: EdgeInsets.all(5.0),
                  margin: EdgeInsets.only(top: 50),
                  child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RaisedButton(
                                  onPressed: () {
                                    launchSendSms(codeControl.tracker);
                                  },
                                  color: Colors.blueGrey,
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.location_on_outlined, color: Colors.green,),
                                      Text("Traquer", style: TextStyle(fontSize: 20, color: Colors.white))
                                    ],
                                  )
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: RaisedButton(
                                      onPressed: () {launchSendSms(codeControl.stopoil);},
                                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                      color: Colors.blueGrey,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.stop_circle_outlined, color: Colors.red),
                                          Text("Arrêter", style: TextStyle(fontSize: 20, color: Colors.white))
                                        ],
                                      )
                                  ))
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RaisedButton(
                                    onPressed: () {
                                      launchSendSms(codeControl.check);
                                    },
                                    color: Colors.blueGrey,
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.verified_user_outlined, color: Colors.tealAccent,),
                                        Text("L'état", style: TextStyle(fontSize: 20, color: Colors.white))
                                      ],
                                    )),
                                Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: RaisedButton(
                                        onPressed: () {launchSendSms(codeControl.smslink);},
                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                        color: Colors.blueGrey,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.link, color: Colors.blue,),
                                            Text("Lien", style: TextStyle(fontSize: 20, color: Colors.white))
                                          ]
                                        )
                                    ))
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RaisedButton(
                                    onPressed: () {
                                      launchSendSms(codeControl.begin);
                                    },
                                    color: Colors.blueGrey,
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.autorenew_outlined, color: Colors.teal),
                                        Text("Initialiser", style: TextStyle(fontSize: 20, color: Colors.white))
                                      ],
                                    )),
                                Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: RaisedButton(
                                        onPressed: () {launchSendSms(codeControl.reboot);},
                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                        color: Colors.blueGrey,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.flip_camera_android_outlined, color: Colors.teal),
                                            Text("Redémarrer", style: TextStyle(fontSize: 20, color: Colors.white))
                                          ],
                                        )
                                    )
                                )
                              ],
                            ),
                          )
                        ]
                      )
                  ),
                )
              ],
            ),
          )
        ));
  }

  Future<void> _showHelpDialog() async {
    String helpText =
        "Le bouton 'Traquer': affiche les informations de la position.\n'Arrêter': stop l'appareil.\n'L'etat' de l'appareil.\n'Lien Google': Lien Google Maps.\n'Initialiser: Initialise les paramètres.\n'Redémarrer: Redémarre l'apareil.";
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Application de contrôle d'appareil !"),
              content: Text(helpText),
              actions: [
                TextButton(
                    onPressed: Navigator.of(context).pop, child: Text("Fermer"))
              ]);
        });
  }

  Future<void> onOptionMenuItemClick(Options_Menu item) async {
    if (item == Options_Menu.Aide) {
      return _showHelpDialog();
    } else if (item == Options_Menu.Modifier) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ConfigPage()));
    }
  }

  void launchSendSms(String _codeControl){
    final allData = dataBaseHelper.getData();
    allData.then((value){
      value.forEach((element){
        sendSmsToEngine(element[DataBaseHelper.columnNumSim], element[DataBaseHelper.columnPin], _codeControl);
      });
    });
  }
  //Method Send SMS to Engine
  Future<void> sendSmsToEngine(String phone, String pin, String _codeControl) async {
    SmsSender sender = new SmsSender();
    SmsMessage message = new SmsMessage(phone, _codeControl+pin+codeControl.hastag);
    message.onStateChanged.listen((state) {
      if(state == SmsMessageState.Sent){
        flutterToast("Envoyé !");
      }
      if(state == SmsMessageState.Fail){
        flutterToast("Non envoyé ...");
      }
    });
    sender.sendSms(message);
  }

  //Get Incoming sms
  Future<void> getInComingSMS() async {
    SmsReceiver receiver = new SmsReceiver();
    receiver.onSmsReceived.listen((SmsMessage sms) {
      String address = sms.address;
      String body = sms.body;
      final allData = dataBaseHelper.getData();
      allData.then((value){
        value.forEach((element){
          if(element[DataBaseHelper.columnNumSim] == address)
          {
            textUpdate(body);
          }
        });
      });

    });
  }

  //SMS text update
  void textUpdate(String newMessage) {
    setState(() {
      messageUpdate = newMessage;
    });
  }

  //A Custom Toast method
  void flutterToast(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

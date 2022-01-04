import 'package:engine_control/CodeControl.dart';
import 'package:engine_control/dataBase/DataBaseHelper.dart';
import 'package:engine_control/dataBase/ParamAdmin.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sms/sms.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  String title = "Configuration";
  String explainConfigText = "Page de configuration de l'application, vous pouvez changer le numéro de téléphone de l'appareil et le code pin d'envoi, ou ajouter/supprimer un numéro admin.";

  final telController = TextEditingController();
  final pinController = TextEditingController();

  bool securePin = true;

  //Database instance
  final DataBaseHelper dataBaseHelper = DataBaseHelper.dataBaseHelperInstance;
  final CodeControl codeControl = CodeControl();

  @override
  void dispose() {
    // TODO: implement dispose
    telController.dispose();
    pinController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [IconButton(icon: Icon(Icons.check_rounded), onPressed: () => {verifyUserInput()})]
      ),
      body: Container(
        margin: EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(explainConfigText, textAlign: TextAlign.left, style: TextStyle(fontSize: 20)),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                 TextField(
                   decoration: InputDecoration(
                     hintText: "Tel ...",
                     labelText: "Numéro de téléphone",
                     labelStyle: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                     prefixIcon: Icon(Icons.phone)
                   ),
                   keyboardType: TextInputType.phone,
                   controller: telController,

                 ),
                  TextField(
                    controller: pinController,
                    decoration: InputDecoration(
                      hintText: "Pin ...",
                      labelText: "Code pin",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(icon: Icon(securePin ? Icons.remove_red_eye_rounded : Icons.security_rounded), onPressed: (){
                        setState(() {
                          securePin = !securePin;
                        });
                      },)
                    ),
                    obscureText: securePin,
                    keyboardType: TextInputType.number
                  )
                ]
              )
            )
          ]
        ),
      )
    );
  }

  //verify user input data
  void verifyUserInput(){
    String phone = telController.text;
    String pin = pinController.text;

    ParamAdmin paramAdmin = ParamAdmin(1, phone, pin);

    if(phone == '' || pin == ''){
      flutterToast("Le numéro et le code pin sont obligatoires.");
    }else if(pin.length < 6){flutterToast("Le code pin doit être au moins de 6 chiffres.");}else{
      final allData = dataBaseHelper.getData();
      allData.then((value){
        value.forEach((element){
          sendSmsToEngine(phone, element[DataBaseHelper.columnPin], pin, paramAdmin);
        });
      });
      Navigator.pop(context);
    }
  }

  Future<void> sendSmsToEngine(String phone, String oldPin, String newPin, ParamAdmin paramAdmin) async {
    SmsSender sender = new SmsSender();
    SmsMessage message = new SmsMessage(phone, codeControl.password+oldPin+codeControl.hastag+newPin+codeControl.hastag);
    message.onStateChanged.listen((state) {
      if(state == SmsMessageState.Sent){
        flutterToast("Updating...!");
        dataBaseHelper.updateDB(paramAdmin);
      }
      if(state == SmsMessageState.Fail){
        flutterToast("Not updated !");
      }
    });
    sender.sendSms(message);
  }

  //A Custom Toast method
  void flutterToast(String message) {
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

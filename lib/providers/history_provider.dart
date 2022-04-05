import 'package:family_tree/Model/history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryProvider extends ChangeNotifier {
  Set<History> _histories = {};
  Set<History> get history => _histories;

  void addHistory(History history) async {
    await History.addHistory(history);
    notifyListeners();

  }

  InputDecoration inputDecoration({String? pIcon}) {
    return InputDecoration(
      labelStyle: const TextStyle(color: Colors.yellowAccent),
      hintStyle: const TextStyle(color: Colors.grey),
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontWeight: FontWeight.bold,
      ),
      prefixIcon: (pIcon) != null ? Icon(Icons.date_range_rounded) : null,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2,
          )),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.blueAccent,
          )),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.redAccent,
          )),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 2,
        ),
      ),
    );
  }

  readHistories() async {
    return History.readHistory();
  }

  alert({required String title,required String body, required BuildContext context}){
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('${title}'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('${body}'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  if(title == 'Successfully Deleted'){
                    Navigator.pop(context);
                  }else{
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  }
                },
              ),
            ],
          );
        }
    );
  }
}

import 'package:family_tree/Model/member.dart';
import 'package:family_tree/components/history//add_history_form.dart';
import 'package:flutter/material.dart';
import 'package:giff_dialog/giff_dialog.dart';

class AddHistoryScreen extends StatelessWidget {
  final List<Member> allMembers;

  AddHistoryScreen({Key? key, required this.allMembers}) : super(key: key);

  final FocusNode _topicFocusNode = FocusNode();
  final FocusNode _historyDateFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        _topicFocusNode.unfocus(),
        _historyDateFocusNode.unfocus(),
        _descriptionFocusNode.unfocus(),
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
          title: const Text(
            'Add History',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => AssetGiffDialog(
                          onlyOkButton: true,
                          onOkButtonPressed: () {
                            Navigator.pop(context);
                          },
                          buttonOkText: const Text("Got it!",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          buttonOkColor: Colors.blueAccent,
                          image: Image.asset(
                            'assets/generation/genZ.gif',
                            fit: BoxFit.fill,
                          ),
                          title: const Text(
                            "Adding A Family History",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          description: const Text(
                            "History image, Title, Date, Family Members and a Description of the history can be added for a history record.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ));
              },
              icon: const Padding(
                padding: EdgeInsets.only(right: double.infinity),
                child: Icon(
                  Icons.help,
                  size: 30.0,
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: AddHistoryForm(
                  topicFocusNode: _topicFocusNode,
                  historyDateFocusNode: _historyDateFocusNode,
                  allMembers: allMembers,
                  descriptionFocusNode: _descriptionFocusNode,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

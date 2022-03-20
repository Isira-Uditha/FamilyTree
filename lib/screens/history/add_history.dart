import 'package:family_tree/Model/member.dart';
import 'package:family_tree/components/history//add_history_form.dart';
import 'package:flutter/material.dart';

class AddHistoryScreen extends StatelessWidget {
  final List<Member> allMembers;

  AddHistoryScreen({Key? key, required this.allMembers}) : super(key: key);

  final FocusNode _topicFocusNode = FocusNode();
  final FocusNode _historyDateFocusNode = FocusNode();
  final FocusNode _historyImageFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        _topicFocusNode.unfocus(),
        _historyDateFocusNode.unfocus(),
        _historyImageFocusNode.unfocus(),
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
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: AddHistoryForm(
                  topicFocusNode: _topicFocusNode,
                  historyDateFocusNode: _historyDateFocusNode,
                  historyImageFocusNode: _historyImageFocusNode,
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

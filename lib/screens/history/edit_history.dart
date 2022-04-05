import 'package:family_tree/Model/history.dart';
import 'package:family_tree/Model/member.dart';
import 'package:family_tree/components/history/edit_history_form.dart';
import 'package:flutter/material.dart';

class EditHistoryScreen extends StatefulWidget {
  final String currenthistoryID;
  final String currenttopic;
  final String currenthistoryDate;
  final List<Member> currentMembers;
  final String currentDescription;
  final List<Member> allMembers;
  final String currentImage;

  const EditHistoryScreen(
      {Key? key,
        required this.currenthistoryID,
        required this.currenttopic,
        required this.currenthistoryDate,
        required this.currentMembers,
        required this.currentDescription,
        required this.allMembers,
        required this.currentImage})
      : super(key: key);

  @override
  _EditHistoryScreenState createState() => _EditHistoryScreenState();
}

class _EditHistoryScreenState extends State<EditHistoryScreen> {
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
            'Edit History',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: EditHistoryForm(
                  topicFocusNode: _topicFocusNode,
                  historyDateFocusNode: _historyDateFocusNode,
                  descriptionFocusNode: _descriptionFocusNode,
                  history: History(
                      historyID: widget.currenthistoryID,
                      topic: widget.currenttopic,
                      historyDate: widget.currenthistoryDate,
                      image: widget.currentImage,
                      members: widget.currentMembers,
                      description: widget.currentDescription),
                      allMembers: widget.allMembers))
            ],
          ),
        ),
      ),
    );
  }
}

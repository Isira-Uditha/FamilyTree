import 'package:family_tree/Model/member.dart';
import 'package:family_tree/components/family/add_member_form.dart';
import 'package:family_tree/components/family/edit_member_form.dart';
import 'package:flutter/material.dart';

class EditMemberScreen extends StatefulWidget {
  final String currentDocId;
  final String currentName;
  final String currentDob;
  final String currentAge;
  final String currentRelationship;
  final String currentDescription;

  const EditMemberScreen(
      {Key? key,
      required this.currentDocId,
      required this.currentName,
      required this.currentDob,
      required this.currentAge,
      required this.currentRelationship,
      required this.currentDescription})
      : super(key: key);

  @override
  _EditMemberScreenState createState() => _EditMemberScreenState();
}

class _EditMemberScreenState extends State<EditMemberScreen> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _dobFocusNode = FocusNode();
  final FocusNode _ageFocusNode = FocusNode();
  final FocusNode _relationshipFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        _nameFocusNode.unfocus(),
        _dobFocusNode.unfocus(),
        _ageFocusNode.unfocus(),
        _relationshipFocusNode.unfocus(),
        _descriptionFocusNode.unfocus(),
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
          title: const Text(
            'Edit Member',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: EditMemberForm(
                  nameFocusNode: _nameFocusNode,
                  dobFocusNode: _dobFocusNode,
                  ageFocusNode: _ageFocusNode,
                  relationshipFocusNode: _relationshipFocusNode,
                  descriptionFocusNode: _descriptionFocusNode,
                  member: Member(
                      docId: widget.currentDocId,
                      name: widget.currentName,
                      dob: widget.currentDob,
                      age: widget.currentAge,
                      relationship: widget.currentRelationship,
                      description: widget.currentDescription),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

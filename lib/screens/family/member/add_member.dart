import 'package:family_tree/screens/family/member/add_member_form.dart';
import 'package:flutter/material.dart';

class AddMemberScreen extends StatelessWidget {
  AddMemberScreen({Key? key}) : super(key: key);

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
            'Add Member',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: AddMemberForm(
                  nameFocusNode: _nameFocusNode,
                  dobFocusNode: _dobFocusNode,
                  ageFocusNode: _ageFocusNode,
                  relationshipFocusNode: _relationshipFocusNode,
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

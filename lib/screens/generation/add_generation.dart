import 'package:family_tree/Model/member.dart';
import 'package:family_tree/components/generation/add_generation_form.dart';
import 'package:flutter/material.dart';

class AddGenerationScreen extends StatelessWidget {
  final List<Member> allMembers;

  AddGenerationScreen({Key? key, required this.allMembers}) : super(key: key);

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        _nameFocusNode.unfocus(),
        _descriptionFocusNode.unfocus(),
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
          title: const Text(
            'Add Generation',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: AddGenerationForm(
                nameFocusNode: _nameFocusNode,
                descriptionFocusNode: _descriptionFocusNode,
                allMembers: allMembers,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

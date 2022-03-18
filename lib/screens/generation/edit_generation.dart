import 'package:family_tree/Model/generation.dart';
import 'package:family_tree/Model/member.dart';
import 'package:family_tree/Model/quality.dart';
import 'package:family_tree/components/generation/edit_generation_form.dart';
import 'package:flutter/material.dart';

class EditGenerationScreen extends StatefulWidget {
  final String currentDocId;
  final String currentName;
  final List<Member> currentMembers;
  final List<Strength> currentStrengths;
  final List<Weaknesses> currentWeaknesses;
  final String currentDescription;
  final String currentType;
  final List<Member> allMembers;

  const EditGenerationScreen(
      {Key? key,
      required this.currentDocId,
      required this.currentName,
      required this.currentMembers,
      required this.currentStrengths,
      required this.currentWeaknesses,
      required this.currentDescription,
      required this.currentType,
      required this.allMembers})
      : super(key: key);

  @override
  _EditGenerationScreenState createState() => _EditGenerationScreenState();
}

class _EditGenerationScreenState extends State<EditGenerationScreen> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {_nameFocusNode.unfocus(), _descriptionFocusNode.unfocus()},
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue,
          title: const Text(
            'Edit Generation',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: EditGenerationForm(
                      nameFocusNode: _nameFocusNode,
                      descriptionFocusNode: _descriptionFocusNode,
                      generation: Generation(
                          docId: widget.currentDocId,
                          name: widget.currentName,
                          description: widget.currentDescription,
                          members: widget.currentMembers,
                          strengths: widget.currentStrengths,
                          weaknesses: widget.currentWeaknesses,
                          type: widget.currentType),
                      allMembers: widget.allMembers))
            ],
          ),
        ),
      ),
    );
  }
}

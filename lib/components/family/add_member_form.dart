import 'package:family_tree/Model/member.dart';
import 'package:family_tree/providers/member_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddMemberForm extends StatefulWidget {
  final FocusNode nameFocusNode;
  final FocusNode dobFocusNode;
  final FocusNode ageFocusNode;
  final FocusNode relationshipFocusNode;
  final FocusNode descriptionFocusNode;

  const AddMemberForm(
      {Key? key,
      required this.nameFocusNode,
      required this.dobFocusNode,
      required this.ageFocusNode,
      required this.relationshipFocusNode,
      required this.descriptionFocusNode})
      : super(key: key);

  @override
  _AddMemberFormState createState() => _AddMemberFormState();
}

class _AddMemberFormState extends State<AddMemberForm> {
  final _addMemberFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> relationships = [
    'My Self',
    'Father',
    'Mother',
    'Paternal Grandfather',
    'Paternal GrandMother',
    'Maternal Grandfather',
    'Maternal GrandMother',
    'Father\'s Siblings',
    'Mother\'s Siblings',
    'My Siblings'
  ];

  String getName = "";
  String getDob = "";
  String getAge = "";
  String getRelationship = "";
  String getDescription = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _addMemberFormKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.0),
              const Text(
                "Member Name",
                style: TextStyle(
                    color: Color.fromARGB(255, 22, 115, 177),
                    fontSize: 19.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: Provider.of<MemberProvider>(context, listen: false)
                    .inputDecoration(),
                controller: _nameController,
                focusNode: widget.nameFocusNode,
                onSaved: (String? val) {},
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                validator: (val) {
                  if (val != null && val.isEmpty) {
                    return 'Name cannot be empty.';
                  } else {
                    setState(() {
                      getName = val.toString();
                    });
                  }
                },
              ),
              const SizedBox(height: 8.0),
              const Text(
                "Date of Birth",
                style: TextStyle(
                    color: Color.fromARGB(255, 22, 115, 177),
                    fontSize: 19.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: Provider.of<MemberProvider>(context, listen: false)
                    .inputDecoration(pIcon: 'Search'),
                controller: _dobController,
                focusNode: widget.dobFocusNode,
                onSaved: (String? value) {},
                textInputAction: TextInputAction.done,
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2023));
                  if (newDate == null) return;
                  setState(() {
                    getDob = DateFormat('yyyy-MM-dd').format(newDate);
                    setState(() {
                      _dobController.text = getDob;
                      _ageController.text =
                          Provider.of<MemberProvider>(context, listen: false)
                              .calculateAge(newDate)
                              .toString();
                    });
                  });
                },
                validator: (val) {
                  if (val != null && val.isEmpty) {
                    return 'Date of Birth cannot be empty.';
                  } else {
                    setState(() {
                      getDob = val.toString();
                    });
                  }
                },
              ),
              const SizedBox(height: 8.0),
              SizedBox(height: 8.0),
              const Text(
                "Age",
                style: TextStyle(
                    color: Color.fromARGB(255, 22, 115, 177),
                    fontSize: 19.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: Provider.of<MemberProvider>(context, listen: false)
                    .inputDecoration(),
                controller: _ageController,
                focusNode: widget.ageFocusNode,
                onSaved: (String? value) {},
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                validator: (val) {
                  if (val != null && val.isEmpty) {
                    return 'Age cannot be empty.';
                  } else {
                    setState(() {
                      getAge = val.toString();
                    });
                  }
                },
              ),
              const SizedBox(height: 8.0),
              const Text(
                "Relationship",
                style: TextStyle(
                    color: Color.fromARGB(255, 22, 115, 177),
                    fontSize: 19.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              DropdownButtonFormField(
                decoration: Provider.of<MemberProvider>(context, listen: false)
                    .inputDecoration(),
                onChanged: (val) {
                  setState(() => getRelationship = val.toString());
                },
                value: getRelationship.isEmpty ? 'My Self' : getRelationship,
                validator: (String? val) {
                  if (val == null || val.isEmpty) {
                    return 'This source can not be empty.';
                  } else {
                    setState(() {
                      getRelationship = val.toString();
                    });
                  }
                },
                items: relationships.map((relationship) {
                  return DropdownMenuItem(
                    child: Text(relationship),
                    value: relationship,
                  );
                }).toList(),
              ),
              SizedBox(height: 8.0),
              const Text(
                "Description",
                style: TextStyle(
                    color: Color.fromARGB(255, 22, 115, 177),
                    fontSize: 19.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: Provider.of<MemberProvider>(context, listen: false)
                    .inputDecoration(),
                maxLines: 4,
                controller: _descriptionController,
                focusNode: widget.descriptionFocusNode,
                onSaved: (String? value) {},
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                validator: (val) {
                  setState(() {
                    getDescription = val.toString();
                  });
                },
              ),
              const SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    widget.nameFocusNode.unfocus();
                    widget.dobFocusNode.unfocus();
                    widget.ageFocusNode.unfocus();
                    widget.descriptionFocusNode.unfocus();
                    widget.descriptionFocusNode.unfocus();

                    if (_addMemberFormKey.currentState!.validate()) {
                      setState(() {
                        _isProcessing = true;
                      });

                      Member newMember = Member(
                          name: getName,
                          dob: getDob,
                          age: getAge,
                          relationship: getRelationship,
                          description: getDescription);

                      await Member.addMember(newMember);

                      setState(() async {
                        _isProcessing = false;
                         Provider.of<MemberProvider>(context, listen: false)
                            .alert(
                                title: 'Successfully Inserted',
                                body: 'Record has been successfully inserted',
                                context: context);
                      });
                    } else {
                      print(0);
                    }
                  },
                  style: ElevatedButton.styleFrom(maximumSize: Size.infinite),
                  child: (!_isProcessing)? Text('Save') : const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.redAccent,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

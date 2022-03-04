import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  InputDecoration _inputDecoration({String? pIcon}) {
    return InputDecoration(
      labelStyle: const TextStyle(color: Colors.yellowAccent),
      hintStyle: const TextStyle(color: Colors.grey),
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontWeight: FontWeight.bold,
      ),
      prefixIcon: (pIcon) != null
          ? Icon(Icons.date_range_rounded)
          : null,
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
            width: 2,
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
                decoration: _inputDecoration(),
                controller: _nameController,
                focusNode: widget.nameFocusNode,
                onSaved: (String? value) {},
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                validator: (String? value) {
                  return (value != null && value.contains('@'))
                      ? 'Do not use the @ char.'
                      : null;
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
                decoration: _inputDecoration(pIcon: 'Search'),
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
                    _dobController.text = getDob;
                  });
                },
                validator: (String? value) {
                  return (value != null && value.contains('@'))
                      ? 'Do not use the @ char.'
                      : null;
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
                decoration: _inputDecoration(),
                onChanged: (val) {
                  setState(() => getRelationship = val.toString());
                },
                value: getRelationship.isEmpty ? 'My Self' : getRelationship,
                validator: (val) {
                  if (val == null || val.toString().isEmpty) {
                    return 'This source can not be empty.';
                  }
                  getRelationship = val.toString();
                },
                items: relationships.map((account) {
                  return DropdownMenuItem(
                    child: Text(account),
                    value: account,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

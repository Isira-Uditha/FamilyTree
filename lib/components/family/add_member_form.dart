import 'dart:io';
import 'package:family_tree/Model/member.dart';
import 'package:family_tree/providers/member_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  bool _isUploding = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> relationships = [
    'My Self',
    'Father',
    'Mother',
    'Paternal GrandFather',
    'Paternal GrandMother',
    'Maternal GrandFather',
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

  XFile? _image;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future uploadImage() async {
    String fileName = basename(_image!.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('uploads/$fileName');
    UploadTask uploadTask = ref.putFile(File(_image!.path));
    uploadTask.then((res) {
      res.ref.getDownloadURL();
    });
    return 'uploads/$fileName';
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
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.blue,
                    child: ClipOval(
                      child: SizedBox(
                        width: 180.0,
                        height: 180.0,
                        child: (_image == null)
                            ? const Image(
                                image: AssetImage('assets/user.png'),
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(_image!.path),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        size: 30.0,
                      ),
                      onPressed: () async {
                        setState(() {
                          _isUploding = true;
                        });

                        await getImage();
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15.0),
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
                  FocusScope.of(context).requestFocus(FocusNode());
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
              const SizedBox(height: 8.0),
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
              const SizedBox(height: 8.0),
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

                      String imagePath = '';

                      if (_isUploding) {
                        imagePath = await uploadImage();
                      }

                      Member newMember = Member(
                        name: getName,
                        dob: getDob,
                        age: getAge,
                        relationship: getRelationship,
                        description: getDescription,
                        image: imagePath,
                      );

                      await Member.addMember(newMember);

                      setState(() async {
                        _isProcessing = false;
                        _isUploding = false;

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
                  child: (!_isProcessing)
                      ? const Text('Save')
                      : const CircularProgressIndicator(
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

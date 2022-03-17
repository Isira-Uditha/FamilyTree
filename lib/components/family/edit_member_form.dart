import 'dart:io';
import 'package:family_tree/Model/member.dart';
import 'package:family_tree/components/family/storage.dart';
import 'package:family_tree/providers/member_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class EditMemberForm extends StatefulWidget {
  final FocusNode nameFocusNode;
  final FocusNode dobFocusNode;
  final FocusNode ageFocusNode;
  final FocusNode relationshipFocusNode;
  final FocusNode descriptionFocusNode;
  final Member member;

  const EditMemberForm(
      {Key? key,
      required this.nameFocusNode,
      required this.dobFocusNode,
      required this.ageFocusNode,
      required this.relationshipFocusNode,
      required this.descriptionFocusNode,
      required this.member})
      : super(key: key);

  @override
  _EditMemberFormState createState() => _EditMemberFormState();
}

class _EditMemberFormState extends State<EditMemberForm> {
  final _editMemberFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  bool _isUploding = false;
  String getName = "";
  String getDob = "";
  String getAge = "";
  String getRelationship = "";
  String getDescription = "";
  XFile? _image;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.member.name;
    _dobController.text = widget.member.dob;
    _ageController.text = widget.member.age;
    _relationshipController.text = widget.member.relationship;
    _descriptionController.text = widget.member.description;
  }

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

  static Future<dynamic> loadFromStorage(
      BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }

  Future<Widget> _getImage(BuildContext context, String image) async {
    Image m = const Image(
      image: AssetImage('assets/user.png'),
      fit: BoxFit.fill,
    );

    if (widget.member.image != '') {
      await FireStorageService.loadFromStorage(context, image)
          .then((downloadUrl) {
        m = Image.network(
          downloadUrl.toString(),
          fit: BoxFit.fill,
        );
      });
    }
    return m;
  }

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getImage(context, widget.member.image),
        builder: (context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Form(
                key: _editMemberFormKey,
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
                                    ? snapshot.data
                                    : Image.file(
                                        File(_image!.path),
                                        fit: BoxFit.fill,
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
                      const SizedBox(height: 8.0),
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
                        decoration:
                            Provider.of<MemberProvider>(context, listen: false)
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
                        decoration:
                            Provider.of<MemberProvider>(context, listen: false)
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
                              _ageController.text = Provider.of<MemberProvider>(
                                      context,
                                      listen: false)
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
                        decoration:
                            Provider.of<MemberProvider>(context, listen: false)
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
                        decoration:
                            Provider.of<MemberProvider>(context, listen: false)
                                .inputDecoration(),
                        onChanged: (val) {
                          setState(() => getRelationship = val.toString());
                        },
                        value: getRelationship.isEmpty
                            ? widget.member.relationship
                            : getRelationship,
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
                        decoration:
                            Provider.of<MemberProvider>(context, listen: false)
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

                            if (_editMemberFormKey.currentState!.validate()) {
                              setState(() {
                                _isProcessing = true;
                              });

                              String imagePath = widget.member.image;

                              if (_isUploding) {
                                imagePath = await uploadImage();
                              }

                              Member newMember = Member(
                                  docId: widget.member.docId,
                                  name: getName,
                                  dob: getDob,
                                  age: getAge,
                                  relationship: getRelationship,
                                  description: getDescription,
                                  image: imagePath);

                              await Member.updateMember(newMember);

                              setState(() {
                                _isProcessing = false;
                                _isUploding = false;
                                Provider.of<MemberProvider>(context,
                                        listen: false)
                                    .alert(
                                        title: 'Successfully Updated',
                                        body:
                                            'Record has been successfully updated',
                                        context: context);
                              });
                            } else {
                              print(0);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              maximumSize: Size.infinite),
                          child: (!_isProcessing)
                              ? const Text('Edit')
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
          } else {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
              ),
            );
          }
        });
  }
}

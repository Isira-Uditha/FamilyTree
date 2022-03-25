import 'package:family_tree/Model/generation.dart';
import 'package:family_tree/Model/member.dart';
import 'package:family_tree/Model/quality.dart';
import 'package:family_tree/providers/member_provider.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class EditGenerationForm extends StatefulWidget {
  final FocusNode nameFocusNode;
  final FocusNode descriptionFocusNode;
  final Generation generation;
  final List<Member> allMembers;

  const EditGenerationForm(
      {Key? key,
      required this.nameFocusNode,
      required this.descriptionFocusNode,
      required this.generation,
      required this.allMembers})
      : super(key: key);

  @override
  _EditGenerationFormState createState() => _EditGenerationFormState();
}

class _EditGenerationFormState extends State<EditGenerationForm> {
  final _editGenerationFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  String getName = "";
  String getDescription = "";
  List<Member> getMembers = [];
  List<Strength> getStrengths = [];
  List<Weaknesses> getWeaknesses = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Member> members = [];
  List<Member> _selectedMembers = [];
  List<Strength> _selectedStrengths = [];
  List<Weaknesses> _selectedWeaknesses = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.generation.name;
    _descriptionController.text = widget.generation.description;

    for (var member in widget.allMembers) {
      widget.generation.members.forEach((element) {
        if (element.docId == member.docId) {
          _selectedMembers.add(member);
        }
      });
    }

    for (var element in Strength.strengths) {
      for (var currentStrength in widget.generation.strengths) {
        if (currentStrength.id == element.id) {
          _selectedStrengths.add(element);
        }
      }
    }

    for (var element in Weaknesses.weaknesses) {
      for (var currentStrength in widget.generation.weaknesses) {
        if (currentStrength.id == element.id) {
          _selectedWeaknesses.add(element);
        }
      }
    }

    getMembers = _selectedMembers;
    getWeaknesses = _selectedWeaknesses;
    getStrengths = _selectedStrengths;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _editGenerationFormKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              const Text(
                "Generation Name",
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
              const SizedBox(height: 15.0),
              MultiSelectDialogField(
                  items: widget.allMembers
                      .map((e) => MultiSelectItem(e, e.name))
                      .toList(),
                  initialValue: _selectedMembers,
                  title: const Text("Members"),
                  selectedColor: Colors.blue,
                  validator: (values) {
                    if (values == null || values.isEmpty) {
                      return "Members can not be empty";
                    }
                  },
                  searchable: true,
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      //   borderRadius: BorderRadius.all(Radius.circular(40)),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      )),
                  buttonIcon: const Icon(
                    Icons.family_restroom,
                    color: Colors.blue,
                  ),
                  buttonText: const Text(
                    "Add Members",
                    style: TextStyle(
                        fontSize: 19,
                        color: Color.fromARGB(255, 22, 115, 177),
                        fontWeight: FontWeight.bold),
                  ),
                  onConfirm: (results) {
                    _selectedMembers = results.cast<Member>();
                    setState(() {
                      _selectedMembers = _selectedMembers;
                    });
                    getMembers = [];
                    getMembers.addAll(_selectedMembers);
                  },
                  chipDisplay: MultiSelectChipDisplay(
                    onTap: (value) {
                      setState(() {
                        _selectedMembers.remove(value);
                      });
                    },
                  )),
              getMembers.isEmpty
                  ? Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "None selected",
                        style: TextStyle(color: Colors.black54),
                      ))
                  : Container(),
              const SizedBox(height: 8.0),
              MultiSelectBottomSheetField(
                initialChildSize: 0.4,
                listType: MultiSelectListType.CHIP,
                searchable: true,
                validator: (values) {
                  if (values == null || values.isEmpty) {
                    return "Strengths can not be empty";
                  }
                },
                buttonText: const Text(
                  "Strengths",
                  style: TextStyle(
                      fontSize: 19,
                      color: Color.fromARGB(255, 22, 115, 177),
                      fontWeight: FontWeight.bold),
                ),
                title: const Text("Strengths"),
                backgroundColor: Colors.white,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                  //   borderRadius: BorderRadius.all(Radius.circular(40)),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                items: Strength.strengths
                    .map((e) => MultiSelectItem(e, e.name))
                    .toList(),
                initialValue: _selectedStrengths,
                onConfirm: (values) {
                  _selectedStrengths = values.cast<Strength>();
                  setState(() {
                    _selectedStrengths = _selectedStrengths;
                  });
                  getStrengths = [];
                  getStrengths.addAll(_selectedStrengths);
                },
                chipDisplay: MultiSelectChipDisplay(
                  onTap: (value) {
                    setState(() {
                      _selectedStrengths.remove(value);
                    });
                  },
                ),
              ),
              getStrengths.isEmpty
                  ? Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "None selected",
                        style: TextStyle(color: Colors.black54),
                      ))
                  : Container(),
              const SizedBox(height: 8.0),
              MultiSelectBottomSheetField(
                initialChildSize: 0.4,
                listType: MultiSelectListType.CHIP,
                validator: (values) {
                  if (values == null || values.isEmpty) {
                    return "Weaknesses can not be empty";
                  }
                },
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                    //   borderRadius: BorderRadius.all(Radius.circular(40)),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    )),
                searchable: true,
                buttonText: const Text(
                  "Weaknesses",
                  style: TextStyle(
                      fontSize: 19,
                      color: Color.fromARGB(255, 22, 115, 177),
                      fontWeight: FontWeight.bold),
                ),
                title: const Text("Weaknesses"),
                backgroundColor: Colors.white,
                items: Weaknesses.weaknesses
                    .map((e) => MultiSelectItem(e, e.name))
                    .toList(),
                initialValue: _selectedWeaknesses,
                onConfirm: (values) {
                  _selectedWeaknesses = values.cast<Weaknesses>();
                  setState(() {
                    _selectedWeaknesses = _selectedWeaknesses;
                  });
                  getWeaknesses = [];
                  getWeaknesses.addAll(_selectedWeaknesses);
                },
                chipDisplay: MultiSelectChipDisplay(
                  onTap: (value) {
                    setState(() {
                      _selectedWeaknesses.remove(value);
                    });
                  },
                ),
              ),
              getWeaknesses.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "None selected",
                        style: TextStyle(color: Colors.black54),
                      ))
                  : Container(),
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
                    widget.descriptionFocusNode.unfocus();

                    if (_editGenerationFormKey.currentState!.validate()) {
                      setState(() {
                        _isProcessing = true;
                      });
                      GenerationType generationType =
                          Generation.findGeneration(getMembers);
                      Generation updatedGeneration = Generation(
                          docId: widget.generation.docId,
                          name: getName,
                          description: getDescription,
                          members: getMembers,
                          strengths: getStrengths,
                          weaknesses: getWeaknesses,
                          type: generationType.name);

                      await Generation.updateGeneration(updatedGeneration);

                      setState(() {
                        _isProcessing = false;
                        Provider.of<MemberProvider>(context, listen: false)
                            .alert(
                                title: 'Successfully Updated',
                                body: 'Record has been successfully updated',
                                context: context);
                      });
                    } else {
                      print(0);
                    }
                  },
                  style: ElevatedButton.styleFrom(maximumSize: Size.infinite),
                  child: (!_isProcessing)
                      ? const Text('Update')
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

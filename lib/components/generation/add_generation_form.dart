import 'dart:ui';
import 'package:family_tree/Model/generation.dart';
import 'package:family_tree/Model/member.dart';
import 'package:family_tree/Model/quality.dart';
import 'package:family_tree/providers/generation_provider.dart';
import 'package:flutter/material.dart';
import 'package:giff_dialog/giff_dialog.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class AddGenerationForm extends StatefulWidget {
  final FocusNode nameFocusNode;
  final FocusNode descriptionFocusNode;
  final List<Member> allMembers;

  const AddGenerationForm(
      {Key? key,
      required this.nameFocusNode,
      required this.descriptionFocusNode,
      required this.allMembers})
      : super(key: key);

  @override
  _AddGenerationFormState createState() => _AddGenerationFormState();
}

class _AddGenerationFormState extends State<AddGenerationForm> {
  final _addGenerationFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String getName = "";
  String getDescription = "";
  List<Member> getMembers = [];
  List<Strength> getStrengths = [];
  List<Weaknesses> getWeaknesses = [];

  List<Member> members = [];

  List<Member> _selectedMembers = [];
  List<Strength> _selectedStrengths = [];
  List<Weaknesses> _selectedWeaknesses = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
          key: _addGenerationFormKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                decoration: Provider.of<GenerationProvider>(context, listen: false)
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
                  title: const Text("Members"),
                  selectedColor: Colors.blue,
                  searchable: true,
                  validator: (values) {
                    if (values == null || values.isEmpty) {
                      return "Members can not be empty";
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
                    getMembers.addAll(_selectedMembers);
                  },
                  chipDisplay: MultiSelectChipDisplay(
                    onTap: (value) {
                      setState(() {
                        _selectedMembers.remove(value);
                      });
                    },
                  )),
              _selectedMembers.isEmpty
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
                onConfirm: (values) {
                  _selectedStrengths = values.cast<Strength>();
                  setState(() {
                    _selectedStrengths = _selectedStrengths;
                  });
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
              _selectedStrengths.isEmpty
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
                onConfirm: (values) {
                  _selectedWeaknesses = values.cast<Weaknesses>();
                  setState(() {
                    _selectedWeaknesses = _selectedWeaknesses;
                  });
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
                      padding: EdgeInsets.all(10),
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
                decoration: Provider.of<GenerationProvider>(context, listen: false)
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

                    if (_addGenerationFormKey.currentState!.validate()) {
                      setState(() {
                        _isProcessing = true;
                      });
                      GenerationType generationType =
                          Generation.findGeneration(getMembers);
                      Generation newGeneration = Generation(
                          name: getName,
                          description: getDescription,
                          members: getMembers,
                          strengths: getStrengths,
                          weaknesses: getWeaknesses,
                          type: generationType.name);

                      await Generation.addGeneration(newGeneration);

                      setState(() {
                        _isProcessing = false;
                        showDialog(
                            context: context,
                            builder: (_) => AssetGiffDialog(
                                  onlyOkButton: true,
                                  buttonOkColor: Colors.blue,
                                  image: Image.asset(
                                    generationType.gifUrl,
                                    fit: BoxFit.fill,
                                  ),
                                  title: Text(
                                    generationType.name,
                                    style: const TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  description: Text(
                                    'This generation seems to be belongs to ${generationType.name} according to the selected members',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 19.0),
                                  ),
                                  entryAnimation: EntryAnimation.top,
                                  onOkButtonPressed: () {
                                    int count = 0;
                                    Navigator.of(context)
                                        .popUntil((_) => count++ >= 2);
                                  },
                                ));
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
            ]),
          )),
    );
  }
}

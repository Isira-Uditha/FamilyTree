import 'dart:collection';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/Model/member.dart';
import 'package:family_tree/Model/history.dart';
import 'package:family_tree/providers/history_provider.dart';
import 'package:family_tree/providers/member_provider.dart';
import 'package:flutter/material.dart';
import 'package:giff_dialog/giff_dialog.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';


class AddHistoryForm extends StatefulWidget {
  final FocusNode topicFocusNode;
  final FocusNode historyDateFocusNode;
  final FocusNode historyImageFocusNode;
  final List<Member> allMembers;
  final FocusNode descriptionFocusNode;

  const AddHistoryForm(
      {Key? key,
        required this.topicFocusNode,
        required this.historyDateFocusNode,
        required this.historyImageFocusNode,
        required this.allMembers,
        required this.descriptionFocusNode})
      : super(key: key);

  @override
  _AddHistoryFormState createState() => _AddHistoryFormState();
}

class _AddHistoryFormState extends State<AddHistoryForm> {
  final _addHistoryFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _historyDateController = TextEditingController();
  final TextEditingController _historyImageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String gettopic = "";
  String gethistoryDate = "";
  String gethistoryImage = "";
  List<Member> getmembers = [];
  String getDescription = "";

  List<Member> members = [];

  List<Member> _selectedMembers = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _addHistoryFormKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.0),
              const Text(
                "History Topic",
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
                controller: _topicController,
                focusNode: widget.topicFocusNode,
                onSaved: (String? val) {},
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                validator: (val) {
                  if (val != null && val.isEmpty) {
                    return 'Topic cannot be empty.';
                  } else {
                    setState(() {
                      gettopic = val.toString();
                    });
                  }
                },
              ),
              const SizedBox(height: 8.0),
              const Text(
                "History Date",
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
                controller: _historyDateController,
                focusNode: widget.historyDateFocusNode,
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
                    gethistoryDate = DateFormat('yyyy-MM-dd').format(newDate);
                    setState(() {
                      _historyDateController.text = gethistoryDate;
                      // _ageController.text =
                      //     Provider.of<MemberProvider>(context, listen: false)
                      //         .calculateAge(newDate)
                      //         .toString();
                    });
                  });
                },
                validator: (val) {
                  if (val != null && val.isEmpty) {
                    return 'History date cannot be empty.';
                  } else {
                    setState(() {
                      gethistoryDate = val.toString();
                    });
                  }
                },
              ),
              //const SizedBox(height: 8.0),
              // SizedBox(height: 8.0),
              // const Text(
              //   "Age",
              //   style: TextStyle(
              //       color: Color.fromARGB(255, 22, 115, 177),
              //       fontSize: 19.0,
              //       letterSpacing: 1,
              //       fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 8.0),
              // TextFormField(
              //   decoration: Provider.of<MemberProvider>(context, listen: false)
              //       .inputDecoration(),
              //   controller: _ageController,
              //   focusNode: widget.ageFocusNode,
              //   onSaved: (String? value) {},
              //   textInputAction: TextInputAction.done,
              //   keyboardType: TextInputType.text,
              //   validator: (val) {
              //     if (val != null && val.isEmpty) {
              //       return 'Age cannot be empty.';
              //     } else {
              //       setState(() {
              //         getAge = val.toString();
              //       });
              //     }
              //   },
              // ),
              //const SizedBox(height: 8.0),
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
                    getmembers.addAll(_selectedMembers);
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



              // const Text(
              //   "Member",
              //   style: TextStyle(
              //       color: Color.fromARGB(255, 22, 115, 177),
              //       fontSize: 19.0,
              //       letterSpacing: 1,
              //       fontWeight: FontWeight.bold),
              // ),

              // const SizedBox(height: 8.0),
              // DropdownButtonFormField(
              //   decoration: Provider.of<MemberProvider>(context, listen: false)
              //       .inputDecoration(),
              //   onChanged: (val) {
              //     setState(() => getmembers = val.toString());
              //   },
              //   value: getmembers.isEmpty ? 'My Self' : getmembers,
              //   validator: (String? val) {
              //     if (val == null || val.isEmpty) {
              //       return 'This source can not be empty.';
              //     } else {
              //       setState(() {
              //         getmembers = val.toString();
              //       });
              //     }
              //   },
              //   items: relationships.map((relationship) {
              //     return DropdownMenuItem(
              //       child: Text(relationship),
              //       value: relationship,
              //     );
              //   }).toList(),
              // ),
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
                    widget.topicFocusNode.unfocus();
                    widget.historyDateFocusNode.unfocus();
                    widget.historyImageFocusNode.unfocus();
                    widget.descriptionFocusNode.unfocus();

                    if (_addHistoryFormKey.currentState!.validate()) {
                      setState(() {
                        _isProcessing = true;
                      });

                      History newHistory = History(
                          topic: gettopic,
                          historyDate: gethistoryDate,
                          historyImage: gethistoryImage,
                          members: getmembers,
                          description: getDescription);

                      await History.addHistory(newHistory);

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

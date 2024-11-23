import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:schoolezy/authentication/cubit/auth_cubit.dart';
import 'package:schoolezy/pages/admin/cubit/admin_cubit.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/employee/cubit/employee_cubit.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/student/cubit/student_cubit.dart';
import 'package:schoolezy/utility/appcolors.dart';
import 'package:schoolezy/utility/apppadding.dart';
import 'package:schoolezy/utility/constant.dart';
import 'package:schoolezy/utility/sizeconfig.dart';
import 'package:universal_html/html.dart' as html;
import 'package:user/userrepo.dart';

class WebEmployeePageDetailSetup extends StatefulWidget {
  const WebEmployeePageDetailSetup({super.key});

  @override
  State<WebEmployeePageDetailSetup> createState() => _WebEmployeeDetailSetupState();
}

class _WebEmployeeDetailSetupState extends State<WebEmployeePageDetailSetup> {
  FilePickerResult? _result;
  UploadFile? _fileSuccess;
  bool fileUploading = false;
  ImportLogs? importLogs;
  List<String>? jsonStrings = [];
  bool fileDownloading = false;

  Future<void> saveToDownloadFolderWeb(Uint8List? uint8list) async {
    final content = base64Encode(uint8list!.toList());
    final anchor = html.AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,$content')
      ..setAttribute('download', 'file.txt')
      ..click();
  }

  TextEditingController _studentController = TextEditingController();
  TextEditingController _SeriesController = TextEditingController();
  TextEditingController _GenderController = TextEditingController();
  TextEditingController _DateOfJoingController = TextEditingController();
  TextEditingController _DateOfBirthController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _CompanyController = TextEditingController();
  TextEditingController _PersonalController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? Contectlist;

  // List<String> genderList = [
  //   'Female',
  //   'Genderqueer',
  //   'Male',
  //   'Non-Conforming',
  //   'Other',
  //   'Prefer not to say',
  //   'Transgender',
  // ];
  String? _genderList;

  bool isChecked = false;
  int teachingStaff = 0;

  User? user;
  bool postLoading = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final brightness = Theme.of(context).brightness;
    user = context.read<AuthCubit>().state.user;

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return BlocListener<EmployeeCubit, EmployeeState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          context.pop();
        }
        if (state.status == FormzSubmissionStatus.inProgress) {
          postLoading = true;
        }
        if (state.status == FormzSubmissionStatus.failure) {
          postLoading = false;
        }
      },
      child: BlocListener<StudentCubit, StudentState>(
        listener: (context, state) {
          if (state is UploadFileStatus) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(fileUploadSuccess)));
          }
        },
        child: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            if (state is DataImportLoading) {
              fileUploading = true;
            }
            if (state is DataImportSuccess) {
              importLogs = state.importLogs;
              if (importLogs != null && importLogs!.data!.isNotEmpty) {
                for (final element in importLogs!.data!) {
                  jsonStrings!.add(element.messages!);
                }
              }

              // final importStatus =
              //     ImportLog.fromJson();
              // jsonString = importStatus.messages;
              fileUploading = false;
            }
            return BlocBuilder<StudentCubit, StudentState>(
              builder: (context, state) {
                if (state is UploadFileStatus) {
                  _fileSuccess = state.message;
                  fileUploading = false;
                }
                if (state is DownloadingFile) {
                  fileDownloading = true;
                }
                if (state is DownloadingFileSuccess) {
                  saveToDownloadFolderWeb(state.uint8list);
                  fileDownloading = false;
                }
                if (state is DownloadingFileFailure) {
                  fileDownloading = false;
                }
                return Scaffold(
                  appBar: AppBar(),
                  body: Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: twenty4Padding, left: twelvePadding),
                                child: Text(
                                  employeedetails,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: mediumPadding,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Employee Name';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          context.read<EmployeeCubit>().onemployeeChange(_nameController.text);
                                        });
                                      },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      controller: _nameController,
                                      // validator:
                                      //     checkNumbersOnlyValidation,
                                      decoration: InputDecoration(
                                        labelText: 'Employee Name',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: mediumPadding,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Date Of Birth';
                                        }
                                        return null;
                                      },

                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime(2100));

                                        if (pickedDate != null) {
                                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

                                          setState(() {
                                            _DateOfBirthController.text = formattedDate;
                                            context.read<EmployeeCubit>().onDateofbirthChange(_DateOfBirthController.text);
                                          });
                                        } else {}
                                      },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      controller: _DateOfBirthController,
                                      // validator:
                                      //     checkNumbersOnlyValidation,
                                      decoration: InputDecoration(
                                        labelText: 'Date Of Birth',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: mediumPadding,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                          return 'Please enter Personal Email';
                                        }
                                        return null;
                                      },

                                      onChanged: (value) {
                                        setState(() {
                                          context.read<EmployeeCubit>().onPersonalEmail(_PersonalController.text);
                                        });
                                      },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      controller: _PersonalController,
                                      // validator:
                                      //     checkNumbersOnlyValidation,
                                      decoration: InputDecoration(
                                        labelText: 'Personal Email',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: mediumPadding,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Date Of Joing';
                                        }
                                        return null;
                                      },
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime(2100));

                                        if (pickedDate != null) {
                                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

                                          setState(() {
                                            _DateOfJoingController.text = formattedDate;
                                            context.read<EmployeeCubit>().ondateofjoingChange(_DateOfJoingController.text);
                                          });
                                        } else {}
                                      },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      controller: _DateOfJoingController,
                                      // validator:
                                      //     checkNumbersOnlyValidation,
                                      decoration: InputDecoration(
                                        labelText: 'Date Of Joing',
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('  Prefered contact email'),
                                      Padding(
                                        padding: mediumPadding,
                                        child: DropdownButtonFormField(
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please select your Prefered contact email';
                                            }
                                            return null;
                                          },

                                          decoration: const InputDecoration(
                                            //  enabledBorder: OutlineInputBorder( //<-- SEE HERE
                                            //   // borderSide: BorderSide(color: Colors.black, width: 2),
                                            //  ),
                                            //  focusedBorder: OutlineInputBorder( //<-- SEE HERE
                                            //  //  borderSide: BorderSide(color: Colors.black, width: 2),
                                            //  ),
                                            filled: true,
                                            // fillColor: Colors.greenAccent,
                                          ),
                                          // dropdownColor: Colors.greenAccent,
                                          value: Contectlist,
                                          onChanged: (String? status) {
                                            setState(() {
                                              Contectlist = status;
                                              context.read<EmployeeCubit>().onContactEmailChange(Contectlist);
                                            });
                                          },

                                          items: contectlist.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('  Gender'),
                                      Padding(
                                        padding: mediumPadding,
                                        child: DropdownButtonFormField(
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please select your gender';
                                            }
                                            return null;
                                          },

                                          decoration: const InputDecoration(
                                            //  enabledBorder: OutlineInputBorder( //<-- SEE HERE
                                            //   // borderSide: BorderSide(color: Colors.black, width: 2),
                                            //  ),
                                            //  focusedBorder: OutlineInputBorder( //<-- SEE HERE
                                            //  //  borderSide: BorderSide(color: Colors.black, width: 2),
                                            //  ),
                                            filled: true,
                                            // fillColor: Colors.greenAccent,
                                          ),
                                          // dropdownColor: Colors.greenAccent,
                                          value: _genderList,
                                          onChanged: (String? status) {
                                            setState(() {
                                              _genderList = status;
                                              context.read<EmployeeCubit>().ongenderChange(_genderList);
                                            });
                                          },

                                          items: genderlist.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Checkbox(
                                        checkColor: Colors.white,
                                        fillColor: MaterialStateProperty.resolveWith(getColor),
                                        value: isChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isChecked = value!;
                                          });
                                        },
                                      ),

                                      Text(
                                        'teaching staff',
                                        style: TextStyle(fontSize: 17.0),
                                      ), //Checkbox
                                    ], //<Widget>[]
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, twenty4Padding, 0, 0),
                                        child: ElevatedButton(
                                          //  style: style,
                                          onPressed: () {
                                            if (_formKey.currentState!.validate()) {
                                              context.read<EmployeeCubit>().onPostEmployeeList((isChecked == false) ? 0 : 1);
                                            }
                                            final _CompanyController = user!.message!.data!.school.toString();
                                          },
                                          child: postLoading
                                              ? SizedBox.square(
                                                  dimension: SizeConfig.blockSizeHorizontal! * 2,
                                                  child: Center(
                                                    child: CircularProgressIndicator(),
                                                  ),
                                                )
                                              : Text('Submit'),
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.fromLTRB(0, twenty4Padding, 0, 0),
                                      //   child: InkWell(
                                      //     onTap: () {
                                      //       if(_formKey.currentState!.validate()){
                                      //          context.read<EmployeeCubit>().onPostEmployeeList(teachingStaff);
                                      //       }
                                      //       final _CompanyController = user!.message!.data!.school.toString();
                                      //      // if (state.isValid)
                                      //      //  context.read<EmployeeCubit>().onPostEmployeeList(teachingStaff);
                                      //     },
                                      //     child: Card(
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.circular(4.0), //<-- SEE HERE
                                      //       ),
                                      //       child: Padding(
                                      //         padding: mediumPadding,
                                      //         child: Column(
                                      //           children: const [
                                      //             Text(
                                      //               '    Submit    ',
                                      //               style: TextStyle(
                                      //                 fontWeight: FontWeight.bold,
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          // child: ,
                          child: Card(
                            child: IgnorePointer(
                              ignoring: false,
                              child: Center(
                                child: Column(
                                  children: [
                                    Row(
                                      children: const [
                                        // const Expanded(
                                        //   child: Padding(
                                        //     padding: EdgeInsets.fromLTRB(
                                        //       fiftyPadding,
                                        //       twenty4Padding,
                                        //       hunderedPadding,
                                        //       twelvePadding,
                                        //     ),
                                        // child:
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: sixteenPadding,
                                            top: sixteenPadding,
                                          ),
                                          child: Text(bulkUpload),
                                        ),
                                        //   ),
                                        // ),
                                        // Padding(
                                        //   padding: const EdgeInsets.fromLTRB(
                                        //     sixPadding,
                                        //     twenty4Padding,
                                        //     fiftyPadding,
                                        //     twelvePadding,
                                        //   ),
                                        //   child: Card(
                                        //     color: brightness == Brightness.light ? lightSoftRedAlert : darkSoftRedAlert,
                                        //     child: Row(
                                        //       children: [
                                        //         const Padding(
                                        //           padding: mediumPadding,
                                        //           child: Text('Data will be auto saved!'),
                                        //         ),
                                        //         LineIcon(LineIcons.exclamationCircle)
                                        //       ],
                                        //     ),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: smallPadding,
                                        child: SizedBox(
                                          height: SizeConfig.blockSizeHorizontal! * 22,
                                          width: SizeConfig.blockSizeHorizontal! * 22,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4.0), //<-- SEE HERE
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              // mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: mediumPadding,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      FilledButton.icon(
                                                        onPressed: () async {
                                                          await pickAFile();
                                                          setState(() {});
                                                        },
                                                        icon: fileUploading
                                                            ? SizedBox(
                                                                width: SizeConfig.blockSizeHorizontal! * 2,
                                                                height: SizeConfig.blockSizeHorizontal! * 2,
                                                                child: Center(
                                                                  child: CircularProgressIndicator(
                                                                    color: darkSoftRedAlert,
                                                                  ),
                                                                ),
                                                              )
                                                            : const Icon(Icons.upload_file),
                                                        label: Text(_result != null && _result!.files.first.name.isNotEmpty
                                                                ? _result!.files.first.name
                                                                : '$bulkUpload '
                                                            // $staffDetails',
                                                            ),
                                                      ),
                                                      if (_result != null && _result!.files.first.name.isNotEmpty)
                                                        TextButton(
                                                          onPressed: () {
                                                            //    _result!.files.clear();
                                                            setState(() {});
                                                          },
                                                          child: const Text(clear),
                                                        )
                                                      else
                                                        const SizedBox()
                                                    ],
                                                  ),
                                                ),
                                                if (_result != null && _result!.files.first.name.isNotEmpty)
                                                  Padding(
                                                    padding: mediumPadding,
                                                    child: ElevatedButton(
                                                      child: const Text(upload),
                                                      onPressed: () {
                                                        if (kIsWeb) {
                                                          final fileWeb = _result!.files.first.bytes!;
                                                          final fileName = _result!.files.first.name;
                                                          context.read<AdminCubit>().postDataImport(
                                                                fileWeb,
                                                                fileName,
                                                                employee,
                                                              );
                                                        } else {
                                                          //  context.read<StudentCubit>().uploadFile();
                                                        }
                                                      },
                                                    ),
                                                  )
                                                else
                                                  const SizedBox(),
                                                if (jsonStrings != null && jsonStrings!.isNotEmpty)
                                                  SizedBox(
                                                    height: SizeConfig.blockSizeVertical! * 20,
                                                    child: ListView(
                                                      children: List.generate(
                                                        jsonStrings!.length,
                                                        (index) => Text(
                                                          jsonStrings!.elementAt(index),
                                                        ),
                                                      ),
                                                    ),
                                                  ).animate().fadeIn()
                                                else
                                                  const SizedBox()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: smallPadding,
                                        child: SizedBox(
                                          height: SizeConfig.blockSizeHorizontal! * 22,
                                          width: SizeConfig.blockSizeHorizontal! * 22,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4.0), //<-- SEE HERE
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              // mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: mediumPadding,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      FilledButton.icon(
                                                        onPressed: () async {
                                                          await pickAFile();
                                                          setState(() {});
                                                        },
                                                        icon: fileUploading
                                                            ? SizedBox(
                                                                width: SizeConfig.blockSizeHorizontal! * 2,
                                                                height: SizeConfig.blockSizeHorizontal! * 2,
                                                                child: Center(
                                                                  child: CircularProgressIndicator(
                                                                    color: darkSoftRedAlert,
                                                                  ),
                                                                ),
                                                              )
                                                            : const Icon(Icons.upload_file),
                                                        label: Text(_result != null && _result!.files.first.name.isNotEmpty
                                                                ? _result!.files.first.name
                                                                : '$bulkUpload '
                                                            // $staffDetails',
                                                            ),
                                                      ),
                                                      if (_result != null && _result!.files.first.name.isNotEmpty)
                                                        TextButton(
                                                          onPressed: () {
                                                            //    _result!.files.clear();
                                                            setState(() {});
                                                          },
                                                          child: const Text(clear),
                                                        )
                                                      else
                                                        const SizedBox()
                                                    ],
                                                  ),
                                                ),
                                                if (_result != null && _result!.files.first.name.isNotEmpty)
                                                  Padding(
                                                    padding: mediumPadding,
                                                    child: ElevatedButton(
                                                      child: const Text(upload),
                                                      onPressed: () {
                                                        if (kIsWeb) {
                                                          final fileWeb = _result!.files.first.bytes!;
                                                          final fileName = _result!.files.first.name;
                                                          context.read<AdminCubit>().postDataImport(
                                                                fileWeb,
                                                                fileName,
                                                                employee,
                                                              );
                                                        } else {
                                                          //  context.read<StudentCubit>().uploadFile();
                                                        }
                                                      },
                                                    ),
                                                  )
                                                else
                                                  const SizedBox(),
                                                if (jsonStrings != null && jsonStrings!.isNotEmpty)
                                                  SizedBox(
                                                    height: SizeConfig.blockSizeVertical! * 20,
                                                    child: ListView(
                                                      children: List.generate(
                                                        jsonStrings!.length,
                                                        (index) => Text(
                                                          jsonStrings!.elementAt(index),
                                                        ),
                                                      ),
                                                    ),
                                                  ).animate().fadeIn()
                                                else
                                                  const SizedBox()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<FilePickerResult?> pickAFile() async {
    return _result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx', 'csv'],
    );
  }
}

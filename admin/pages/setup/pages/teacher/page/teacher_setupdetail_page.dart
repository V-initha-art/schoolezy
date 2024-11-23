// ignore_for_file: avoid_dynamic_calls, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names, unused_field, prefer_int_literals, unused_local_variable, omit_local_variable_types

import 'dart:convert';

import 'package:admin/adminrepo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import 'package:schoolezy/pages/admin/cubit/admin_cubit.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/employee/cubit/employee_cubit.dart';

import 'package:schoolezy/pages/admin/pages/setup/pages/student/cubit/student_cubit.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/teacher/cubit/teacher_cubit.dart';
import 'package:schoolezy/utility/appcolors.dart';
import 'package:schoolezy/utility/apppadding.dart';
import 'package:schoolezy/utility/constant.dart';
import 'package:schoolezy/utility/sizeconfig.dart';
import 'package:user/userrepo.dart';
import 'package:universal_html/html.dart' as html;

class WebTeacherPageDetailSetup extends StatefulWidget {
  const WebTeacherPageDetailSetup({super.key});

  @override
  State<WebTeacherPageDetailSetup> createState() => _WebTeacherPageDetailSetupState();
}

class _WebTeacherPageDetailSetupState extends State<WebTeacherPageDetailSetup> {
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

  TextEditingController _employeeController = TextEditingController();
  TextEditingController _TeacherNameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String? _genderlist;
  String? _Statuslist;

  @override
  void didChangeDependencies() {
    context.read<EmployeeCubit>().getEmployee();

    super.didChangeDependencies();
  }

  Employees? employeeEntries;
  bool employeeLoading = false;
  Employee? selectedEmployee;
  //final  employeeEntries = <DropdownMenuEntry<Employees>>[];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final brightness = Theme.of(context).brightness;

    return BlocListener<TeacherCubit, TeacherState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          context.pop();
        }

        // TODO: implement listener
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
            return BlocBuilder<EmployeeCubit, EmployeeState>(
              builder: (context, state) {
                if (state is EmployeeLoading) {
                  employeeLoading = true;
                }
                if (state is EmployeeFailure) {
                  employeeLoading = false;
                }
                if (state is EmployeeSuccess) {
                  employeeEntries = state.employees;

                  employeeLoading = false;

                  // for (final icon in state.employeeView) {
                  //   print('icon.name.............${icon.name}');

                  //   programEntries.add(
                  //     DropdownMenuEntry<NameOnly>(
                  //       value: icon,
                  //       label: icon.name.toString(),
                  //     ),
                  //   );
                  // }
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
                        key: formKey,
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
                                      'Teacher Details',
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
                                              return 'Please select Teacher Name';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              context.read<TeacherCubit>().onInstructorNameChange(_TeacherNameController.text);
                                            });
                                          },
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          controller: _TeacherNameController,
                                          // validator:
                                          //     checkNumbersOnlyValidation,
                                          decoration: InputDecoration(
                                            labelText: 'Teacher Name',
                                          ),
                                        ),
                                      ),
                                      // Column(
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     Text('  Gender'),
                                      //     Padding(
                                      //       padding: mediumPadding,
                                      //       child: DropdownButtonFormField(
                                      //         validator: (value) {
                                      //           if (value == null || value.isEmpty) {
                                      //             return 'Please select your Gender';
                                      //           }
                                      //           return null;
                                      //         },
                                      //         decoration: const InputDecoration(
                                      //           //  enabledBorder: OutlineInputBorder( //<-- SEE HERE
                                      //           //   // borderSide: BorderSide(color: Colors.black, width: 2),
                                      //           //  ),
                                      //           //  focusedBorder: OutlineInputBorder( //<-- SEE HERE
                                      //           //  //  borderSide: BorderSide(color: Colors.black, width: 2),
                                      //           //  ),
                                      //           filled: true,
                                      //           // fillColor: Colors.greenAccent,
                                      //         ),
                                      //         // dropdownColor: Colors.greenAccent,
                                      //         value: _genderlist,
                                      //         onChanged: (String? status) {
                                      //           setState(() {
                                      //             _genderlist = status;
                                      //             context.read<TeacherCubit>().onInstructorgenderChange(_genderlist);
                                      //           });
                                      //         },

                                      //         items: genderlist.map<DropdownMenuItem<String>>((String value) {
                                      //           return DropdownMenuItem<String>(
                                      //             value: value,
                                      //             child: Text(
                                      //               value,
                                      //               style: const TextStyle(
                                      //                 fontSize: 14,
                                      //               ),
                                      //             ),
                                      //           );
                                      //         }).toList(),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      if (employeeLoading)
                                        const CircularProgressIndicator()
                                      else
                                        employeeEntries != null && employeeEntries!.data!.isNotEmpty
                                            ? Padding(
                                                padding: EdgeInsets.only(top: eightPadding, left: twelvePadding),
                                                child: DropdownMenu<Employee>(
                                                  width: SizeConfig.blockSizeHorizontal! * 46.10,
                                                  //initialSelection:
                                                  // ,
                                                  controller: _employeeController,
                                                  label: const Text('Employee'),
                                                  inputDecorationTheme: const InputDecorationTheme(filled: true),
                                                  dropdownMenuEntries: employeeEntries!.data!
                                                      .map(
                                                        (e) => DropdownMenuEntry<Employee>(
                                                          value: e,
                                                          label: e.name ?? 'no employee',
                                                        ),
                                                      )
                                                      .toList(),
                                                  onSelected: (Employee? employee) {
                                                    setState(() {
                                                      selectedEmployee = employee;
                                                      context.read<TeacherCubit>().onInstructorEmployeeChange(selectedEmployee);
                                                    });
                                                  },
                                                ),
                                              )
                                            : Text('no employee'),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('   Status'),
                                          Padding(
                                            padding: mediumPadding,
                                            child: DropdownButtonFormField(
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please select your Status';
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
                                              value: _Statuslist,
                                              onChanged: (String? status) {
                                                setState(() {
                                                  _Statuslist = status;
                                                  context.read<TeacherCubit>().onInstructorStatusChange(_Statuslist);
                                                });
                                              },

                                              items: statuslist.map<DropdownMenuItem<String>>((String value) {
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
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0, twenty4Padding, 0, 0),
                                            child: ElevatedButton(
                                              //  style: style,
                                              onPressed: () {
                                                if (formKey.currentState!.validate()) {
                                                  context.read<TeacherCubit>().onPostInstructorList();
                                                }
                                              },
                                              child: const Text('Submit'),
                                            ),
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.fromLTRB(0, twenty4Padding, 0, 0),
                                          //   child: InkWell(
                                          //     onTap: () {
                                          //       if (formKey.currentState!.validate()) {
                                          //         context.read<TeacherCubit>().onPostInstructorList();
                                          //       }
                                          //     },
                                          //     child: Card(
                                          //       shape: RoundedRectangleBorder(
                                          //         borderRadius: BorderRadius.circular(4.0), //<-- SEE HERE
                                          //       ),
                                          //       child: Padding(
                                          //         padding: mediumPadding,
                                          //         child: Column(
                                          //           children: [
                                          //             Text(
                                          //               '    Submit    ',
                                          //               style: const TextStyle(
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
                                          children: [
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
                                              padding: const EdgeInsets.only(
                                                left: sixteenPadding,
                                                top: sixteenPadding,
                                              ),
                                              child: Text('bulkUpload'),
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

                                        //   Card(
                                        //     // margin: const EdgeInsets.fromLTRB(
                                        //     //   fiftyPadding,
                                        //     //   sixPadding,
                                        //     //   fiftyPadding,
                                        //     //   sixPadding,
                                        //     // ),
                                        //  //   color: pastelGrey,
                                        //     child: Padding(
                                        //       padding: mediumPadding,
                                        //       child: Row(
                                        //         children: [

                                        //           Column(
                                        //             // mainAxisAlignment: MainAxisAlignment.center,
                                        //             // mainAxisSize: MainAxisSize.min,
                                        //             children: [
                                        //               Padding(
                                        //                 padding: mediumPadding,
                                        //                 child: Row(
                                        //                   mainAxisAlignment: MainAxisAlignment.center,
                                        //                   children: [
                                        //                     FilledButton.icon(
                                        //                       onPressed: () async {
                                        //                         await pickAFile();
                                        //                         setState(() {});
                                        //                       },
                                        //                       icon: fileUploading
                                        //                           ? SizedBox(
                                        //                               width: SizeConfig.blockSizeHorizontal! * 2,
                                        //                               height: SizeConfig.blockSizeHorizontal! * 2,
                                        //                               child: Center(
                                        //                                 child: CircularProgressIndicator(
                                        //                                   color: darkSoftRedAlert,
                                        //                                 ),
                                        //                               ),
                                        //                             )
                                        //                           : const Icon(Icons.upload_file),
                                        //                       label: Text(
                                        //                         _result != null && _result!.files.first.name.isNotEmpty
                                        //                             ? _result!.files.first.name
                                        //                             : '$bulkUpload $staffDetails',
                                        //                       ),
                                        //                     ),
                                        //                     if (_result != null && _result!.files.first.name.isNotEmpty)
                                        //                       TextButton(
                                        //                           onPressed: () {
                                        //                             //    _result!.files.clear();
                                        //                             setState(() {});
                                        //                           },
                                        //                           child: const Text(clear),)
                                        //                     else
                                        //                       const SizedBox()
                                        //                   ],
                                        //                 ),
                                        //               ),
                                        //               if (_result != null && _result!.files.first.name.isNotEmpty)
                                        //                 Padding(
                                        //                   padding: mediumPadding,
                                        //                   child: ElevatedButton(
                                        //                     child: const Text(upload),
                                        //                     onPressed: () {
                                        //                       if (kIsWeb) {
                                        //                         final fileWeb = _result!.files.first.bytes!;
                                        //                         final fileName = _result!.files.first.name;
                                        //                         context.read<AdminCubit>().postDataImport(
                                        //                               fileWeb,
                                        //                               fileName,
                                        //                               employee,
                                        //                             );
                                        //                       } else {
                                        //                         //  context.read<StudentCubit>().uploadFile();
                                        //                       }
                                        //                     },
                                        //                   ),
                                        //                 )
                                        //               else
                                        //                 const SizedBox(),
                                        //               if (jsonStrings != null && jsonStrings!.isNotEmpty)
                                        //                 SizedBox(
                                        //                     height: SizeConfig.blockSizeVertical! * 20,
                                        //                     child: ListView(
                                        //                       children: List.generate(
                                        //                         jsonStrings!.length,
                                        //                         (index) => Text(
                                        //                           jsonStrings!.elementAt(index),
                                        //                         ),
                                        //                       ),
                                        //                     ),).animate().fadeIn()
                                        //               else
                                        //                 const SizedBox()
                                        //             ],
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ),
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

import 'dart:convert';

import 'package:admin/adminrepo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:schoolezy/pages/admin/cubit/admin_cubit.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/student/cubit/student_cubit.dart';
import 'package:schoolezy/utility/apppadding.dart';
import 'package:schoolezy/utility/constant.dart';
import 'package:schoolezy/utility/sizeconfig.dart';
import 'package:universal_html/html.dart' as html;
import 'package:user/userrepo.dart';

class WebStudentPageDetailSetup extends StatefulWidget {
  const WebStudentPageDetailSetup({super.key});

  @override
  State<WebStudentPageDetailSetup> createState() => _WebStudentPageDetailSetupState();
}

class _WebStudentPageDetailSetupState extends State<WebStudentPageDetailSetup> {
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
  TextEditingController _DateOfBirthController = TextEditingController();
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _NameController = TextEditingController();
  TextEditingController _AddressLine1Controller = TextEditingController();
  TextEditingController _AddressLine2Controller = TextEditingController();
  TextEditingController _GenderController = TextEditingController();
  TextEditingController _GuardianController = TextEditingController();
  TextEditingController _MobilenumController = TextEditingController();
  TextEditingController _SiblingController = TextEditingController();

  TextEditingController _ClassController = TextEditingController();
  TextEditingController _SectionController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  // List<String> genderlist = [
  //   'Female',
  //   'Genderqueer',
  //   'Male',
  //   'Non-conforming',
  //   'Other',
  //   'Prefer not to say',
  //   'Transgender',

  // ];

  String? _selectedgender;
  @override
  void didChangeDependencies() {
    context.read<AdminCubit>().getPrograms();
    context.read<AdminCubit>().getSection();
    // context.read<AdminCubit>().getStudent();

    super.didChangeDependencies();
  }

  bool sectionLoading = false;
  NameOnly? selectedSection;
  List<NameOnly>? section;

  bool programLoading = false;
  NameOnly? selectedProgram;
  List<NameOnly>? program;

  //final List<DropdownMenuEntry<NameOnly>> programEntries = <DropdownMenuEntry<NameOnly>>[];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final brightness = Theme.of(context).brightness;
    return BlocListener<StudentCubit, StudentState>(
      listener: (context, state) {
        if (state is UploadFileStatus) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(fileUploadSuccess)));
        }

        if (state.status == FormzSubmissionStatus.success) {
          context.pop();
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
          if (state is ProgramImportCheck) {
            bool programLoading = true;
          } else if (state is ProgramImportAdminFailure) {
            bool programLoading = false;
          } else if (state is ProgramImportSuccess) {
            program = state.programs;
            programLoading = false;
            // //  final List<DropdownMenuEntry<NameOnly>> programEntries = <DropdownMenuEntry<NameOnly>>[];
            // //final programEntries = <DropdownMenuEntry<NameOnly>>[];
            // for (final ClassStudent in state.programs!) {
            //   programEntries.add(
            //     DropdownMenuEntry<NameOnly>(
            //       value: ClassStudent,
            //       label: ClassStudent.name.toString(),
            //     ),
            //   );
            // }
          }

          if (state is SectionImportLoading) {
            bool sectionLoading = true;
          } else if (state is SectionImportFailure) {
            bool sectionLoading = false;
          } else if (state is SectionImportSuccess) {
            section = state.section;
            sectionLoading = false;
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
                  key: _formkey,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: twenty4Padding),
                              child: Text(
                                studentDetails,
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
                                        return 'Please enter Student Name';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        context.read<StudentCubit>().onStudentNameChange(_NameController.text);
                                      });
                                    },
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    controller: _NameController,
                                    // validator:
                                    //     checkNumbersOnlyValidation,
                                    decoration: InputDecoration(
                                      labelText: 'Student Name',
                                    ),
                                  ),
                                ),

                                if (sectionLoading)
                                  const CircularProgressIndicator()
                                else
                                  section != null && section!.isNotEmpty
                                      ? Padding(
                                          padding: mediumPadding,
                                          child: DropdownMenu<NameOnly>(
                                            width: SizeConfig.blockSizeHorizontal! * 46,
                                            //initialSelection:
                                            // ,
                                            controller: _ClassController,
                                            label: const Text('Class'),
                                            inputDecorationTheme: const InputDecorationTheme(filled: true),
                                            dropdownMenuEntries: program!
                                                .map(
                                                  (e) => DropdownMenuEntry<NameOnly>(
                                                    value: e,
                                                    label: e.name ?? 'no Teachers',
                                                  ),
                                                )
                                                .toList(),
                                            onSelected: (NameOnly? program) {
                                              setState(() {
                                                selectedProgram = program;
                                                context.read<StudentCubit>().onclassChange(selectedProgram);
                                              });
                                            },
                                          ),
                                        )
                                      : Text('no Class'),

                                if (sectionLoading)
                                  const CircularProgressIndicator()
                                else
                                  section != null && section!.isNotEmpty
                                      ? Padding(
                                          padding: mediumPadding,
                                          child: DropdownMenu<NameOnly>(
                                            width: SizeConfig.blockSizeHorizontal! * 46,
                                            //initialSelection:
                                            // ,
                                            controller: _SectionController,
                                            label: const Text('Section'),
                                            dropdownMenuEntries: section!
                                                .map(
                                                  (e) => DropdownMenuEntry<NameOnly>(
                                                    value: e,
                                                    label: e.name ?? 'no Teachers',
                                                  ),
                                                )
                                                .toList(),
                                            inputDecorationTheme: const InputDecorationTheme(filled: true),
                                            onSelected: (NameOnly? programs) {
                                              setState(() {
                                                selectedSection = programs;
                                                context.read<StudentCubit>().onsectionChange(selectedSection);
                                              });
                                            },
                                          ),
                                        )
                                      : Text('no Section'),

                                Padding(
                                  padding: mediumPadding,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter DateOfBirth';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                          context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2101));

                                      if (pickedDate != null) {
                                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

                                        setState(() {
                                          _DateOfBirthController.text = formattedDate; //set output date to TextField value.
                                          context.read<StudentCubit>().onDateOfBirthChange(_DateOfBirthController.text);
                                        });
                                      } else {}
                                      // setState(() {});
                                      // context.read<StudentCubit>().onDateOfBirthChange(_DateOfBirthController.text);
                                    },
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    controller: _DateOfBirthController,
                                    // validator:
                                    //     checkNumbersOnlyValidation,
                                    decoration: InputDecoration(
                                      labelText: 'DateOfBirth',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: mediumPadding,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                        return 'Email';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onChanged: (value) {
                                      setState(() {});
                                      context.read<StudentCubit>().onEmailIDChange(_EmailController.text);
                                    },
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    controller: _EmailController,
                                    // validator:
                                    //     checkNumbersOnlyValidation,
                                    decoration: InputDecoration(
                                      labelText: 'E-Mail',
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: mediumPadding,
                                  child: TextFormField(
                                    maxLength: 10,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Mobile Number';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onChanged: (value) {
                                      setState(() {});
                                      context.read<StudentCubit>().onMobileChange(_MobilenumController.text);
                                    },
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    controller: _MobilenumController,
                                    // validator:
                                    //     checkNumbersOnlyValidation,
                                    decoration: InputDecoration(
                                      labelText: 'Mobile Number',
                                    ),
                                  ),
                                ),

                                //            Padding(
                                //   padding: mediumPadding,
                                //   child: TextFormField(
                                //     onChanged: (value){
                                //       setState(() {

                                //       });
                                //       context.read<StudentCubit>().onGenderChange(_GenderController.text);
                                //     },
                                //     autovalidateMode:
                                //         AutovalidateMode
                                //             .onUserInteraction,
                                //     controller:_GenderController,
                                //     // validator:
                                //     //     checkNumbersOnlyValidation,
                                //     decoration:
                                //         InputDecoration(

                                //       labelText:
                                //           'Gender',
                                //      ),
                                //   ),
                                // ),

                                Padding(
                                  padding: mediumPadding,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter AddressLine1';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        context.read<StudentCubit>().onAddressChange(_AddressLine1Controller.text);
                                      });
                                    },
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    controller: _AddressLine1Controller,
                                    // validator:
                                    //     checkNumbersOnlyValidation,
                                    decoration: InputDecoration(
                                      labelText: 'AddressLine1',
                                    ),
                                  ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('  Gender'),
                                    Padding(
                                      padding: mediumPadding,
                                      child: DropdownButtonFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter Gender';
                                          } else {
                                            return null;
                                          }
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
                                        value: _selectedgender,
                                        onChanged: (String? gender) {
                                          setState(() {
                                            _selectedgender = gender;
                                            context.read<StudentCubit>().onGenderChange(_selectedgender);
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        //  style: style,
                                        onPressed: () {
                                          if (_formkey.currentState!.validate()) {
                                            // setState(() {
                                            //   context.read<StudentCubit>().onPostStudentList();
                                            // });
                                          }
                                        },
                                        child: const Text('Submit'),
                                      ),
                                    ),
                                    //         Padding(
                                    //    padding: const EdgeInsets.fromLTRB(0, twenty4Padding, 0, 0),
                                    //    child: InkWell(
                                    //      onTap: (){
                                    //       if(_formkey.currentState!.validate()){
                                    //            setState(() {
                                    //         context.read<StudentCubit>().onPostStudentList();
                                    //       });

                                    //       }

                                    //      },
                                    //      child: Card(
                                    //      shape: RoundedRectangleBorder(
                                    //        borderRadius: BorderRadius.circular(4.0), //<-- SEE HERE
                                    //      ),
                                    //      child: Padding(
                                    //        padding: mediumPadding,
                                    //        child: Column(
                                    //      children: [
                                    //        Text(
                                    //          '    Submit    ',
                                    //          style: const TextStyle(
                                    //            fontWeight: FontWeight.bold,
                                    //          ),
                                    //        ),

                                    //      ],
                                    //        ),
                                    //      ),
                                    //     ),
                                    //    ),
                                    //  ),
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
                          child: Material(
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row(
                                //   children: [
                                // const Expanded(
                                //   child: Padding(
                                //     padding: EdgeInsets.fromLTRB(
                                //       fiftyPadding,
                                //       sixPadding,
                                //       fiftyPadding,
                                //       sixPadding,
                                //     ),
                                // child:
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(sixteenPadding, twelvePadding, 0, 0),
                                  child: Text(bulkUpload),
                                ),
                                // Text(uploadStudentDetails),
                                //   ),
                                // ),
                                //     Padding(
                                //       padding: const EdgeInsets.fromLTRB(
                                //         sixPadding,
                                //         sixPadding,
                                //         fiftyPadding,
                                //         sixPadding,
                                //       ),
                                //       child: Card(
                                //         color: brightness == Brightness.light ? lightSoftRedAlert : darkSoftRedAlert,
                                //         child: Row(
                                //           children: [
                                //             const Padding(
                                //               padding: mediumPadding,
                                //               child: Text('Single student can be added later!'),
                                //             ),
                                //             LineIcon(LineIcons.exclamationCircle)
                                //           ],
                                //         ),
                                //       )
                                //           .animate(delay: 600.ms)
                                //           // .fade()
                                //           .scale(
                                //             begin: const Offset(1, 10),
                                //           )
                                //       // .move(
                                //       //   begin: const Offset(5, 0),
                                //       //   delay: 300.ms,
                                //       //   duration: 600.ms,
                                //       // ) // runs after the above w/new duration
                                //       ,
                                //     )
                                //   ],
                                // ),
                                // Expanded(
                                // child:
                                DecoratedBox(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        'images/cloud.jpg',
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: smallPadding,
                                    child: Column(
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Padding(
                                        //   padding: largePadding,
                                        //   child: Align(
                                        //     alignment: Alignment.topRight,
                                        //     child: FilledButton.icon(
                                        //       icon: fileDownloading
                                        //           ? const Center(
                                        //               child: CircularProgressIndicator(),
                                        //             )
                                        //           : const Icon(Icons.download),
                                        //       onPressed: () => context.read<StudentCubit>().downloadTemplateFile(),
                                        //       label: const Text(downloadTemplate),
                                        //     ),
                                        //   ),
                                        // ),
                                        //  Expanded(
                                        //  child:

                                        // Column(
                                        //   mainAxisAlignment: MainAxisAlignment.center,
                                        //   children: [
                                        // if (fileUploading)
                                        //   SizedBox(
                                        //     width: SizeConfig.blockSizeHorizontal! * 2,
                                        //     height: SizeConfig.blockSizeHorizontal! * 2,
                                        //     child: Center(
                                        //       child: CircularProgressIndicator(
                                        //         color: darkSoftRedAlert,
                                        //       ),
                                        //     ),
                                        //   )
                                        // else
                                        //   const Icon(Icons.cloud_upload_rounded),

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
                                                  children: [
                                                    FilledButton.icon(
                                                      onPressed: () async {
                                                        await pickAFile();
                                                        setState(() {});
                                                      },
                                                      icon: fileUploading
                                                          ? const Center(
                                                              child: CircularProgressIndicator(),
                                                            )
                                                          : const SizedBox(),
                                                      label: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.cloud_upload_rounded,
                                                          ),
                                                          Text(
                                                            _result != null && _result!.files.first.name.isNotEmpty
                                                                ? _result!.files.first.name
                                                                : 'Upload',
                                                            // $student',
                                                          ),
                                                        ],
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
                                            ),
                                          ),
                                        ),

                                        //  Card(
                                        //        shape: RoundedRectangleBorder(
                                        //       borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                                        //     ),
                                        //    child: Padding(
                                        //      padding:smallPadding,
                                        //      child: Row(
                                        //        mainAxisAlignment: MainAxisAlignment.center,
                                        //        children: [
                                        //          Padding(
                                        //           padding: extraxxLargePadding,
                                        //            child: FilledButton.icon(
                                        //              onPressed: () async {
                                        //                await pickAFile();
                                        //                setState(() {});
                                        //              },
                                        //              icon: fileUploading
                                        //                  ? const Center(
                                        //                      child: CircularProgressIndicator(),
                                        //                    )
                                        //                  : const SizedBox(),
                                        //              label: Text(
                                        //                _result != null && _result!.files.first.name.isNotEmpty
                                        //                    ? _result!.files.first.name
                                        //                    : '$bulkUpload',
                                        //                    // $student',
                                        //              ),
                                        //            ),
                                        //          ),
                                        //          if (_result != null && _result!.files.first.name.isNotEmpty)
                                        //            TextButton(
                                        //              onPressed: () {
                                        //                //    _result!.files.clear();
                                        //                setState(() {});
                                        //              },
                                        //              child: const Text(clear),
                                        //            )
                                        //          else
                                        //            const SizedBox()
                                        //        ],
                                        //      ),
                                        //    ),
                                        //  ),
                                        //   ],
                                        // ),
                                        //  ),
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
                                                        student,
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
                                            width: SizeConfig.blockSizeHorizontal! * 20,
                                            child: ListView(
                                              children: List.generate(
                                                jsonStrings!.length,
                                                (index) => Html(
                                                  data: jsonStrings!.elementAt(index),
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
                                //  ),

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
                                        //  child: Column(
                                        //   mainAxisAlignment: MainAxisAlignment.center,
                                        //  children: [
                                        //  FilledButton.icon(
                                        //    onPressed: () async {
                                        //      await pickAFile();
                                        //      setState(() {});
                                        //    },
                                        //    icon: fileUploading
                                        //        ? const Center(
                                        //            child: CircularProgressIndicator(),
                                        //          )
                                        //        : const SizedBox(),
                                        //    label: Row(

                                        //      children: [
                                        //       Icon(Icons.cloud_upload_rounded,),
                                        //        Text(
                                        //          _result != null && _result!.files.first.name.isNotEmpty
                                        //              ? _result!.files.first.name
                                        //              : 'Upload',
                                        //              // $student',
                                        //        ),
                                        //      ],
                                        //    ),
                                        //  ),
                                        //  if (_result != null && _result!.files.first.name.isNotEmpty)
                                        //  TextButton(
                                        //    onPressed: () {
                                        //      //    _result!.files.clear();
                                        //      setState(() {});
                                        //    },
                                        //    child: const Text(clear),
                                        //  )
                                        //  else
                                        //  const SizedBox()

                                        //         ],
                                        //           ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
    );
  }

  Future<FilePickerResult?> pickAFile() async {
    return _result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx', 'csv'],
    );
  }
}

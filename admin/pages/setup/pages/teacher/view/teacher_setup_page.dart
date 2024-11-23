// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_final_fields, prefer_int_literals, unused_local_variable, unused_import, inference_failure_on_instance_creation, unnecessary_lambdas

import 'package:admin/adminrepo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:schoolezy/pages/admin/admin.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/classroom/cubit/classroom_cubit.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/school/school.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/teacher/page/teacher_setupdetail_page.dart';
import 'package:schoolezy/utility/appcolors.dart';
import 'package:schoolezy/utility/apppadding.dart';
import 'package:schoolezy/utility/constant.dart';
import 'package:schoolezy/utility/sizeconfig.dart';
import 'package:user/userrepo.dart';

enum SchoolScheme { none, male, female }

class TeacherSetupPage extends StatefulWidget {
  const TeacherSetupPage({super.key});

  @override
  State<TeacherSetupPage> createState() => _TeacherSetupPageState();
}

class _TeacherSetupPageState extends State<TeacherSetupPage> {
  FilePickerResult? _result;
  bool checkedValue = false;
  SchoolScheme? schoolScheme = SchoolScheme.none;
  bool fileUploading = false;
  ImportLogs? importLogs;
  List<String>? jsonStrings = [];

  TextEditingController _StaffController = TextEditingController();

  Teachers? teachers;
  bool teachersLoading = false;

  String? query;
  List<String> bh = [];

  //  List<String>? suggestion;

  @override
  void initState() {
    // bh = suggestion!;

    super.initState();
  }

  void Searchbook(String query) {
    final suggestion = teachers!.data!.where((element) {
      final name = element.name!.toLowerCase();

      final input = query.toLowerCase();

      return name.contains(input);
    }).toList();
    setState(() {
      // this.query = query;
      // this.suggestion = suggestion;

      bh = suggestion.cast<String>();
    });
  }

  @override
  void didChangeDependencies() {
    context.read<ClassroomCubit>().getTeachers();
    // context.read<StudentCubit>().onPostStudentList();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final brightness = Theme.of(context).brightness;

    return BlocListener<SchoolCubit, SchoolState>(
      listener: (context, state) {
        // if (state is SchoolFailure) {
        //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('failed to load pictures')));
        // }
      },
      child: BlocListener<AdminCubit, AdminState>(
        listener: (context, state) {},
        child: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            if (state is UploadFileLoading) {
              fileUploading = true;
            }
            // if (state is UploadFileStatus) {
            //   uploadFileSuccess = state.uploadFileSuccess;
            //   debugPrint(uploadFileSuccess!.message!.file_url);
            //   fileUploading = false;
            // }
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
            return BlocBuilder<ClassroomCubit, ClassroomState>(
              builder: (context, state) {
                if (state is ClassroomAddTeachers) {
                  if (state.teachers!.data!.isNotEmpty) {
                    teachers = state.teachers;
                  }
                  teachersLoading = false;
                }

                return BlocBuilder<SchoolCubit, SchoolState>(
                  builder: (context, state) {
                    // if (state is SchoolPictures) {
                    //   _result = state.result;
                    // }

                    return Scaffold(
                      body: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: sixPadding, top: twenty4Padding),
                                  child: Text(
                                    'Teacher Details',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: sixPadding),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Teacher'),
                                          SizedBox(
                                            width: SizeConfig.blockSizeHorizontal! * 30,
                                            child: TextFormField(
                                              controller: _StaffController,
                                              onChanged: (value) => Searchbook(value),
                                              decoration: InputDecoration(
                                                  prefixIcon: IconButton(
                                                    icon: Icon(Icons.search),
                                                    onPressed: () {
                                                      setState(() {});
                                                      Searchbook;
                                                    },
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(Icons.filter_list),
                                                    onPressed: () {},
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, twenty4Padding, 0, 0),
                                      child: ElevatedButton(
                                        //  style: style,
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => WebTeacherPageDetailSetup()));
                                        },
                                        child: const Text('NEW'),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.fromLTRB(0, twenty4Padding, 0, 0),
                                    //   child: InkWell(
                                    //     onTap: () {
                                    //       Navigator.push(context, MaterialPageRoute(builder: (context) => WebTeacherPageDetailSetup()));
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
                                    //               '    NEW    ',
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
                                ),
                                if (teachersLoading || teachers == null)
                                  const Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: oneFiftyPadding),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                else
                                  (teachers == null && teachers!.data!.isEmpty)
                                      ? const Center(child: Text(noData))
                                      : Expanded(
                                          child: ListView.separated(
                                            separatorBuilder: (context, index) => const Divider(),
                                            itemCount: teachers!.data!.length,
                                            itemBuilder: (BuildContext context, index) {
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: largePadding,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              '${teachers!.data!.elementAt(index).name}',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${teachers!.data!.elementAt(index).employee}',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              '${teachers!.data!.elementAt(index).gender}',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${teachers!.data!.elementAt(index).status}',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
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

                          // Expanded(
                          //   flex: 4,
                          //   child: IgnorePointer(
                          //     ignoring: false,
                          //     child: Center(
                          //       child: Column(
                          //         children: [
                          //           Row(
                          //             children: [
                          //               const Expanded(
                          //                 child: Padding(
                          //                   padding: EdgeInsets.fromLTRB(
                          //                     fiftyPadding,
                          //                     twenty4Padding,
                          //                     hunderedPadding,
                          //                     twelvePadding,
                          //                   ),
                          //                   child: Text(staffDetails),
                          //                 ),
                          //               ),
                          //               Padding(
                          //                 padding: const EdgeInsets.fromLTRB(
                          //                   sixPadding,
                          //                   twenty4Padding,
                          //                   fiftyPadding,
                          //                   twelvePadding,
                          //                 ),
                          //                 child: Card(
                          //                   color: brightness == Brightness.light ? lightSoftRedAlert : darkSoftRedAlert,
                          //                   child: Row(
                          //                     children: [
                          //                       const Padding(
                          //                         padding: mediumPadding,
                          //                         child: Text('Data will be auto saved!'),
                          //                       ),
                          //                       LineIcon(LineIcons.exclamationCircle)
                          //                     ],
                          //                   ),
                          //                 ),
                          //               )
                          //             ],
                          //           ),
                          //           Expanded(
                          //             child: Card(
                          //               margin: const EdgeInsets.fromLTRB(
                          //                 fiftyPadding,
                          //                 sixPadding,
                          //                 fiftyPadding,
                          //                 sixPadding,
                          //               ),
                          //               color: pastelGrey,
                          //               child: Padding(
                          //                 padding: mediumPadding,
                          //                 child: Row(
                          //                   children: [
                          //                     // Expanded(
                          //                     //   flex: 7,
                          //                     //   child: ListView(
                          //                     //     children: [
                          //                     //       // Row(
                          //                     //       //   children: [
                          //                     //       //     const Spacer(),
                          //                     //       //     TextButton.icon(
                          //                     //       //       icon: const Icon(
                          //                     //       //         Icons.edit,
                          //                     //       //         size: 14,
                          //                     //       //       ),
                          //                     //       //       onPressed: () {},
                          //                     //       //       label: const Text(edit),
                          //                     //       //     ),
                          //                     //       //   ],
                          //                     //       // ),

                          //                     //       Padding(
                          //                     //         padding: mediumPadding,
                          //                     //         child: Wrap(
                          //                     //           spacing: 10,
                          //                     //           runSpacing: 8,
                          //                     //           children: [
                          //                     //             Column(
                          //                     //               crossAxisAlignment:
                          //                     //                   CrossAxisAlignment.start,
                          //                     //               children: [
                          //                     //                 Icon(
                          //                     //                   Icons.emergency_rounded,
                          //                     //                   size: 10,
                          //                     //                   color: brightness ==
                          //                     //                           Brightness.light
                          //                     //                       ? lightSoftRedAlert
                          //                     //                       : darkSoftRedAlert,
                          //                     //                 ),
                          //                     //                 const Padding(
                          //                     //                   padding: mediumPadding,
                          //                     //                   child: TextField(
                          //                     //                     maxLength: 50,
                          //                     //                     decoration:
                          //                     //                         InputDecoration(
                          //                     //                       hintText: staffName,
                          //                     //                     ),
                          //                     //                   ),
                          //                     //                 ),
                          //                     //               ],
                          //                     //             ),
                          //                     //             Column(
                          //                     //               crossAxisAlignment:
                          //                     //                   CrossAxisAlignment.start,
                          //                     //               children: [
                          //                     //                 Icon(
                          //                     //                   Icons.emergency_rounded,
                          //                     //                   size: 10,
                          //                     //                   color: brightness ==
                          //                     //                           Brightness.light
                          //                     //                       ? lightSoftRedAlert
                          //                     //                       : darkSoftRedAlert,
                          //                     //                 ),
                          //                     //                 SizedBox(
                          //                     //                     width: SizeConfig
                          //                     //                             .blockSizeHorizontal! *
                          //                     //                         20,
                          //                     //                     child: const TextField(
                          //                     //                       decoration:
                          //                     //                           InputDecoration(
                          //                     //                         hintText: mobileNo,
                          //                     //                       ),
                          //                     //                     )),
                          //                     //               ],
                          //                     //             ),
                          //                     //             Column(
                          //                     //               crossAxisAlignment:
                          //                     //                   CrossAxisAlignment.start,
                          //                     //               children: [
                          //                     //                 const SizedBox(
                          //                     //                   width: 10,
                          //                     //                   height: 10,
                          //                     //                 ),
                          //                     //                 SizedBox(
                          //                     //                     width: SizeConfig
                          //                     //                             .blockSizeHorizontal! *
                          //                     //                         20,
                          //                     //                     child: const TextField(
                          //                     //                       decoration:
                          //                     //                           InputDecoration(
                          //                     //                         hintText:
                          //                     //                             buildingNo,
                          //                     //                       ),
                          //                     //                     )),
                          //                     //               ],
                          //                     //             ),
                          //                     //             Column(
                          //                     //               crossAxisAlignment:
                          //                     //                   CrossAxisAlignment.start,
                          //                     //               children: [
                          //                     //                 const SizedBox(
                          //                     //                   width: 10,
                          //                     //                   height: 10,
                          //                     //                 ),
                          //                     //                 SizedBox(
                          //                     //                     width: SizeConfig
                          //                     //                             .blockSizeHorizontal! *
                          //                     //                         20,
                          //                     //                     child: const TextField(
                          //                     //                       decoration:
                          //                     //                           InputDecoration(
                          //                     //                         hintText:
                          //                     //                             streetName,
                          //                     //                       ),
                          //                     //                     )),
                          //                     //               ],
                          //                     //             ),
                          //                     //             Column(
                          //                     //               crossAxisAlignment:
                          //                     //                   CrossAxisAlignment.start,
                          //                     //               children: [
                          //                     //                 const SizedBox(
                          //                     //                   width: 10,
                          //                     //                   height: 10,
                          //                     //                 ),
                          //                     //                 SizedBox(
                          //                     //                     width: SizeConfig
                          //                     //                             .blockSizeHorizontal! *
                          //                     //                         20,
                          //                     //                     child: const TextField(
                          //                     //                       decoration:
                          //                     //                           InputDecoration(
                          //                     //                         hintText: areaa,
                          //                     //                       ),
                          //                     //                     )),
                          //                     //               ],
                          //                     //             ),
                          //                     //             Column(
                          //                     //               crossAxisAlignment:
                          //                     //                   CrossAxisAlignment.start,
                          //                     //               children: [
                          //                     //                 const SizedBox(
                          //                     //                   width: 10,
                          //                     //                   height: 10,
                          //                     //                 ),
                          //                     //                 SizedBox(
                          //                     //                     width: SizeConfig
                          //                     //                             .blockSizeHorizontal! *
                          //                     //                         20,
                          //                     //                     child: const TextField(
                          //                     //                       decoration:
                          //                     //                           InputDecoration(
                          //                     //                         hintText: stateName,
                          //                     //                       ),
                          //                     //                     )),
                          //                     //               ],
                          //                     //             ),
                          //                     //             Column(
                          //                     //               crossAxisAlignment:
                          //                     //                   CrossAxisAlignment.start,
                          //                     //               children: [
                          //                     //                 const SizedBox(
                          //                     //                   width: 10,
                          //                     //                   height: 10,
                          //                     //                 ),
                          //                     //                 SizedBox(
                          //                     //                     width: SizeConfig
                          //                     //                             .blockSizeHorizontal! *
                          //                     //                         20,
                          //                     //                     child: const TextField(
                          //                     //                       decoration:
                          //                     //                           InputDecoration(
                          //                     //                         hintText: pinCode,
                          //                     //                       ),
                          //                     //                     )),
                          //                     //               ],
                          //                     //             ),
                          //                     //             Column(
                          //                     //               crossAxisAlignment:
                          //                     //                   CrossAxisAlignment.start,
                          //                     //               children: [
                          //                     //                 const SizedBox(
                          //                     //                   width: 10,
                          //                     //                   height: 10,
                          //                     //                 ),
                          //                     //                 SizedBox(
                          //                     //                     width: SizeConfig
                          //                     //                             .blockSizeHorizontal! *
                          //                     //                         20,
                          //                     //                     child: const TextField(
                          //                     //                       decoration:
                          //                     //                           InputDecoration(
                          //                     //                         hintText:
                          //                     //                             altcontanctNo,
                          //                     //                       ),
                          //                     //                     )),
                          //                     //               ],
                          //                     //             ),
                          //                     //           ],
                          //                     //         ),
                          //                     //       ),
                          //                     //       Row(
                          //                     //         children: [
                          //                     //           SizedBox(
                          //                     //             width: SizeConfig
                          //                     //                     .blockSizeHorizontal! *
                          //                     //                 20,
                          //                     //             child:
                          //                     //                 RadioListTile<SchoolScheme>(
                          //                     //               title: Text(
                          //                     //                 male,
                          //                     //                 style: Theme.of(context)
                          //                     //                     .textTheme
                          //                     //                     .bodyMedium,
                          //                     //               ),
                          //                     //               value: SchoolScheme.male,
                          //                     //               activeColor:
                          //                     //                   softLightRedAlert,
                          //                     //               groupValue: schoolScheme,
                          //                     //               onChanged:
                          //                     //                   (SchoolScheme? value) {
                          //                     //                 setState(() {
                          //                     //                   schoolScheme = value;
                          //                     //                   debugPrint(schoolScheme
                          //                     //                       .toString());
                          //                     //                 });
                          //                     //               },
                          //                     //             ),
                          //                     //           ),
                          //                     //           SizedBox(
                          //                     //             width: SizeConfig
                          //                     //                     .blockSizeHorizontal! *
                          //                     //                 20,
                          //                     //             child:
                          //                     //                 RadioListTile<SchoolScheme>(
                          //                     //               activeColor:
                          //                     //                   softLightRedAlert,
                          //                     //               title: Text(
                          //                     //                 female,
                          //                     //                 style: Theme.of(context)
                          //                     //                     .textTheme
                          //                     //                     .bodyMedium,
                          //                     //               ),
                          //                     //               value: SchoolScheme.female,
                          //                     //               groupValue: schoolScheme,
                          //                     //               onChanged:
                          //                     //                   (SchoolScheme? value) {
                          //                     //                 setState(() {
                          //                     //                   schoolScheme = value;
                          //                     //                 });
                          //                     //               },
                          //                     //             ),
                          //                     //           ),
                          //                     //         ],
                          //                     //       )

                          //                     //       // Padding(
                          //                     //       //   padding: mediumPadding,
                          //                     //       //   child: SizedBox(
                          //                     //       //       width: SizeConfig.blockSizeHorizontal! * 30,
                          //                     //       //       height: SizeConfig.blockSizeHorizontal! * 20,
                          //                     //       //       child: Card(
                          //                     //       //           margin: EdgeInsets.zero,
                          //                     //       //           child: Center(
                          //                     //       //               child: Text(
                          //                     //       //                   'Select location on Google map')))),
                          //                     //       // ),
                          //                     //     ],
                          //                     //   ),
                          //                     // ),
                          //                     Expanded(
                          //                       flex: 3,
                          //                       child: Column(
                          //                         mainAxisAlignment: MainAxisAlignment.center,
                          //                         mainAxisSize: MainAxisSize.min,
                          //                         children: [
                          //                           Padding(
                          //                             padding: mediumPadding,
                          //                             child: Row(
                          //                               mainAxisAlignment: MainAxisAlignment.center,
                          //                               children: [
                          //                                 FilledButton.icon(
                          //                                   onPressed: () async {
                          //                                     await pickAFile();
                          //                                     setState(() {});
                          //                                   },
                          //                                   icon: fileUploading
                          //                                       ? SizedBox(
                          //                                           width: SizeConfig.blockSizeHorizontal! * 2,
                          //                                           height: SizeConfig.blockSizeHorizontal! * 2,
                          //                                           child: Center(
                          //                                             child: CircularProgressIndicator(
                          //                                               color: darkSoftRedAlert,
                          //                                             ),
                          //                                           ),
                          //                                         )
                          //                                       : const Icon(Icons.upload_file),
                          //                                   label: Text(
                          //                                     _result != null && _result!.files.first.name.isNotEmpty
                          //                                         ? _result!.files.first.name
                          //                                         : '$bulkUpload $staffDetails',
                          //                                   ),
                          //                                 ),
                          //                                 if (_result != null && _result!.files.first.name.isNotEmpty)
                          //                                   TextButton(
                          //                                       onPressed: () {
                          //                                         //    _result!.files.clear();
                          //                                         setState(() {});
                          //                                       },
                          //                                       child: const Text(clear),)
                          //                                 else
                          //                                   const SizedBox()
                          //                               ],
                          //                             ),
                          //                           ),
                          //                           if (_result != null && _result!.files.first.name.isNotEmpty)
                          //                             Padding(
                          //                               padding: mediumPadding,
                          //                               child: ElevatedButton(
                          //                                 child: const Text(upload),
                          //                                 onPressed: () {
                          //                                   if (kIsWeb) {
                          //                                     final fileWeb = _result!.files.first.bytes!;
                          //                                     final fileName = _result!.files.first.name;
                          //                                     context.read<AdminCubit>().postDataImport(
                          //                                           fileWeb,
                          //                                           fileName,
                          //                                           employee,
                          //                                         );
                          //                                   } else {
                          //                                     //  context.read<StudentCubit>().uploadFile();
                          //                                   }
                          //                                 },
                          //                               ),
                          //                             )
                          //                           else
                          //                             const SizedBox(),
                          //                           if (jsonStrings != null && jsonStrings!.isNotEmpty)
                          //                             SizedBox(
                          //                                 height: SizeConfig.blockSizeVertical! * 20,
                          //                                 child: ListView(
                          //                                   children: List.generate(
                          //                                     jsonStrings!.length,
                          //                                     (index) => Text(
                          //                                       jsonStrings!.elementAt(index),
                          //                                     ),
                          //                                   ),
                          //                                 ),).animate().fadeIn()
                          //                           else
                          //                             const SizedBox()
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
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

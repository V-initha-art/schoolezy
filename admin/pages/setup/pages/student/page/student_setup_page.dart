import 'dart:convert';

import 'package:admin/adminrepo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:schoolezy/pages/admin/admin.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/student/cubit/student_cubit.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/student/page/student_setupdetail_page.dart';
import 'package:schoolezy/utility/apppadding.dart';
import 'package:schoolezy/utility/constant.dart';
import 'package:schoolezy/utility/sizeconfig.dart';
import 'package:universal_html/html.dart' as html;
import 'package:user/userrepo.dart';

class WebStudentPageSetup extends StatefulWidget {
  const WebStudentPageSetup({super.key});

  @override
  State<WebStudentPageSetup> createState() => _WebStudentPageSetupState();
}

class _WebStudentPageSetupState extends State<WebStudentPageSetup> {
  @override
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
  @override
  void didChangeDependencies() {
    context.read<StudentCubit>().getStudentView();
    // context.read<StudentCubit>().onPostStudentList();

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  Students? StudentView;
  bool studentLoading = false;
  String? query;

  late List<Students> bh = [];

  void Searchbook(String query) {
    final suggestion = StudentView!.data!.where((stude) {
      final name = stude.first_name!.toLowerCase();
      final input = query.toLowerCase();
      return name.contains(input);
    }).toList();
    setState(() {
      // this.query = query;
      // this.suggestion = suggestion.cast<Students>();

      bh = suggestion.cast<Students>();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final brightness = Theme.of(context).brightness;
    return BlocListener<StudentCubit, StudentState>(
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
              if (state is StudentViewLoading) {
                studentLoading = true;
              }

              if (state is StudentViewsuccess) {
                if (state.StudentView!.data!.isNotEmpty) {
                  StudentView = state.StudentView;
                }
                studentLoading = false;
              }

              return Scaffold(
                body: Row(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: fourPadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Student'),
                                    SizedBox(
                                      width: SizeConfig.blockSizeHorizontal! * 30,
                                      child: TextFormField(
                                        onChanged: Searchbook,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        controller: _studentController,
                                        // validator:
                                        //     checkNumbersOnlyValidation,
                                        decoration: InputDecoration(
                                          prefixIcon: IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.search),
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              Searchbook;
                                            },
                                            icon: Icon(Icons.filter_list),
                                          ),
                                          //   labelText:
                                          //       'Lat Lng - Google address',
                                        ),
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebStudentPageDetailSetup()));
                                  },
                                  child: const Text('NEW'),
                                ),
                              ),
                              //  Padding(
                              //    padding: const EdgeInsets.fromLTRB(0, twenty4Padding, 0, 0),
                              //    child: InkWell(
                              //      onTap: (){
                              //       Navigator.push(context, MaterialPageRoute(builder:(context)=>WebStudentPageDetailSetup() ));

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
                              //          '    NEW    ',
                              //          style: const TextStyle(
                              //            fontWeight: FontWeight.bold,
                              //          ),
                              //        ),

                              //      ],
                              //        ),
                              //      ),
                              //       ),
                              //    ),
                              //  ),
                            ],
                          ),
                          if (studentLoading || StudentView == null)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: oneFiftyPadding),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else
                            (StudentView == null && StudentView!.data!.isEmpty)
                                ? const Center(child: Text(noData))
                                : Expanded(
                                    child: ListView.separated(
                                        separatorBuilder: (context, index) => const Divider(),
                                        itemCount: StudentView!.data!.length,
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
                                                          '${StudentView!.data!.elementAt(index).first_name ?? 'Admin'}',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${StudentView!.data!.elementAt(index).custom_program ?? '2rd'}',
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
                                                          '${StudentView!.data!.elementAt(index).custom_section ?? 'Admin'}',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${StudentView!.data!.elementAt(index).address_line_1 ?? 'Ranking'}',
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
                                        }),
                                  ),
                        ],
                      ),
                    ),
                    //   Expanded(
                    //     flex: 4,
                    //     // child: ,
                    //     child: Card(
                    //       child: Material(
                    //         color: Colors.transparent,
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             // Row(
                    //             //   children: [
                    //             // const Expanded(
                    //             //   child: Padding(
                    //             //     padding: EdgeInsets.fromLTRB(
                    //             //       fiftyPadding,
                    //             //       sixPadding,
                    //             //       fiftyPadding,
                    //             //       sixPadding,
                    //             //     ),
                    //             // child:
                    //             Padding(
                    //               padding: const EdgeInsets.fromLTRB(sixteenPadding, twelvePadding, 0, 0),
                    //               child: Text(bulkUpload),
                    //             ),
                    //             // Text(uploadStudentDetails),
                    //             //   ),
                    //             // ),
                    //             //     Padding(
                    //             //       padding: const EdgeInsets.fromLTRB(
                    //             //         sixPadding,
                    //             //         sixPadding,
                    //             //         fiftyPadding,
                    //             //         sixPadding,
                    //             //       ),
                    //             //       child: Card(
                    //             //         color: brightness == Brightness.light ? lightSoftRedAlert : darkSoftRedAlert,
                    //             //         child: Row(
                    //             //           children: [
                    //             //             const Padding(
                    //             //               padding: mediumPadding,
                    //             //               child: Text('Single student can be added later!'),
                    //             //             ),
                    //             //             LineIcon(LineIcons.exclamationCircle)
                    //             //           ],
                    //             //         ),
                    //             //       )
                    //             //           .animate(delay: 600.ms)
                    //             //           // .fade()
                    //             //           .scale(
                    //             //             begin: const Offset(1, 10),
                    //             //           )
                    //             //       // .move(
                    //             //       //   begin: const Offset(5, 0),
                    //             //       //   delay: 300.ms,
                    //             //       //   duration: 600.ms,
                    //             //       // ) // runs after the above w/new duration
                    //             //       ,
                    //             //     )
                    //             //   ],
                    //             // ),
                    //             // Expanded(
                    //             // child:
                    //             DecoratedBox(
                    //               decoration: const BoxDecoration(
                    //                 image: DecorationImage(
                    //                   fit: BoxFit.cover,
                    //                   image: AssetImage(
                    //                     'images/cloud.jpg',
                    //                   ),
                    //                 ),
                    //               ),
                    //               child: Padding(
                    //                 padding: smallPadding,
                    //                 child: Column(
                    //                   // mainAxisSize: MainAxisSize.min,
                    //                   children: [
                    //                     // Padding(
                    //                     //   padding: largePadding,
                    //                     //   child: Align(
                    //                     //     alignment: Alignment.topRight,
                    //                     //     child: FilledButton.icon(
                    //                     //       icon: fileDownloading
                    //                     //           ? const Center(
                    //                     //               child: CircularProgressIndicator(),
                    //                     //             )
                    //                     //           : const Icon(Icons.download),
                    //                     //       onPressed: () => context.read<StudentCubit>().downloadTemplateFile(),
                    //                     //       label: const Text(downloadTemplate),
                    //                     //     ),
                    //                     //   ),
                    //                     // ),
                    //                     //  Expanded(
                    //                     //  child:

                    //                     // Column(
                    //                     //   mainAxisAlignment: MainAxisAlignment.center,
                    //                     //   children: [
                    //                     // if (fileUploading)
                    //                     //   SizedBox(
                    //                     //     width: SizeConfig.blockSizeHorizontal! * 2,
                    //                     //     height: SizeConfig.blockSizeHorizontal! * 2,
                    //                     //     child: Center(
                    //                     //       child: CircularProgressIndicator(
                    //                     //         color: darkSoftRedAlert,
                    //                     //       ),
                    //                     //     ),
                    //                     //   )
                    //                     // else
                    //                     //   const Icon(Icons.cloud_upload_rounded),

                    //                     Center(
                    //                       child: Padding(
                    //                         padding: smallPadding,
                    //                         child: SizedBox(
                    //                           height: SizeConfig.blockSizeHorizontal! * 22,
                    //                           width: SizeConfig.blockSizeHorizontal! * 22,
                    //                           child: Card(
                    //                             shape: RoundedRectangleBorder(
                    //                               borderRadius: BorderRadius.circular(4.0), //<-- SEE HERE
                    //                             ),
                    //                             child: Column(
                    //                               mainAxisAlignment: MainAxisAlignment.center,
                    //                               children: [
                    //                                 FilledButton.icon(
                    //                                   onPressed: () async {
                    //                                     await pickAFile();
                    //                                     setState(() {});
                    //                                   },
                    //                                   icon: fileUploading
                    //                                       ? const Center(
                    //                                           child: CircularProgressIndicator(),
                    //                                         )
                    //                                       : const SizedBox(),
                    //                                   label: Row(
                    //                                     children: [
                    //                                       Icon(
                    //                                         Icons.cloud_upload_rounded,
                    //                                       ),
                    //                                       Text(
                    //                                         _result != null && _result!.files.first.name.isNotEmpty ? _result!.files.first.name : 'Upload',
                    //                                         // $student',
                    //                                       ),
                    //                                     ],
                    //                                   ),
                    //                                 ),
                    //                                 if (_result != null && _result!.files.first.name.isNotEmpty)
                    //                                   TextButton(
                    //                                     onPressed: () {
                    //                                       //    _result!.files.clear();
                    //                                       setState(() {});
                    //                                     },
                    //                                     child: const Text(clear),
                    //                                   )
                    //                                 else
                    //                                   const SizedBox()
                    //                               ],
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ),

                    //                     //  Card(
                    //                     //        shape: RoundedRectangleBorder(
                    //                     //       borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                    //                     //     ),
                    //                     //    child: Padding(
                    //                     //      padding:smallPadding,
                    //                     //      child: Row(
                    //                     //        mainAxisAlignment: MainAxisAlignment.center,
                    //                     //        children: [
                    //                     //          Padding(
                    //                     //           padding: extraxxLargePadding,
                    //                     //            child: FilledButton.icon(
                    //                     //              onPressed: () async {
                    //                     //                await pickAFile();
                    //                     //                setState(() {});
                    //                     //              },
                    //                     //              icon: fileUploading
                    //                     //                  ? const Center(
                    //                     //                      child: CircularProgressIndicator(),
                    //                     //                    )
                    //                     //                  : const SizedBox(),
                    //                     //              label: Text(
                    //                     //                _result != null && _result!.files.first.name.isNotEmpty
                    //                     //                    ? _result!.files.first.name
                    //                     //                    : '$bulkUpload',
                    //                     //                    // $student',
                    //                     //              ),
                    //                     //            ),
                    //                     //          ),
                    //                     //          if (_result != null && _result!.files.first.name.isNotEmpty)
                    //                     //            TextButton(
                    //                     //              onPressed: () {
                    //                     //                //    _result!.files.clear();
                    //                     //                setState(() {});
                    //                     //              },
                    //                     //              child: const Text(clear),
                    //                     //            )
                    //                     //          else
                    //                     //            const SizedBox()
                    //                     //        ],
                    //                     //      ),
                    //                     //    ),
                    //                     //  ),
                    //                     //   ],
                    //                     // ),
                    //                     //  ),
                    //                     if (_result != null && _result!.files.first.name.isNotEmpty)
                    //                       Padding(
                    //                         padding: mediumPadding,
                    //                         child: ElevatedButton(
                    //                           child: const Text(upload),
                    //                           onPressed: () {
                    //                             if (kIsWeb) {
                    //                               final fileWeb = _result!.files.first.bytes!;
                    //                               final fileName = _result!.files.first.name;
                    //                               context.read<AdminCubit>().postDataImport(
                    //                                     fileWeb,
                    //                                     fileName,
                    //                                     student,
                    //                                   );
                    //                             } else {
                    //                               //  context.read<StudentCubit>().uploadFile();
                    //                             }
                    //                           },
                    //                         ),
                    //                       )
                    //                     else
                    //                       const SizedBox(),
                    //                     if (jsonStrings != null && jsonStrings!.isNotEmpty)
                    //                       SizedBox(
                    //                         height: SizeConfig.blockSizeVertical! * 20,
                    //                         width: SizeConfig.blockSizeHorizontal! * 20,
                    //                         child: ListView(
                    //                           children: List.generate(
                    //                             jsonStrings!.length,
                    //                             (index) => Html(
                    //                               data: jsonStrings!.elementAt(index),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ).animate().fadeIn()
                    //                     else
                    //                       const SizedBox()
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //             //  ),

                    //             Center(
                    //               child: Padding(
                    //                 padding: smallPadding,
                    //                 child: SizedBox(
                    //                   height: SizeConfig.blockSizeHorizontal! * 22,
                    //                   width: SizeConfig.blockSizeHorizontal! * 22,
                    //                   child: Card(
                    //                     shape: RoundedRectangleBorder(
                    //                       borderRadius: BorderRadius.circular(4.0), //<-- SEE HERE
                    //                     ),
                    //                     //  child: Column(
                    //                     //   mainAxisAlignment: MainAxisAlignment.center,
                    //                     //  children: [
                    //                     //  FilledButton.icon(
                    //                     //    onPressed: () async {
                    //                     //      await pickAFile();
                    //                     //      setState(() {});
                    //                     //    },
                    //                     //    icon: fileUploading
                    //                     //        ? const Center(
                    //                     //            child: CircularProgressIndicator(),
                    //                     //          )
                    //                     //        : const SizedBox(),
                    //                     //    label: Row(

                    //                     //      children: [
                    //                     //       Icon(Icons.cloud_upload_rounded,),
                    //                     //        Text(
                    //                     //          _result != null && _result!.files.first.name.isNotEmpty
                    //                     //              ? _result!.files.first.name
                    //                     //              : 'Upload',
                    //                     //              // $student',
                    //                     //        ),
                    //                     //      ],
                    //                     //    ),
                    //                     //  ),
                    //                     //  if (_result != null && _result!.files.first.name.isNotEmpty)
                    //                     //  TextButton(
                    //                     //    onPressed: () {
                    //                     //      //    _result!.files.clear();
                    //                     //      setState(() {});
                    //                     //    },
                    //                     //    child: const Text(clear),
                    //                     //  )
                    //                     //  else
                    //                     //  const SizedBox()

                    //                     //         ],
                    //                     //           ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                  ],
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

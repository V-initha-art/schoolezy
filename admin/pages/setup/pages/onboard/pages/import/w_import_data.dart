import 'dart:typed_data';

import 'package:admin/adminrepo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:schoolezy/pages/admin/cubit/admin_cubit.dart';
import 'package:schoolezy/utility/apppadding.dart';
import 'package:schoolezy/utility/constant.dart';
import 'package:schoolezy/utility/sizeconfig.dart';
import 'package:user/userrepo.dart';

class WebOnboardImportData extends StatefulWidget {
  const WebOnboardImportData({super.key});

  @override
  State<WebOnboardImportData> createState() => _WebOnboardImportDataState();
}

class _WebOnboardImportDataState extends State<WebOnboardImportData> with AutomaticKeepAliveClientMixin {
  Future<void> dataImport(String docType) async {
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx'],
    );
    postCourse(file!.files.first.bytes!, file.files.first.name, docType);
  }

  void postCourse(Uint8List file, String fileName, String docType) {
    context.read<AdminCubit>().postDataImport(file, fileName, docType);
  }

  CountOnboard? countOnboard;

  bool countsLoading = false;

  @override
  void didChangeDependencies() {
    /// check for import data
    ///
    ///
    //  context.read<AdminCubit>().getCourse();
    context.read<AdminCubit>().getCounts();
    super.didChangeDependencies();
  }

  bool courseImportLoading = false;
  bool courseImportSuccess = false;
  bool programImportLoading = false;
  bool programImportSuccess = false;
  bool programSectionImportLoading = false;
  bool programSectionImportSuccess = false;

  bool studentImportLoading = false;
  bool studentImportSuccess = false;

  bool programEnrolmentImportLoading = false;
  bool programEnrolmentImportSuccess = false;

  bool employeesImportLoading = false;
  bool employeesImportSuccess = false;

  bool coursePresent = false;

  List<ImportLogs>? importLogs = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizeConfig().init(context);
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        if (state is CountOnboardLoading) {
          countsLoading = true;
        }
        if (state is CountOnboardSuccess) {
          countOnboard = state.countOnboard;
          countsLoading = false;
        }
        if (state is AdminFailure) {
          countsLoading = false;
        }
        // if (state is CourseImportCheck) {
        //   importCourseLoading = true;
        // }
        // if (state is CourseImportSuccess) {
        //   coursePresent = true;
        //   importCourseLoading = false;
        // }

        // if (state is Failure) {
        //   importCourseLoading = false;
        // }

        if (state is CourseDataImportLoading) {
          courseImportLoading = true;
        }
        if (state is CourseDataImportSuccess) {
          importLogs?.add(state.importLogs!);
          courseImportLoading = false;
          courseImportSuccess = true;
        }
        if (state is ProgramDataImportLoading) {
          programImportLoading = true;
        }
        if (state is ProgramDataImportSuccess) {
          importLogs?.add(state.importLogs!);
          programImportLoading = false;
          programImportSuccess = true;
        }

        if (state is ProgramSectionDataImportLoading) {
          programSectionImportLoading = true;
        }
        if (state is ProgramSectionDataImportSuccess) {
          importLogs?.add(state.importLogs!);
          programSectionImportLoading = false;
          programSectionImportSuccess = true;
        }
        if (state is StudentDataImportLoading) {
          studentImportLoading = true;
        }
        if (state is StudentDataImportSuccess) {
          importLogs?.add(state.importLogs!);
          studentImportLoading = false;
          studentImportSuccess = true;
        }
        if (state is ProgramEnrolmentImportLoading) {
          programEnrolmentImportLoading = true;
        }
        if (state is ProgramEnrolmentImportSuccess) {
          importLogs?.add(state.importLogs!);
          programEnrolmentImportLoading = false;
          programEnrolmentImportSuccess = true;
        }
        if (state is EmployeesImportLoading) {
          employeesImportLoading = true;
        }
        if (state is EmployeesImportSuccess) {
          importLogs?.add(state.importLogs!);
          employeesImportLoading = false;
          employeesImportSuccess = true;
        }

        return Scaffold(
          body: Column(
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    fiftyPadding,
                    twenty4Padding,
                    hunderedPadding,
                    twelvePadding,
                  ),
                  child: Text(
                    importOnboardData,
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: const EdgeInsets.fromLTRB(
                    fiftyPadding,
                    sixPadding,
                    fiftyPadding,
                    sixPadding,
                  ),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.4,
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://erpdev.schoolezy.in/private/files/paper_office.jpg',
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          // width: SizeConfig.blockSizeHorizontal! * 30,
                          // height: SizeConfig.blockSizeVertical! * 90,
                          child: importLogs!.isNotEmpty
                              ? Column(
                                  children: importLogs!
                                      .map(
                                        (main) => SizedBox(
                                          height: SizeConfig.blockSizeVertical! * 20,
                                          child: ListView(
                                            children: main.data!.map((e) => Html(data: e.messages! + e.row_indexes!)).toList(),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                )
                              : const Center(child: Text('Logs')),
                        ),
                        const VerticalDivider(),
                        Expanded(
                          flex: 2,
                          child: ListView(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox.square(
                                    dimension: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: TextButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.download_for_offline),
                                      label: const Text('Sample'),
                                    ),
                                  ),
                                  const SizedBox.square(
                                    dimension: 10,
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        icon: courseImportLoading
                                            ? SizedBox.square(
                                                dimension: 10,
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: SizeConfig.blockSizeHorizontal! * .2,
                                                  ),
                                                ),
                                              )
                                            : Icon(courseImportSuccess ? Icons.cloud_done_rounded : Icons.cloud_upload_outlined),
                                        onPressed: () => dataImport('Course'),
                                        label: const Text(
                                          'Courses',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (countsLoading)
                                        const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      else
                                        countOnboard != null
                                            ? Padding(
                                                padding: smallPadding,
                                                child: Text(
                                                  countOnboard!.course.toString(),
                                                ),
                                              )
                                            : const Text(noData)
                                    ],
                                  ),
                                  const SizedBox.square(
                                    dimension: 10,
                                  ),
                                  // Icon(coursePresent ? Icons.check_circle_outlined : Icons.do_disturb_on_outlined)
                                ],
                              ),
                              const Divider(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox.square(
                                    dimension: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: TextButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.download_for_offline),
                                      label: const Text('Sample'),
                                    ),
                                  ),
                                  const SizedBox.square(
                                    dimension: 10,
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        icon: programImportLoading
                                            ? const SizedBox.square(
                                                dimension: 10,
                                                child: Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                              )
                                            : Icon(programImportSuccess ? Icons.cloud_done_rounded : Icons.lock),
                                        onPressed: () => dataImport('Program'),
                                        label: const Text(
                                          'Class',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (countsLoading)
                                        const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      else
                                        countOnboard != null
                                            ? Padding(
                                                padding: smallPadding,
                                                child: Text(
                                                  countOnboard!.program.toString(),
                                                ),
                                              )
                                            : const Text(noData)
                                    ],
                                  ),
                                  const SizedBox.square(
                                    dimension: 10,
                                  ),
                                ],
                              ),
                              const Divider(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox.square(
                                    dimension: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: TextButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.download_for_offline),
                                      label: const Text('Sample'),
                                    ),
                                  ),
                                  const SizedBox.square(
                                    dimension: 10,
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () => dataImport('Student Group'),
                                        icon: programSectionImportLoading
                                            ? const SizedBox.square(
                                                dimension: 10,
                                                child: Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                              )
                                            : Icon(programSectionImportSuccess ? Icons.cloud_done_rounded : Icons.cloud_upload_outlined),
                                        label: const Text(
                                          'Class sections',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (countsLoading)
                                        const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      else
                                        countOnboard != null
                                            ? Padding(
                                                padding: smallPadding,
                                                child: Text(
                                                  countOnboard!.student_group.toString(),
                                                ),
                                              )
                                            : const Text(noData)
                                    ],
                                  ),
                                  const SizedBox.square(
                                    dimension: 10,
                                  ),
                                  //  const Icon(Icons.check_circle_outlined)
                                ],
                              ),
                              const Divider(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox.square(
                                    dimension: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: TextButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.download_for_offline),
                                      label: const Text('Sample'),
                                    ),
                                  ),
                                  const SizedBox.square(
                                    dimension: 10,
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () => dataImport('Student'),
                                        icon: studentImportLoading
                                            ? const SizedBox.square(
                                                dimension: 10,
                                                child: Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                              )
                                            : Icon(studentImportSuccess ? Icons.cloud_done_rounded : Icons.cloud_upload_outlined),
                                        label: const Text(
                                          'Students',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (countsLoading)
                                        const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      else
                                        countOnboard != null
                                            ? Padding(
                                                padding: smallPadding,
                                                child: Text(
                                                  countOnboard!.student.toString(),
                                                ),
                                              )
                                            : const Text(noData)
                                    ],
                                  ),
                                  const SizedBox.square(
                                    dimension: 10,
                                  ),
                                  //   const Icon(Icons.check_circle_outlined)
                                ],
                              ),
                              const Divider(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox.square(
                                    dimension: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: TextButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.download_for_offline),
                                      label: const Text('Sample'),
                                    ),
                                  ),
                                  const SizedBox.square(
                                    dimension: 10,
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () => dataImport('Program Enrollment'),
                                        icon: programEnrolmentImportLoading
                                            ? const SizedBox.square(
                                                dimension: 10,
                                                child: Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                              )
                                            : Icon(programEnrolmentImportSuccess ? Icons.cloud_done_rounded : Icons.cloud_upload_outlined),
                                        label: const Text(
                                          'Program Enrollment',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (countsLoading)
                                        const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      else
                                        countOnboard != null
                                            ? Padding(
                                                padding: smallPadding,
                                                child: Text(
                                                  countOnboard!.program_enrollment.toString(),
                                                ),
                                              )
                                            : const Text(noData)
                                    ],
                                  ),
                                  const SizedBox.square(
                                    dimension: 10,
                                  ),
                                  //  const Icon(Icons.check_circle_outlined)
                                ],
                              ),
                              const Divider(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox.square(
                                    dimension: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: TextButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.download_for_offline),
                                      label: const Text('Sample'),
                                    ),
                                  ),
                                  const SizedBox.square(
                                    dimension: 10,
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () => dataImport('Employee'),
                                        icon: employeesImportLoading
                                            ? const SizedBox.square(
                                                dimension: 10,
                                                child: Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                              )
                                            : Icon(employeesImportSuccess ? Icons.cloud_done_rounded : Icons.cloud_upload_outlined),
                                        label: const Text(
                                          'Employees',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (countsLoading)
                                        const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      else
                                        countOnboard != null
                                            ? Padding(
                                                padding: smallPadding,
                                                child: Text(
                                                  countOnboard!.employee.toString(),
                                                ),
                                              )
                                            : const Text(noData)
                                    ],
                                  ),
                                  const SizedBox.square(
                                    dimension: 10,
                                  ),
                                  //    const Icon(Icons.check_circle_outlined)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

//  ListView(
//                                   children: [

//                                 const VerticalDivider(),

//                                 const VerticalDivider(),

//                                 const VerticalDivider(),

//                                 const VerticalDivider(),

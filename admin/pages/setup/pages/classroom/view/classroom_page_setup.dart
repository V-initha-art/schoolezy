import 'package:admin/adminrepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:schoolezy/pages/admin/cubit/admin_cubit.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/classroom/classroom.dart';
import 'package:schoolezy/utility/apppadding.dart';
import 'package:schoolezy/utility/constant.dart';
import 'package:schoolezy/utility/sizeconfig.dart';

class ClassroomPageSetup extends StatefulWidget {
  const ClassroomPageSetup({super.key});

  @override
  State<ClassroomPageSetup> createState() => _ClassroomPageSetupState();
}

class _ClassroomPageSetupState extends State<ClassroomPageSetup> with AutomaticKeepAliveClientMixin {
  List<String> classSection = [];

  final classes = schoolClassStandardList;

  final pickedClasses = <int, Map<int, bool>>{};

  final coursesOffered = courseList;

  late ClassroomState? _classroomState;

  String? newClassSection;
  final ScrollController _scrollController = ScrollController();

  double lastItem = 0;
  Teachers? teachers;
  bool teachersLoading = false;
  bool coursesLoading = false;
  bool studentgroupLoading = false;
  bool programLoading = false;
  Teacher? _selectedTeacherForClass;
  String _pickedClass = '';
  String _pickedClassSection = '';
  List<Map<String, Map<String, String>>>? programSectionTeacher = [];

  List<String>? names;
  List<String>? programList;
  List<StudentGroup>? studentGroupList;

  final sectionGroupList = <String>[];
  final courseSelected = <String>[];
  final programSelected = <String>[];
  @override
  void initState() {
    _classroomState = ClassroomState();
    super.initState();
  }

  void pickAClass(int index, BuildContext context) {
    context.read<ClassroomCubit>().createClass(
          classes.elementAt(index),
        );
    // setState(() {
    //   _pickedClass = classes.elementAt(index);
    // });
  }

  void updateTeacher(int index) {
    _selectedTeacherForClass = teachers!.data!.elementAt(index);
    // _classroomState!.copyWith(status: FormzSubmissionStatus.inProgress, programSectionTeacher: [
    //   {
    //     _pickedClass: {_pickedClassSection: _selectedTeacherForClass!.name!}
    //   }
    // ]);
    var existClassSection = '';
    for (final element in programSectionTeacher!) {
      element.forEach((key, value) {
        /// this is for class
        if (key == _pickedClass) {
          /// this is for class section
          value.forEach((key, value) {
            if (key == _pickedClassSection) {
              existClassSection = value;
            }
          });
        }
      });
    }
    debugPrint(existClassSection);
    if (existClassSection.isEmpty) {
      programSectionTeacher!.add({
        _pickedClass: {_pickedClassSection: _selectedTeacherForClass!.name!}
      });
    }

    debugPrint(programSectionTeacher!.length.toString());
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    context.read<ClassroomCubit>().getCourses();
    context.read<ClassroomCubit>().getClass();
    context.read<ClassroomCubit>().getStudentGroup();
    context.read<AdminCubit>().getAcademicTerms();

    super.didChangeDependencies();
  }

  Widget teachersToClass() {
    return Expanded(
      flex: 7,
      child: Column(
        children: [
          const Padding(
            padding: mediumPadding,
            child: Center(child: Text(selectTeacher)),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: teachers!.data!.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () => updateTeacher(index),
                title: Text(
                  teachers!.data!.elementAt(index).name!,
                ),
                trailing: (_selectedTeacherForClass != null && _selectedTeacherForClass!.name!.isNotEmpty && _selectedTeacherForClass!.name! == teachers!.data!.elementAt(index).name!)
                    ? const Icon(
                        Icons.check_circle,
                        size: 14,
                      )
                    : const SizedBox(),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<NameOnly>? subjects;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizeConfig().init(context);
    debugPrint(programSelected.length.toString());
    final brightness = Theme.of(context).brightness;
    return BlocListener<ClassroomCubit, ClassroomState>(
      listener: (context, state) {
        if (state is CoursesFailure) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('state.failure')));
        }
      },
      child: BlocBuilder<ClassroomCubit, ClassroomState>(
        builder: (context, state) {
          if (state is ClassRoomPostTrigger) {
            context.read<ClassroomCubit>().postClassAndSectionWithTeacher(programSectionTeacher);
          }
          if (state.status == FormzSubmissionStatus.success) {}

          if (state is ClassroomSection) {
            classSection = state.classSectionCreated;
          }
          if (state is ClassroomAddSection) {
            newClassSection = state.classSectionCreated;
            if (classSection.isNotEmpty && !classSection.contains(newClassSection)) {
              classSection.add(newClassSection!);
              //classSection.sort((a, b) => a,)
              //  debugPrint(classSection.last);
              //   lastItem = classSection.length.toDouble();
            }
            // animateToClassSection();
          }
          if (state is TeachersLoading) {
            teachersLoading = true;
          }
          if (state is ClassroomAddTeachers) {
            if (state.teachers != null && state.teachers!.data!.isNotEmpty) {
              teachers = state.teachers;
              teachersLoading = false;
            }
          }
          if (state is CoursesLoading) {
            coursesLoading = true;
          }
          if (state is CoursesSuccess) {
            if (state.courses!.isNotEmpty) {
              names = state.courses;
            }
            coursesLoading = false;
          }
          if (state is CoursesFailure) {
            coursesLoading = false;
          }
          if (state is ProgramLoading) {
            programLoading = true;
          }
          if (state is ProgramSucess) {
            if (state.classes!.isNotEmpty) {
              programList = state.classes;
            }
            programLoading = false;
          }
          if (state is ProgramFailure) {
            programLoading = false;
          }
          if (state is StudentGroupLoading) {
            studentgroupLoading = true;
          }
          if (state is StudentGroupSuccess) {
            if (state.studentGroup!.isNotEmpty) {
              studentGroupList = state.studentGroup;
            }
          }
          studentgroupLoading = false;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal! * 30,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      Padding(
                        padding: mediumPadding,
                        child: Text(
                          courses,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      if (coursesLoading)
                        const CircularProgressIndicator()
                      else
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal! * 25,
                          child: Wrap(
                            runSpacing: 5,
                            spacing: 15,
                            children: List.generate(
                              coursesOffered.length,
                              (index) => Padding(
                                padding: smallPadding,
                                child: ChoiceChip(
                                  shape: const StadiumBorder(),
                                  onSelected: (value) {
                                    // if (courseSelected.contains(
                                    //     coursesOffered.elementAt(index))) {
                                    //   courseSelected.remove(
                                    //       coursesOffered.elementAt(index));
                                    // } else {
                                    //   courseSelected
                                    //       .add(coursesOffered.elementAt(index));
                                    // }

                                    // setState(() {});
                                  },
                                  selected: names != null && names!.isNotEmpty ? names!.contains(coursesOffered[index]) : false,
                                  label: Text(
                                    coursesOffered.elementAt(index),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      // Spacer(),
                      // Center(
                      //     child: ElevatedButton(
                      //         onPressed: () {}, child: Text('Sumbit')))
                    ],
                  ),
                ),
                const VerticalDivider(),
                Column(
                  children: [
                    Padding(
                      padding: mediumPadding,
                      child: Center(
                          child: Text(
                        selectClass,
                        style: Theme.of(context).textTheme.labelMedium,
                      )),
                    ),
                    if (programLoading)
                      const CircularProgressIndicator()
                    else
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal! * 25,
                        child: Wrap(
                          runSpacing: 5,
                          spacing: 15,
                          children: List.generate(
                            classes.length,
                            (index) => Padding(
                              padding: mediumPadding,
                              child: ChoiceChip(
                                  onSelected: (value) {
                                    // if (programSelected.isNotEmpty &&
                                    //     !programSelected
                                    //         .contains(classes.elementAt(index))) {
                                    //   programSelected.add(classes.elementAt(index));
                                    // }
                                    // pickAClass(index, context);
                                    // final entry = {
                                    //   index: {index: value}
                                    // };
                                    // pickedClasses.addEntries(entry.entries);
                                    // // setState(() {
                                    // //   _isSelected = value;
                                    // // });
                                    // setState(() {});
                                  },
                                  label: Text(classes.elementAt(index)),
                                  selected: programList != null && programList!.isNotEmpty ? programList!.contains(classes[index]) : false

                                  // child: Row(
                                  //   mainAxisSize: MainAxisSize.min,
                                  //   children: [
                                  //     Text(classes.elementAt(index)),
                                  //     const SizedBox.square(
                                  //       dimension: 5,
                                  //     ),
                                  //
                                  //   ],
                                  // ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const VerticalDivider(),
                if (studentgroupLoading)
                  const CircularProgressIndicator()
                else
                  studentGroupList != null && studentGroupList!.isNotEmpty
                      ? SizedBox(
                          width: SizeConfig.blockSizeHorizontal! * 25,
                          child: Wrap(
                            runSpacing: 5,
                            spacing: 15,
                            children: List.generate(
                              studentGroupList!.length,
                              (index) => Padding(
                                padding: mediumPadding,
                                child: ChoiceChip(
                                    onSelected: (value) {
                                      // if (programSelected.isNotEmpty &&
                                      //     !programSelected
                                      //         .contains(classes.elementAt(index))) {
                                      //   programSelected.add(classes.elementAt(index));
                                      // }
                                      // pickAClass(index, context);
                                      // final entry = {
                                      //   index: {index: value}
                                      // };
                                      // pickedClasses.addEntries(entry.entries);
                                      // // setState(() {
                                      // //   _isSelected = value;
                                      // // });
                                      // setState(() {});
                                    },
                                    label: Text(studentGroupList!.elementAt(index).student_group_name!),
                                    selected: studentGroupList != null && studentGroupList!.isNotEmpty ? studentGroupList!.contains(studentGroupList![index].student_group_name) : false

                                    // child: Row(
                                    //   mainAxisSize: MainAxisSize.min,
                                    //   children: [
                                    //     Text(classes.elementAt(index)),
                                    //     const SizedBox.square(
                                    //       dimension: 5,
                                    //     ),
                                    //
                                    //   ],
                                    // ),
                                    ),
                              ),
                            ),
                          ),
                        )
                      : const Text('noData')
                // if (pickedClasses.isNotEmpty)
                //   SizedBox(
                //     width: SizeConfig.blockSizeHorizontal! * 20,
                //     child: selectSectionWidget(brightness)
                //         .animate()
                //         .fadeIn(duration: 200.ms, curve: Curves.easeInOut),
                //   )
                // else
                //   const SizedBox(),
                // if (teachersLoading)
                //   const Expanded(
                //     child: Center(
                //       child: CircularProgressIndicator(),
                //     ),
                //   )
                // else
                //   (teachers != null && teachers!.data!.isNotEmpty)
                //       ? teachersToClass().animate().fadeIn(duration: 200.ms, curve: Curves.easeInOut)
                //       : const SizedBox(),
                // if (programSectionTeacher != null && programSectionTeacher!.isNotEmpty)
                //   SizedBox(
                //     width: SizeConfig.blockSizeHorizontal! * 14,
                //     child: ListView(
                //       children: List.generate(
                //         programSectionTeacher!.length,
                //         (index) => ListTile(
                //           title: Text(programSectionTeacher!.elementAt(index).entries.map((e) => e.value).toString()),
                //           trailing: InkWell(
                //             onTap: () => setState(() => programSectionTeacher!.removeAt(index)),
                //             child: const Icon(Icons.delete_forever_rounded),
                //           ),
                //         ),
                //       ).toList(),
                //     ),
                //   )
                // else
                //   const SizedBox()
              ],
            ),
          );
        },
      ),
    );
  }

  Widget selectSectionWidget(Brightness brightness) {
    return classSection.isEmpty
        ? Padding(
            padding: largePadding,
            child: Center(
              child: Text(
                pickClass,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          )
        : Padding(
            padding: smallPadding,
            child: Column(
              children: [
                Padding(
                  padding: mediumPadding,
                  child: Center(
                      child: Text(
                    selectSection,
                    style: Theme.of(context).textTheme.labelMedium,
                  )),
                ),
                Expanded(
                  child: ListView(controller: _scrollController, children: [
                    Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      children: List.generate(
                        classSection.length,
                        (index) => Padding(
                          padding: mediumPadding,
                          child: ElevatedButton(
                            onPressed: () {
                              deleteSectionDialog(index);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(classSection.elementAt(index)),
                                const SizedBox.square(
                                  dimension: 10,
                                ),
                                const Icon(Icons.cancel_outlined)
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
                ElevatedButton.icon(
                  onPressed: () => context.read<ClassroomCubit>().addMoreClassSection(classSection.last),
                  icon: const Icon(Icons.add),
                  label: Text('$_pickedClassSection Section'),
                )
              ],
            ),
          );
  }

  void deleteSectionDialog(int index) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete ${classSection.elementAt(index)}',
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  deleteAlert,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(delete),
              onPressed: () {
                setState(() {
                  classSection.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// List.generate(
//                         classSection.length,
//                         (index) => Padding(
//                           padding: mediumPadding,
//                           child: (_pickedClassSection.isNotEmpty && _pickedClassSection == classSection.elementAt(index))
//                               ? FilledButton.tonal(
//                                   onPressed: () {
//                                     setState(() {
//                                       _pickedClassSection = '';
//                                     });
//                                   },
//                                   child: Text(classSection.elementAt(index)),
//                                 )
//                               : ElevatedButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       _pickedClassSection = classSection.elementAt(index);
//                                     });
//                                     if (teachers == null) context.read<ClassroomCubit>().getTeachers();
//                                   },
//                                   child: Row(mainAxisSize: MainAxisSize.min, children: [
//                                     const Spacer(),
//                                     Text(classSection.elementAt(index)),
//                                     const Spacer(),
//                                     InkWell(
//                                       onTap: () => deleteSectionDialog(index),
//                                       child: Icon(
//                                         Icons.cancel_outlined,
//                                         color: brightness == Brightness.light ? lightSoftRedAlert : darkSoftRedAlert,
//                                       ),
//                                     ),
//                                   ]),
//                                 ),
//                         ),
//                       ),

// SizedBox(
//                               width: SizeConfig.blockSizeHorizontal! * 15,
//                               height: SizeConfig.blockSizeHorizontal! * 5,
//                               child: Card(
//                                 child: InkWell(
//                                   onTap: () {
//                                     _selectedTeacherForClass = teachers!.data!.elementAt(index);
//                                     setState(() {});
//                                   },
//                                   child: ListView(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                         children: [
//                                           Padding(
//                                             padding: smallPadding,
//                                             child: Text(
//                                               teachers!.data!.elementAt(index).name!,
//                                             ),
//                                           ),
//                                           if (_selectedTeacherForClass != null &&
//                                               _selectedTeacherForClass!.name!.isNotEmpty &&
//                                               _selectedTeacherForClass!.name! == teachers!.data!.elementAt(index).name!)
//                                             const Icon(
//                                               Icons.check_circle,
//                                               size: 14,
//                                             )
//                                           else
//                                             const SizedBox()
//                                         ],
//                                       ),
//                                       Padding(
//                                         padding: smallPadding,
//                                         child: Text(
//                                           teachers!.data!.elementAt(index).name!,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),

// SizedBox(
//                             width: SizeConfig.blockSizeHorizontal! * 15,
//                             height: SizeConfig.blockSizeHorizontal! * 5,
//                             child: Card(
//                               child: InkWell(
//                                 onTap: () {
//                                   _selectedTeacherForClass =
//                                       teachers!.data!.elementAt(index);
//                                   setState(() {});
//                                 },
//                                 child: ListView(
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: [
//                                         Padding(
//                                           padding: smallPadding,
//                                           child: Text(
//                                             teachers!.data!
//                                                 .elementAt(index)
//                                                 .name!,
//                                           ),
//                                         ),
//                                         if (_selectedTeacherForClass != null &&
//                                             _selectedTeacherForClass!
//                                                 .name!.isNotEmpty &&
//                                             _selectedTeacherForClass!.name! ==
//                                                 teachers!.data!
//                                                     .elementAt(index)
//                                                     .name!)
//                                           const Icon(
//                                             Icons.check_circle,
//                                             size: 14,
//                                           )
//                                         else
//                                           const SizedBox()
//                                       ],
//                                     ),
//                                     Padding(
//                                       padding: smallPadding,
//                                       child: Text(
//                                         teachers!.data!.elementAt(index).name!,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),




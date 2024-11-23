import 'package:admin/adminrepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolezy/pages/admin/cubit/admin_cubit.dart';
import 'package:schoolezy/utility/apppadding.dart';
import 'package:schoolezy/utility/constant.dart';

class BasicSetupCompletePage extends StatefulWidget {
  const BasicSetupCompletePage({super.key});

  @override
  State<BasicSetupCompletePage> createState() => _BasicSetupCompletePageState();
}

class _BasicSetupCompletePageState extends State<BasicSetupCompletePage> with AutomaticKeepAliveClientMixin {
  @override
  void didChangeDependencies() {
    context.read<AdminCubit>().getCounts();
    super.didChangeDependencies();
  }

  CountOnboard? countOnboard;

  bool countsLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AdminCubit, AdminState>(
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
          return countsLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : countOnboard != null
                  ? Column(
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
                            child: Text(previewImportedData),
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
                                  fit: BoxFit.cover,
                                  opacity: 0.4,
                                  image: NetworkImage(
                                    'https://erpdev.schoolezy.in/private/files/final_back.jpg',
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: mediumPadding,
                                            child: Text(
                                              countOnboard!.course.toString(),
                                              style: Theme.of(context).textTheme.displayMedium,
                                            ),
                                          ),
                                          const Padding(
                                            padding: mediumPadding,
                                            child: Text('Course'),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: mediumPadding,
                                            child: Text(
                                              countOnboard!.program.toString(),
                                              style: Theme.of(context).textTheme.displayMedium,
                                            ),
                                          ),
                                          const Padding(
                                            padding: mediumPadding,
                                            child: Text('Program'),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: mediumPadding,
                                            child: Text(
                                              countOnboard!.student_group.toString(),
                                              style: Theme.of(context).textTheme.displayMedium,
                                            ),
                                          ),
                                          const Padding(
                                            padding: mediumPadding,
                                            child: Text('Sections'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: mediumPadding,
                                            child: Text(
                                              countOnboard!.student.toString(),
                                              style: Theme.of(context).textTheme.displayMedium,
                                            ),
                                          ),
                                          const Padding(
                                            padding: mediumPadding,
                                            child: Text('Students'),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: mediumPadding,
                                            child: Text(
                                              countOnboard!.program_enrollment.toString(),
                                              style: Theme.of(context).textTheme.displayMedium,
                                            ),
                                          ),
                                          const Padding(
                                            padding: mediumPadding,
                                            child: Text('Program Enrollment'),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: mediumPadding,
                                            child: Text(
                                              countOnboard!.instructor.toString(),
                                              style: Theme.of(context).textTheme.displayMedium,
                                            ),
                                          ),
                                          const Padding(
                                            padding: mediumPadding,
                                            child: Text('Teachers'),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: mediumPadding,
                                            child: Text(
                                              countOnboard!.employee.toString(),
                                              style: Theme.of(context).textTheme.displayMedium,
                                            ),
                                          ),
                                          const Padding(
                                            padding: mediumPadding,
                                            child: Text('Employees'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : const Text(noData);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

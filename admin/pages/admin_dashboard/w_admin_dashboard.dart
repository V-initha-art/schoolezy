import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolezy/authentication/authentication.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/onboard/pages/import/w_import_data.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/school/school.dart';
import 'package:schoolezy/pages/dashboard/dashboard.dart';
import 'package:schoolezy/utility/appcolors.dart';
import 'package:schoolezy/utility/apppadding.dart';
import 'package:schoolezy/utility/constant.dart';
import 'package:schoolezy/utility/sizeconfig.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  ////For basic setup we have only five pages
  final List<int> pages = [1, 2];

  /// stream to check the page validation

  PageController? _controller;
  int currentPage = 0;

  @override
  void initState() {
    _controller = PageController(initialPage: currentPage);
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final brightness = Theme.of(context).brightness;
    debugPrint(SizeConfig.screenWidth!.toString());
    final userAdmin = context.select((AuthCubit authCubit) => authCubit.state.user);
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () => context.read<ThemeCubit>().switchTheme(),
            child: const Icon(Icons.dark_mode),
          ),
          InkWell(
            onTap: () => context.read<AuthCubit>().onAuthenticationLogoutRequested(),
            child: const Icon(Icons.logout),
          )
        ],
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              schoolOnboardSetup.toUpperCase(),
            ),
            Text(
              userAdmin.message!.data!.email ?? 'name was not found',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: Center(
        child: SizedBox(
          width: SizeConfig.screenWidth! > 900 ? SizeConfig.blockSizeHorizontal! * 70 : SizeConfig.blockSizeHorizontal! * 90,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Center(
              //   child: Expanded(
              //     child: DecoratedBox(
              //       decoration: BoxDecoration(
              //         gradient: LinearGradient(colors: [
              //           (randomSelectLightColor..shuffle()).first,
              //           (randomSelectLightColor..shuffle()).first,
              //         ]),
              //       ),
              //       child: SizedBox(
              //         width: SizeConfig.blockSizeHorizontal! * 99,
              //         height: SizeConfig.blockSizeVertical! * 99,
              //       ),
              //     ),
              //   ),
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Visibility(
                  //   visible: false,
                  //   child: Align(
                  //     alignment: Alignment.centerRight,
                  //     child: Padding(
                  //       padding: const EdgeInsets.fromLTRB(
                  //         0,
                  //         sixPadding,
                  //         hunderedPadding,
                  //         sixPadding,
                  //       ),
                  //       child: TextButton.icon(
                  //         icon: const Icon(
                  //           Icons.edit,
                  //           size: 14,
                  //         ),
                  //         onPressed: () {},
                  //         label: const Text(edit),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _controller,
                      onPageChanged: (value) {
                        setState(() {
                          currentPage = value;
                        });
                      },
                      children: const <Widget>[
                        ///Basic School setup UI and validation
                        Opacity(opacity: 0.9, child: SchoolSetupPage()),

                        ///Basic Class setup UI and validation for the School
                        Opacity(opacity: 0.9, child: WebOnboardImportData()),

                        // ///Basic Student bulk upload
                        // Opacity(opacity: 0.9, child: StudentPageSetup()),

                        // ///Basic Teacher setup UI and validation for selected Employee and school
                        // TeacherSetupPage(),

                        ///Basic setup complete page to have the minimum data
                        //Opacity(opacity: 0.9, child: BasicSetupCompletePage())
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                fiftyPadding,
                                sixPadding,
                                fiftyPadding,
                                sixPadding,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.emergency_rounded,
                                    size: 10,
                                    color: brightness == Brightness.light ? lightSoftRedAlert : darkSoftRedAlert,
                                  ),
                                  const Text(mandatoryFields),
                                ],
                              ),
                            ),
                            Row(
                              children: List.generate(
                                pages.length,
                                growable: false,
                                (index) => InkWell(
                                  onTap: () {
                                    if (_controller!.hasClients) {
                                      debugPrint(currentPage.toString());
                                      updateCurrentPage(index);
                                      _controller!.animateToPage(
                                        index,
                                        duration: const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: smallPadding,
                                    child: CircleAvatar(
                                      radius: SizeConfig.blockSizeHorizontal! * .3,
                                      backgroundColor: currentPage == index
                                          ? brightness == Brightness.light
                                              ? lightSoftRedAlert
                                              : darkSoftRedAlert
                                          : lightDarkBlue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            // if (currentPage > 0)
                            //   Padding(
                            //     padding: largePadding,
                            //     child: ElevatedButton(
                            //       onPressed: () {
                            //         if (_controller!.hasClients) {
                            //           updateCurrentPage(currentPage - 1);
                            //           debugPrint(currentPage.toString());
                            //           _controller!.animateToPage(
                            //             _controller!.page!.toInt() - 1,
                            //             duration: const Duration(milliseconds: 400),
                            //             curve: Curves.easeInOut,
                            //           );
                            //         }
                            //       },
                            //       child: const Text(previous),
                            //     ),
                            //   )
                            // else
                            //   const SizedBox(),
                            const Spacer(),
                            Padding(
                              padding: mediumPadding,
                              child: ElevatedButton(
                                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(lightDarkGreen)),
                                onPressed: () {
                                  if (_controller!.hasClients) {
                                    if (currentPage == 0) context.read<SchoolCubit>().checkValidationFinal();
                                    // if (currentPage == 3) context.read<ClassroomCubit>().triggerProgramSectionTeacher();

                                    // updateCurrentPage(currentPage + 1);
                                    // debugPrint(currentPage.toString());
                                    // _controller!.animateToPage(
                                    //   _controller!.page!.toInt() + 1,
                                    //   duration: const Duration(milliseconds: 400),
                                    //   curve: Curves.easeInOut,
                                    // );
                                  }
                                },
                                child: Text(currentPage == 0 ? '$save & $next' : 'exit'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateCurrentPage(int index) => currentPage = index;
}

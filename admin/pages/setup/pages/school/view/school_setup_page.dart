import 'package:admin/adminrepo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolezy/authentication/authentication.dart';
import 'package:schoolezy/pages/admin/cubit/admin_cubit.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/academy/w_academy.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/classroom/view/classroom_page_setup.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/school/school.dart';
import 'package:schoolezy/utility/appcolors.dart';
import 'package:schoolezy/utility/apppadding.dart';
import 'package:schoolezy/utility/constant.dart';
import 'package:schoolezy/utility/sizeconfig.dart';

class SchoolPageView extends StatefulWidget {
  const SchoolPageView({super.key});

  @override
  State<SchoolPageView> createState() => _SchoolPageViewState();
}

class _SchoolPageViewState extends State<SchoolPageView> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final company = context.read<AuthCubit>().state.user;
    super.build(context);
    SizeConfig().init(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('School Setup'),
              // Text(
              //   company.message?.data?.school?.elementAt(0).company_name ?? 'no school' ?? 'no school',
              //   style: Theme.of(context).textTheme.labelSmall,
              // ),
            ],
          ),
          bottom: const TabBar(tabs: [
            Padding(
              padding: extraxLargePadding,
              child: Text('Academy Year'),
            ),
            Padding(
              padding: extraxLargePadding,
              child: Text('School'),
            ),
            Padding(
              padding: extraxLargePadding,
              child: Text('Subject & Class Room'),
            )
          ]),
        ),
        body: const TabBarView(
          children: [
            AcademyPage(),
            SchoolSetupPage(),
            ClassroomPageSetup(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SchoolSetupPage extends StatefulWidget {
  const SchoolSetupPage({super.key});

  @override
  State<SchoolSetupPage> createState() => _SchoolSetupPageState();
}

class _SchoolSetupPageState extends State<SchoolSetupPage> {
  FilePickerResult? result;
  bool checkedValue = false;
  String selectedValue = '';
  TextEditingController dropdownMenuController = TextEditingController();
  final _acadamicYear = DateTime.now();
  late List<String> dropdownValues;

  // List<String> boards = [
  //   'CBSE',
  //   'ISC',
  //   'NIOS',
  //   'IGCSE',
  //   'ICSE',
  //   'IB',
  //   'MATRIC'
  // ];
  // List<String> boards = [];

  late TextEditingController _schoolNameController;
  late TextEditingController _schoolAffiliationNoController;
  late TextEditingController _schoolBuildingNoController;
  late TextEditingController _schoolStreetNameController;
  late TextEditingController _schoolAreaNameController;
  late TextEditingController _schoolStateNameController;
  late TextEditingController _schoolPincodeController;
  late TextEditingController _schoolContactNoController;
  late TextEditingController _schoolLatLngSchoolController;

  late TextEditingController _boardCreateListController;

  List<FocusNode> listFocusNode = [];
  Map<String?, Uint8List?> imagesToUpload = {};

  @override
  void initState() {
    // dropdownValue = boards.first;
    _schoolNameController = TextEditingController();
    _schoolAffiliationNoController = TextEditingController();
    _schoolBuildingNoController = TextEditingController();
    _schoolStreetNameController = TextEditingController();
    _schoolAreaNameController = TextEditingController();
    _schoolStateNameController = TextEditingController();
    _schoolPincodeController = TextEditingController();
    _schoolContactNoController = TextEditingController();
    _schoolLatLngSchoolController = TextEditingController();
    _scrollController = ScrollController();
    _boardCreateListController = TextEditingController();

    // dropdownValues = [
    //   _acadamicYear.year.toString() +
    //       ' - ' +
    //       (_acadamicYear.year + 1).toString(),
    //   (_acadamicYear.year + 1).toString() +
    //       ' - ' +
    //       (_acadamicYear.year + 2).toString(),

    //   // Add more values here
    // ];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    context.read<SchoolCubit>().getCompany();
    context.read<SchoolCubit>().getCompanyAddress();
    // context.read<SchoolCubit>().getboardname();
    context.read<SchoolCubit>().getAcadamicSchoolYear();
    //  context.read<CompanyboardlistCubit>().postboardcreatename( BoardcreateList createlist);
    //context.read<SchoolCubit>().getboardname();
    super.didChangeDependencies();
  }

  static final _nameOnly = RegExp(
    r'^[a-z A-Z]*$',
  );
  static final _nameandnoOnly = RegExp(
    r'^[a-zA-Z0-9]+$',
  );
  static final _specialnameonly = RegExp(
    r'^[a-z A-Z _\-!@#$%^&*()+=?<>:;.,~]+$',
  );
  static final _noOnly = RegExp(
    r'^[0-9 ]*$',
  );
  static final _allcharOnly = RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$');

  // void _onSchoolLatLngChanged() {
  //   setState(() {
  //     _schoolState = _schoolState.copyWith(latLngSchool: LatLngOnly.dirty(_schoolLatLngSchoolController.text));
  //   });
  // }

  // void _onSchoolContactNoChanged() {
  //   setState(() {
  //     _schoolState = _schoolState.copyWith(contactNo: NoOnly.dirty(_schoolContactNoController.text));
  //   });
  // }

  // void _onSchoolPincodeChanged() {
  //   setState(() {
  //     _schoolState = _schoolState.copyWith(pinCodeNo: NoOnly.dirty(_schoolPincodeController.text));
  //   });
  // }

  // void _onSchoolStateNameChanged() {
  //   setState(() {
  //     _schoolState = _schoolState.copyWith(schoolStateName: NameOnly.dirty(_schoolStateNameController.text));
  //   });
  // }

  // void _onSchoolAreaNameChanged() {
  //   setState(() {
  //     _schoolState = _schoolState.copyWith(schoolAreaName: NameOnly.dirty(_schoolAreaNameController.text));
  //   });
  // }

  // void _onSchoolStreetNameChanged() {
  //   setState(() {
  //     _schoolState = _schoolState.copyWith(schoolStreetName: NameOnly.dirty(_schoolStreetNameController.text));
  //   });
  // }

  // void _onSchoolNameChanged() {
  //   setState(() {
  //     _schoolState = _schoolState.copyWith(schoolName: NameOnly.dirty(_schoolNameController.text));
  //   });
  // }

  // void _onSchoolBoardChanged() {
  //   setState(() {
  //     _schoolState = _schoolState.copyWith(boardName: NameOnly.dirty(selectBoard));
  //   });
  // }

  // void _onSchoolAffiliationNoChanged() {
  //   setState(() {
  //     _schoolState = _schoolState.copyWith(affiliationNo: NoOnly.dirty(_schoolAffiliationNoController.text));
  //   });
  // }

  // void _onSchoolBuildingNoChanged() {
  //   setState(() {
  //     _schoolState = _schoolState.copyWith(schoolBuildingNo: NoOnly.dirty(_schoolBuildingNoController.text));
  //   });
  // }

  @override
  void dispose() {
    _schoolNameController.dispose();
    super.dispose();
  }

  List<Board>? selectedBoards = [];
  bool allboard = false;

  bool schoolImageLoading = false;
  bool schoolLogoLoading = false;
  bool loginLoading = false;

  FilePickerResult? _schoolImageBanner;
  FilePickerResult? _schoolImageLogo;
  final _formKey = GlobalKey<FormState>();
  final formkey = GlobalKey<FormState>();
  ScrollController? _scrollController;
  late SchoolState _schoolState;
  bool schoolCreationLoading = false;
  bool schoolAcadamicYearLoading = false;
  bool schoolBoardsLoading = false;
  List<Board>? companyboardlist;
  List<AcadamicYear>? acadamicYearList;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final brightness = Theme.of(context).brightness;
    // debugPrint(SizeConfig.screenWidth!.toString());
    return Form(
      key: _formKey,
      child: BlocListener<SchoolCubit, SchoolState>(
        listener: (context, state) {
          // // if (state is SchoolFailure) {
          // //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('failed to load pictures')));
          // // }

          // if (state is CheckValidation) {
          //   checkingValidation();
          // }
          // if (state is CompanySuccess) {
          //   // context.read<SchoolCubit>().postCompanyAddress(companyAddress);
          // }
        },
        child: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            if (state is SchoolImageLoading) {
              schoolImageLoading = true;
            }
            if (state is SchoolImageSucess) {
              _schoolImageBanner = state.filePickerResult;
              if (_schoolImageBanner != null && _schoolImageBanner!.files.first.name.isNotEmpty) {
                schoolImageLoading = false;
              }
            }

            if (state is LogoImageLoading) {
              schoolLogoLoading = true;
            }
            if (state is LogoImageSucess) {
              _schoolImageLogo = state.filePickerResult;
              if (_schoolImageLogo != null && _schoolImageLogo!.files.first.name.isNotEmpty) {
                schoolLogoLoading = false;
              }
            }
            if (state is AdminFailure) {
              schoolLogoLoading = false;
              schoolLogoLoading = false;
              schoolImageLoading = false;
            }
            return BlocBuilder<SchoolCubit, SchoolState>(
              builder: (context, state) {
                // if (state is SchoolPictures) {
                //   result = state.result;
                // }

                if (state is CompanyLoading) {
                  schoolCreationLoading = true;
                }
                if (state is CompanyFolderSuccess) {
                  schoolCreationLoading = false;
                }
                if (state is CompanySuccess) {
                  schoolCreationLoading = false;
                }

                if (state is CompanyFailure) {
                  schoolCreationLoading = false;
                }

                ///setState called during build error!

                if (state is CompanyLoaded) {
                  _schoolNameController.text = state.company!.company_name.toString();
                  _schoolAffiliationNoController.text = state.company!.affiliation_number.toString();
                  _schoolLatLngSchoolController.text = state.company!.latlng.toString();
                }
                // if (state is CompanyAddressLoaded) {
                //   _schoolBuildingNoController.text = state.companyAddress!.first.address_line1.toString();
                //   _schoolStreetNameController.text = state.companyAddress!.first.address_line2.toString();
                //   _schoolAreaNameController.text = state.companyAddress!.first.city.toString();
                //   _schoolStateNameController.text = state.companyAddress!.first.state.toString();
                //   _schoolPincodeController.text = state.companyAddress!.first.pincode.toString();
                //   _schoolContactNoController.text = state.companyAddress!.first.phone.toString();
                // }
                if (state is BoardsSuccess) {
                  companyboardlist = state.companyboardlist;
                  schoolBoardsLoading = false;
                }
                if (state is BoardsLoading) {
                  schoolBoardsLoading = true;
                }
                if (state is BoardsFailure) {
                  schoolBoardsLoading = false;
                }
                // if (state is CompanyLoaded) {
                //   _schoolNameController.text =
                //       state.company!.company_name.toString();
                //   _schoolAffiliationNoController.text =
                //       state.company!.affiliation_number.toString();
                //   _schoolLatLngSchoolController.text =
                //       state.company!.latlng.toString();
                //   selectedBoards != state.company!.board!.first.board;
                // }

                return Column(
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              fiftyPadding,
                              twenty4Padding,
                              hunderedPadding,
                              twelvePadding,
                            ),
                            child: Text(schoolDetails + ' checking test'),
                          ),
                        ),

                        // Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.fromLTRB(
                        //       fiftyPadding,
                        //       twenty4Padding,
                        //       hunderedPadding,
                        //       twelvePadding,
                        //     ),
                        //     child:

                        //   ),
                        // ),
                      ],
                    ),
                    Expanded(
                      //height: SizeConfig.blockSizeHorizontal! * 60,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            opacity: 0.4,
                            image: NetworkImage(
                              'https://erpdev.schoolezy.in/private/files/school_background.jpg',
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: mediumPadding,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: SizeConfig.blockSizeHorizontal! * 3,
                              ),
                              Expanded(
                                flex: 7,
                                child: Scrollbar(
                                  controller: _scrollController,
                                  child: ListView(
                                    controller: _scrollController,
                                    children: [
                                      // Align(
                                      //   alignment: Alignment.centerRight,
                                      //   child: Text(
                                      //     'You cannot edit school name later!',
                                      //     style: Theme.of(context).textTheme.labelMedium!..merge(TextStyle(color: darkSoftRedAlert)),
                                      //   ),
                                      // ),

                                      // Row(
                                      //   children: [
                                      //     const Spacer(),
                                      //     TextButton.icon(
                                      //       icon: const Icon(
                                      //         Icons.edit,
                                      //         size: 14,
                                      //       ),
                                      //       onPressed: () {},
                                      //       label: const Text(edit),
                                      //     ),
                                      //   ],
                                      // ),

                                      Padding(
                                        padding: smallPadding,
                                        child: Wrap(
                                          alignment: SizeConfig.screenWidth! < 1300 ? WrapAlignment.start : WrapAlignment.center,
                                          children: [
                                            Padding(
                                              padding: mediumPadding,
                                              child: SizedBox(
                                                width: SizeConfig.blockSizeHorizontal! * 40,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.emergency_rounded,
                                                      size: 10,
                                                      color: brightness == Brightness.light ? lightSoftRedAlert : darkSoftRedAlert,
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal! * 40,
                                                      child: TextFormField(
                                                        enabled: false,
                                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                                        controller: _schoolNameController,
                                                        validator: checkStringOnlyValidation,
                                                        maxLength: 50,
                                                        decoration: const InputDecoration(
                                                          labelText: schoolName,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: mediumPadding,
                                              child: SizedBox(
                                                width: SizeConfig.blockSizeHorizontal! * 40,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.emergency_rounded,
                                                      size: 10,
                                                      color: brightness == Brightness.light ? lightSoftRedAlert : darkSoftRedAlert,
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    TextFormField(
                                                      enabled: false,
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      controller: _schoolAffiliationNoController,
                                                      maxLength: 50,
                                                      validator: checkNumbersOnlyValidation,
                                                      decoration: const InputDecoration(
                                                        labelText: affiliationNo,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   width: SizeConfig
                                            //           .blockSizeHorizontal! *
                                            //       40,
                                            //   child: Row(
                                            //     children: [
                                            //       Flexible(
                                            //           child: Padding(
                                            //         padding: smallPadding,
                                            //         child: TextFormField(),
                                            //       )),
                                            //       Flexible(
                                            //           child: Padding(
                                            //         padding: smallPadding,
                                            //         child: TextFormField(),
                                            //       )),

                                            //     ],
                                            //   ),
                                            // ),
                                            Padding(
                                              padding: mediumPadding,
                                              child: SizedBox(
                                                width: SizeConfig.blockSizeHorizontal! * 40,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.emergency_rounded,
                                                      size: 10,
                                                      color: brightness == Brightness.light ? lightSoftRedAlert : darkSoftRedAlert,
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    TextFormField(
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      controller: _schoolBuildingNoController,
                                                      validator: checkNameandNoOnlyValidation,
                                                      decoration: const InputDecoration(
                                                        labelText: buildingNo,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: mediumPadding,
                                              child: SizedBox(
                                                width: SizeConfig.blockSizeHorizontal! * 40,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.emergency_rounded,
                                                      size: 10,
                                                      color: brightness == Brightness.light ? lightSoftRedAlert : darkSoftRedAlert,
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    TextFormField(
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      controller: _schoolStreetNameController,
                                                      // inputFormatters: [
                                                      //   FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                                                      //    ],
                                                      // validator:
                                                      //     checkAllcharOnly,
                                                      decoration: const InputDecoration(
                                                        labelText: 'Street Name',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: mediumPadding,
                                              child: SizedBox(
                                                width: SizeConfig.blockSizeHorizontal! * 40,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.emergency_rounded,
                                                      size: 10,
                                                      color: brightness == Brightness.light ? lightSoftRedAlert : darkSoftRedAlert,
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    TextFormField(
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      controller: _schoolAreaNameController,
                                                      validator: checkNameandNoOnlyValidation,
                                                      decoration: const InputDecoration(
                                                        labelText: 'Area',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: mediumPadding,
                                              child: SizedBox(
                                                width: SizeConfig.blockSizeHorizontal! * 40,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.emergency_rounded,
                                                      size: 10,
                                                      color: brightness == Brightness.light ? lightSoftRedAlert : darkSoftRedAlert,
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    TextFormField(
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      controller: _schoolStateNameController,
                                                      validator: checkStringOnlyValidation,
                                                      decoration: const InputDecoration(
                                                        labelText: 'State',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: mediumPadding,
                                              child: SizedBox(
                                                width: SizeConfig.blockSizeHorizontal! * 40,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.emergency_rounded,
                                                      size: 10,
                                                      color: brightness == Brightness.light ? lightSoftRedAlert : darkSoftRedAlert,
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal! * 40,
                                                      child: TextFormField(
                                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                                        controller: _schoolPincodeController,
                                                        validator: checkNumbersOnlyValidation,
                                                        decoration: const InputDecoration(
                                                          labelText: 'Pincode',
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: mediumPadding,
                                              child: SizedBox(
                                                width: SizeConfig.blockSizeHorizontal! * 40,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.emergency_rounded,
                                                      size: 10,
                                                      color: brightness == Brightness.light ? lightSoftRedAlert : darkSoftRedAlert,
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    TextFormField(
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      controller: _schoolContactNoController,
                                                      validator: checkNumbersOnlyValidation,
                                                      maxLength: 10,
                                                      decoration: const InputDecoration(
                                                        labelText: contanctNo,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: mediumPadding,
                                              child: SizedBox(
                                                width: SizeConfig.blockSizeHorizontal! * 40,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.emergency_rounded,
                                                      size: 10,
                                                      color: brightness == Brightness.light ? lightSoftRedAlert : darkSoftRedAlert,
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal! * 40,
                                                      child: TextFormField(
                                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                                        controller: _schoolLatLngSchoolController,
                                                        validator: checkNumbersOnlyValidation,
                                                        decoration: const InputDecoration(
                                                          labelText: 'Lat Lng - Google address',
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              twelvePadding,
                                              zeroPadding,
                                              zeroPadding,
                                              twoPadding,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.emergency_rounded,
                                                      size: 10,
                                                      color: brightness == Brightness.light ? lightSoftRedAlert : darkSoftRedAlert,
                                                    ),
                                                    const Text(selectBoard)
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (schoolBoardsLoading)
                                            const Center(
                                              child: CircularProgressIndicator(),
                                            )
                                          else
                                            companyboardlist != null && companyboardlist!.isNotEmpty
                                                ? Wrap(
                                                    children: List.generate(companyboardlist!.length, (index) {
                                                      final board = companyboardlist?[index];
                                                      return Padding(
                                                        padding: smallPadding,
                                                        child: ChoiceChip(
                                                          shape: const StadiumBorder(),
                                                          onSelected: (value) {
                                                            if (!selectedBoards!.contains(board)) {
                                                              selectedBoards!.add(
                                                                Board(board_name: companyboardlist!.elementAt(index).name.toString()),
                                                              );
                                                            } else {
                                                              selectedBoards!.remove(board);
                                                            }
                                                            setState(() {});
                                                          },
                                                          label: Text(companyboardlist!.elementAt(index).name.toString()),
                                                          selected: selectedBoards!.contains(board),
                                                        ),
                                                      );
                                                    }),
                                                  )
                                                : const Text('no boards to show'),
                                          Padding(
                                            padding: largePadding,
                                            child: FittedBox(
                                              alignment: Alignment.bottomCenter,
                                              fit: BoxFit.scaleDown,
                                              child: FilledButton.tonal(
                                                onPressed: () {},
                                                //checkingSubmit(),
                                                child: loginLoading
                                                    ? SizedBox(
                                                        height: SizeConfig.blockSizeHorizontal! * 2,
                                                        width: SizeConfig.blockSizeHorizontal! * 2,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 3,
                                                          valueColor: AlwaysStoppedAnimation(darkSoftRedAlert),
                                                        ),
                                                      )
                                                    : const Text('Submit'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Padding(
                                      //   padding: mediumPadding,
                                      //   child: SizedBox(
                                      //       width: SizeConfig.blockSizeHorizontal! * 30,
                                      //       height: SizeConfig.blockSizeHorizontal! * 40,
                                      //       child: Card(
                                      //           margin: EdgeInsets.zero,
                                      //           child: Center(
                                      //               child: Text(
                                      //                   'Select location on Google map')))),
                                      // ),

                                      //  Padding(
                                      //   padding: const EdgeInsets.fromLTRB(zeroPadding, zeroPadding, twenty4Padding, sixteenPadding),
                                      // child: Row(
                                      //     mainAxisAlignment: MainAxisAlignment.end,
                                      //     children: [
                                      //     InkWell(
                                      //       onTap: (){

                                      //         print('123....313');
                                      //         checkingValidation();

                                      //       //    final companyAddress = CompanyAddress(
                                      //       //    address_title: _schoolNameController.text,
                                      //       //    address_type: 'Office',
                                      //       //    address_line1: _schoolBuildingNoController.text,
                                      //       //    address_line2: _schoolStreetNameController.text,
                                      //       //    city: _schoolAreaNameController.text,
                                      //       //    country: 'India',
                                      //       //    county: _schoolNameController.text,
                                      //       //    email_id: 'test@gmail.com',
                                      //       //    state: _schoolStateNameController.text,
                                      //       //    pincode: _schoolPincodeController.text,
                                      //       //    phone: _schoolContactNoController.text,
                                      //       //    is_your_company_address: 1,
                                      //       //    links: [
                                      //       //      {'link_doctype': 'Company', 'link_name': _schoolNameController.text}
                                      //       //    ],
                                      //       //  );
                                      //       //   context.read<SchoolCubit>().putCompanySubmit();
                                      //       },
                                      //         child: Container(
                                      //           height: 30,
                                      //           width: 80,
                                      //           decoration:  BoxDecoration(
                                      //             borderRadius: BorderRadius.all(Radius.circular(30)),
                                      //            border: Border.all(color:Colors.black),
                                      //           ),
                                      //           child: const Center(child: Text('Submit')),
                                      //         ),
                                      //       ),
                                      //       ],
                                      //      ),
                                      //  ),
                                    ],
                                  ),
                                ),
                              ),
                              //const VerticalDivider(),
                              // Expanded(
                              //   flex: 3,
                              //   child: Opacity(
                              //     opacity: 0.95,
                              //     child: ListView(
                              //       //mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         InkWell(
                              //           onTap: () => context.read<AdminCubit>().pickLogoImage(),
                              //           child: Padding(
                              //             padding: smallPadding,
                              //             child: SizedBox(
                              //               width: SizeConfig.blockSizeHorizontal! * 16,
                              //               height: SizeConfig.blockSizeHorizontal! * 16,
                              //               child: Card(
                              //                 shape: RoundedRectangleBorder(
                              //                   borderRadius: BorderRadius.circular(
                              //                     20,
                              //                   ),
                              //                 ),
                              //                 child: schoolLogoLoading
                              //                     ? const Center(
                              //                         child: CircularProgressIndicator(),
                              //                       )
                              //                     : (_schoolImageLogo != null && _schoolImageLogo!.files.first.name.isNotEmpty)
                              //                         ? Image.memory(
                              //                             fit: BoxFit.cover,
                              //                             _schoolImageLogo!.files.first.bytes!,
                              //                           )
                              //                         : const Center(
                              //                             child: Row(
                              //                               mainAxisAlignment: MainAxisAlignment.center,
                              //                               children: [
                              //                                 Text(logoImage),
                              //                                 Padding(
                              //                                   padding: smallPadding,
                              //                                   child: Icon(
                              //                                     Icons.cloud_upload,
                              //                                   ),
                              //                                 )
                              //                               ],
                              //                             ),
                              //                           ),
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //         InkWell(
                              //           onTap: () => context.read<AdminCubit>().pickSchoolImage(),
                              //           child: Padding(
                              //             padding: smallPadding,
                              //             child: SizedBox(
                              //               width: SizeConfig.blockSizeHorizontal! * 16,
                              //               height: SizeConfig.blockSizeHorizontal! * 16,
                              //               child: Card(
                              //                 shape: RoundedRectangleBorder(
                              //                   borderRadius: BorderRadius.circular(
                              //                     20,
                              //                   ),
                              //                 ),
                              //                 child: schoolImageLoading
                              //                     ? const Center(
                              //                         child: CircularProgressIndicator(),
                              //                       )
                              //                     : (_schoolImageBanner != null && _schoolImageBanner!.files.first.name.isNotEmpty)
                              //                         ? Image.memory(
                              //                             fit: BoxFit.cover,
                              //                             _schoolImageBanner!.files.first.bytes!,
                              //                           )
                              //                         : const Center(
                              //                             child: Row(
                              //                               mainAxisAlignment: MainAxisAlignment.center,
                              //                               children: [
                              //                                 Text(schoolImage),
                              //                                 Padding(
                              //                                   padding: smallPadding,
                              //                                   child: Icon(
                              //                                     Icons.cloud_upload,
                              //                                   ),
                              //                                 )
                              //                               ],
                              //                             ),
                              //                           ),
                              //               ),
                              //             ),
                              //           ),
                              //         ),

                              //         // ElevatedButton(
                              //         //     onPressed: () => context.read<SchoolCubit>().uploadFiletoFolder(
                              //         //           _schoolImageLogo!.files.first.bytes!,
                              //         //           schoolImageLogoName,
                              //         //         ),
                              //         //     child: const Text('upload test'))
                              //         // Row(
                              //         //   children: [
                              //         //     ElevatedButton(onPressed: checkingValidation, child: const Text('check')),
                              //         //     ElevatedButton(
                              //         //         onPressed: () {
                              //         //           _formKey.currentState!.reset();
                              //         //           _schoolNameController.clear();
                              //         //           _schoolAffiliationNoController.clear();
                              //         //           _schoolBuildingNoController.clear();
                              //         //           _schoolStreetNameController.clear();
                              //         //           _schoolAreaNameController.clear();
                              //         //           _schoolStateNameController.clear();
                              //         //           _schoolPincodeController.clear();
                              //         //           _schoolContactNoController.clear();
                              //         //           _schoolLatLngSchoolController.clear();
                              //         //           setState(() => _schoolState = SchoolState());
                              //         //         },
                              //         //         child: const Text('clear')),
                              //         //   ],
                              //         // )
                              //       ],
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // RadioListTile<String>(
  //                                                     activeColor: brightness == Brightness.light ? lightDarkGreen : darkSoftRedAlert,
  //                                                     title: Text(
  //                                                       boards.elementAt(index),
  //                                                       style: Theme.of(context).textTheme.bodySmall,
  //                                                     ),
  //                                                     value: boards.elementAt(index),
  //                                                     groupValue: selectedBoard,
  //                                                     onChanged: (value) {
  //                                                       selectedBoard = value;
  //                                                       setState(() {});
  //                                                     },
  //                                                   ),

  String? checkStringOnlyValidation(String? value) {
    if (value == null || value.isEmpty) {
      return cannotBeEmpty;
    } else if (!_nameOnly.hasMatch(value)) {
      return lettersOnly;
    }
    return null;
  }

  String? checkspecialOnlyValidation(String? value) {
    if (value == null || value.isEmpty) {
      return cannotBeEmpty;
    } else if (!_specialnameonly.hasMatch(value)) {
      return lettersandspecialcharactersOnly;
    }
    return null;
  }

  String? checkAllcharOnly(String? value) {
    if (value == null || value.isEmpty) {
      return cannotBeEmpty;
    } else if (!_allcharOnly.hasMatch(value)) {
      return allcharOnly;
    }
    return null;
  }

  String? checkNameandNoOnlyValidation(String? value) {
    if (value == null || value.isEmpty) {
      return cannotBeEmpty;
    } else if (!_nameandnoOnly.hasMatch(value)) {
      return lettersandNumbersOnly;
    }
    return null;
  }

  String? checkNumbersOnlyValidation(String? value) {
    if (value == null || value.isEmpty) {
      return cannotBeEmpty;
    } else if (!_noOnly.hasMatch(value)) {
      return numberssOnly;
    }
    return null;
  }

  Future<void> checkingValidation() async {
    /// return true to indicate no errors
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Check all fields')));
    } else if (selectedBoards!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a board')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All are valid')));
      debugPrint('valid');
      final company = Company();
      imagesToUpload = {
        schoolImageLogoName: _schoolImageLogo?.files.first.bytes,
        schoolImageBannerName: _schoolImageBanner?.files.first.bytes,
      };
      final companyAddress = CompanyAddress(
        address_title: _schoolNameController.text,
        address_type: 'Office',
        address_line1: _schoolBuildingNoController.text,
        address_line2: _schoolStreetNameController.text,
        city: _schoolAreaNameController.text,
        country: 'India',
        county: _schoolNameController.text,
        email_id: 'test@gmail.com',
        state: _schoolStateNameController.text,
        pincode: _schoolPincodeController.text,
        phone: _schoolContactNoController.text,
        is_your_company_address: 1,
        links: [
          {'link_doctype': 'Company', 'link_name': _schoolNameController.text}
        ],
      );
      await context.read<SchoolCubit>().postCompany(
            imagesToUpload,
            company: company.copyWith(
              company_name: _schoolNameController.text,
              abbr: _schoolNameController.text,
              affiliation_number: _schoolAffiliationNoController.text,
              board: [],
              latlng: _schoolLatLngSchoolController.text,
              country: 'India',
              default_currency: 'INR',
            ),
            companyAddress: companyAddress,
          );
    }
    //debugPrint('valid');
  }

  Future<void> checkingSubmit() async {
    /// return true to indicate no errors
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Check all fields')));
    } else if (selectedBoards!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a board')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All are valid')));
      debugPrint('valid');
      final company = Company();
      imagesToUpload = {
        schoolImageLogoName: _schoolImageLogo?.files.first.bytes,
        schoolImageBannerName: _schoolImageBanner?.files.first.bytes,
      };
      final companyAddress = CompanyAddress(
        address_title: _schoolNameController.text,
        address_type: 'Office',
        address_line1: _schoolBuildingNoController.text,
        address_line2: _schoolStreetNameController.text,
        city: _schoolAreaNameController.text,
        country: 'India',
        county: _schoolNameController.text,
        email_id: 'test@gmail.com',
        state: _schoolStateNameController.text,
        pincode: _schoolPincodeController.text,
        phone: _schoolContactNoController.text,
        is_your_company_address: 1,
        links: [
          {'link_doctype': 'Company', 'link_name': _schoolNameController.text}
        ],
      );

      await context.read<SchoolCubit>().putCompanySubmit(
            imagesToUpload,
            company: company.copyWith(
              company_name: _schoolNameController.text,
              abbr: _schoolNameController.text,
              affiliation_number: _schoolAffiliationNoController.text,
              board: [],
              latlng: _schoolLatLngSchoolController.text,
              country: 'India',
              default_currency: 'INR',
            ),
            companyAddress: companyAddress,
          );
    }
    debugPrint('valid');
  }

  // void _resetForm() {
  //   _key.currentState!.reset();
  //   _schoolNameController.clear();
  //   setState(() => _schoolState = SchoolState());
  // }
}

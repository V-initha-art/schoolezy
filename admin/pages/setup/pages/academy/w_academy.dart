import 'package:admin/adminrepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:schoolezy/authentication/authentication.dart';
import 'package:schoolezy/pages/admin/cubit/admin_cubit.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/school/school.dart';
import 'package:schoolezy/utility/apppadding.dart';
import 'package:user/userrepo.dart';

class AcademyPage extends StatefulWidget {
  const AcademyPage({super.key});

  @override
  State<AcademyPage> createState() => _AcademyPageState();
}

class _AcademyPageState extends State<AcademyPage> {
  String? selectedAcademicYear;
  //String? selectedAcademicTerm;
  final DateTime _acadamicYear = DateTime.now();

  bool schoolAcadamicYearLoading = false;
  bool schoolAcadamicyearSubmitLoading = false;

  List<AcadamicYear>? acadamicYearList;
  AcademicTerms? acadamicTermList;
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd-MM-yyy');

  DateTime? _startDate;
  DateTime? _endDate;

  String dateRange = '';
  List<String> selectedDates = [];
  User? user;

  DateTime? current = DateTime.now();
  bool companyLoading = false;
  bool academicTermLoading = false;
  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(current!.year + 5),
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _startDateController.text = _dateFormat.format(_startDate!);
        updateDateRange();
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(current!.year + 5),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _endDateController.text = _dateFormat.format(_endDate!);
        updateDateRange();
      });
    }
  }

  void addDateRangeToList() {
    if (_startDate != null && _endDate != null) {
      final startYear = _startDate!.year;
      final endYear = _endDate!.year;
      final dateRangeText = '$startYear - $endYear';
      if (!selectedDates.contains(dateRangeText)) {
        setState(() {
          selectedDates.add(dateRangeText);
          //  showDetails.add(false);
          //_startDate = _startDateController.text;
          //_endDate = null;
          _startDateController.clear();
          _endDateController.clear();

          updateDateRange();
          // year = dateRangeText;
        });
      }
    }
  }

  void updateDateRange() {
    if (_startDate != null && _endDate != null) {
      dateRange = '${_startDate!.year} - ${_endDate!.year}';
    } else {
      dateRange = '';
    }
  }

  @override
  void didChangeDependencies() {
    context.read<SchoolCubit>().getAcadamicSchoolYear();
    context.read<SchoolCubit>().getCompany();
    context.read<AdminCubit>().getAcademicTerms();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _startDateController.text = _startDate != null ? _dateFormat.format(_startDate!) : '';
    _endDateController.text = _endDate != null ? _dateFormat.format(_endDate!) : '';
  }

  @override
  Widget build(BuildContext context) {
    user = context.read<AuthCubit>().state.user;
    return BlocListener<SchoolCubit, SchoolState>(
      listener: (context, state) {
        if (state is SchoolAcadamicyearSubmitFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error')),
          );
        }
      },
      child: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          if (state is AcademicTermsLoading) {
            academicTermLoading = true;
          }
          if (state is AcademicTermsSuccess) {
            acadamicTermList = state.academicTerms;
            academicTermLoading = false;
          }

          if (state is AcademicTermsAdminFailure) {
            academicTermLoading = false;
          }
          return BlocBuilder<SchoolCubit, SchoolState>(
            builder: (context, state) {
              if (state is SchoolAcadamicYearLoading) {
                schoolAcadamicYearLoading = true;
              }
              if (state is SchoolAcadamicYearSuccess) {
                acadamicYearList = state.acadamicYears;
                schoolAcadamicYearLoading = false;
              }
              if (state is SchoolAcadamicYearFailure) {
                schoolAcadamicYearLoading = false;
              }
              if (state is SchoolAcadamicyearSubmitLoading) {
                schoolAcadamicyearSubmitLoading = true;
              }
              if (state is SchoolAcadamicyearSubmitSuccess) {
                schoolAcadamicyearSubmitLoading = false;
              }
              if (state is SchoolAcadamicyearSubmitFailure) {
                schoolAcadamicyearSubmitLoading = false;
              }
              if (state is CompanyViewLoading) {
                companyLoading = true;
              }
              if (state is CompanyLoaded) {
                selectedAcademicYear = state.company!.academic_year;
                companyLoading = false;
              }
              if (state is CompanyFailure) {
                companyLoading = false;
              }

              return Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: largePadding,
                          child: Row(
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: smallPadding,
                                  child: TextField(
                                    readOnly: true,
                                    onTap: () => _selectStartDate(context),
                                    controller: _startDateController,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.date_range),
                                      labelText: 'Start Date',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: smallPadding,
                                  child: TextField(
                                    readOnly: true,
                                    onTap: () => _selectEndDate(context),
                                    controller: _endDateController,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.date_range),
                                      labelText: 'End Date',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_startDate != null && _endDate != null)
                                    context.read<SchoolCubit>().postAcadamicSchoolYear(
                                          dateRange,
                                          _startDate.toString(),
                                          _endDate.toString(),
                                        );
                                },
                                child: schoolAcadamicyearSubmitLoading ? const CircularProgressIndicator() : const Text('Add'),
                              ),
                            ],
                          ),
                        ),
                        if (schoolAcadamicYearLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          acadamicYearList != null && acadamicYearList!.isNotEmpty
                              ? Expanded(
                                  child: ListView(
                                  children: acadamicYearList?.map((academicYear) {
                                        // final index =
                                        //     acadamicYearList!.indexOf(academicYear);
                                        final isSelected = selectedAcademicYear == academicYear.academic_year_name;

                                        return ListTile(
                                          title: Text(academicYear.academic_year_name!),
                                          leading: Checkbox(
                                            value: isSelected,
                                            onChanged: (value) {
                                              setState(() {
                                                if (value != null) {
                                                  if (value) {
                                                    selectedAcademicYear = academicYear.academic_year_name;
                                                  } else {
                                                    selectedAcademicYear = null;
                                                  }
                                                }
                                              });
                                            },
                                          ),
                                          trailing: IconButton(
                                            onPressed: () {
                                              context.read<SchoolCubit>().deleteAcadamicSchoolYear(
                                                    academicYear.academic_year_name!,
                                                  );
                                            },
                                            icon: const Icon(Icons.delete),
                                          ),
                                        );
                                      }).toList() ??
                                      [],
                                ))
                              : const Text('no data'),
                      ],
                    ),
                  ),

                  // Expanded(
                  //   child: Center(
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Text(
                  //           'Current AcademyPage Year',
                  //           style: Theme.of(context)
                  //               .textTheme
                  //               .titleLarge
                  //               ?.merge(const TextStyle(
                  //                   fontWeight: FontWeight.bold)),
                  //         ),
                  //         if (companyLoading)
                  //           const Center(child: CircularProgressIndicator())
                  //         else
                  //           selectedAcademicYear != null &&
                  //                   selectedAcademicYear!.isNotEmpty
                  //               ? Text(
                  //                   selectedAcademicYear! ??
                  //                       'No academic year selected',
                  //                   style: Theme.of(context)
                  //                       .textTheme
                  //                       .displayLarge,
                  //                 )
                  //               : const Text('no Data'),
                  //         const SizedBox.square(
                  //           dimension: 50,
                  //         ),
                  //         // Text(selectedAcademicYear!),
                  //         Padding(
                  //           padding: mediumPadding,
                  //           child: ElevatedButton(
                  //               onPressed: () {
                  //                 final selectedYear = selectedAcademicYear;
                  //                 if (selectedYear != null) {
                  //                   context
                  //                       .read<AdminCubit>()
                  //                       .companyAcadmicYearUpdate(
                  //                         user!.message!.data!.school?.elementAt(0).company_name ?? 'no school',
                  //                         selectedYear,
                  //                       );
                  //                 }
                  //               },
                  //               child: const Text('Submit')),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const VerticalDivider(),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: extraxxLargePadding,
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          // Text(
                          //   'Current Academy Term',
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .titleLarge
                          //       ?.merge(const TextStyle(
                          //           fontWeight: FontWeight.bold)),
                          // ),
                          if (academicTermLoading)
                            const CircularProgressIndicator()
                          else
                            acadamicTermList != null && acadamicTermList!.data!.isNotEmpty
                                ? Expanded(
                                    child: ListView(
                                    children: List.generate(
                                        acadamicTermList!.data!.length,
                                        (index) => ListTile(
                                              title: Center(
                                                child: Text(
                                                  acadamicTermList!.data!.elementAt(index).term_name!,
                                                  style: Theme.of(context).textTheme.titleLarge,
                                                ),
                                              ),
                                            )),
                                  ))
                                : const Text('nodata')
                        ]),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}

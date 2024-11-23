import 'package:admin/adminrepo.dart';
import 'package:authentication/authenticationrepo.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localstorage/localstoragerepo.dart';
import 'package:schoolezy/app/cubit/app_cubit.dart';
import 'package:schoolezy/authentication/authentication.dart';
import 'package:schoolezy/cubits/attendance_cubit.dart';
import 'package:schoolezy/cubits/version_cubit.dart';
import 'package:schoolezy/l10n/l10n.dart';
import 'package:schoolezy/pages/admin/cubit/admin_cubit.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/classroom/classroom.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/employee/cubit/employee_cubit.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/school/school.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/student/cubit/student_cubit.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/teacher/cubit/teacher_cubit.dart';
import 'package:schoolezy/pages/assessment/cubit/assessment_cubit.dart';
import 'package:schoolezy/pages/bus/cubit/trackezy_cubit.dart';
import 'package:schoolezy/pages/communication/bloc/announcements_bloc.dart';
import 'package:schoolezy/pages/communication/bloc/events_bloc.dart';
import 'package:schoolezy/pages/communication/communication.dart';
import 'package:schoolezy/pages/dashboard/dashboard.dart';
import 'package:schoolezy/pages/driver/driver.dart';
import 'package:schoolezy/pages/fee/cubit/payfee_cubit.dart';
import 'package:schoolezy/pages/fee/fee.dart';
import 'package:schoolezy/pages/fees/cubit/fees_cubit.dart';
import 'package:schoolezy/pages/home/home.dart';
import 'package:schoolezy/pages/homework/bloc/homeworks_bloc.dart';
import 'package:schoolezy/pages/homework/bloc/upcominghomework_bloc.dart';
import 'package:schoolezy/pages/homework/cubit/upcominghomework_cubit.dart';
import 'package:schoolezy/pages/homework/homework.dart';
import 'package:schoolezy/pages/internet_connecting/cubit/internet_connectivity_cubit.dart';
import 'package:schoolezy/pages/leave/cubit/leave_cubit.dart';
import 'package:schoolezy/pages/login/login.dart';
import 'package:schoolezy/pages/lunch/cubit/lunch_cubit.dart';
import 'package:schoolezy/pages/notification/cubit/notification_page_cubit.dart';
import 'package:schoolezy/pages/profile/cubit/student_profile_cubit.dart';
import 'package:schoolezy/pages/support/cubit/support_cubit.dart';
import 'package:schoolezy/pages/teacher/cubit/teacher_cubit.dart';
import 'package:schoolezy/pages/teacher/pages/apply_leave/cubit/apply_leave_cubit.dart';
import 'package:schoolezy/pages/teacher/pages/assessment/cubit/assessment_cubit.dart';
import 'package:schoolezy/pages/teacher/pages/dashboard/cubit/teacher_dashboard_cubit.dart';

import 'package:schoolezy/pages/teacher/pages/teacher_announcement/bloc/teacherannouncement_bloc.dart';
import 'package:schoolezy/pages/teacher/pages/teacher_announcement/cubit/teacher_announcement_cubit.dart';
import 'package:schoolezy/pages/teacher/pages/teacher_attendance/cubit/teacherattendance_cubit.dart';
import 'package:schoolezy/pages/teacher/pages/teacher_calendar/cubit/t_school_calendar_cubit.dart';
import 'package:schoolezy/pages/teacher/pages/teacher_event/bloc/teacherevents_bloc.dart';
import 'package:schoolezy/pages/teacher/pages/teacher_event/cubit/teacher_event_cubit.dart';
import 'package:schoolezy/pages/teacher/pages/teacher_profile/cubit/teacher_profile_cubit.dart';
import 'package:schoolezy/pages/teacher/pages/teacher_timetable/cubit/teacher_timetable_cubit.dart';
import 'package:schoolezy/pages/time_table/cubit/timetable_cubit.dart';
import 'package:schoolezy/router/router.dart';
import 'package:schoolezy/utility/cubit/appbar_cubit.dart';
import 'package:support/support.dart';
import 'package:user/userrepo.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    required this.authenticationRepository,
    required this.userRepository,
    required this.adminRepository,
    required this.localStorageRepository,
    required this.supportRepository,
    this.connectivity,
  });
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final AdminRepository adminRepository;
  final LocalStorageRepository localStorageRepository;
  final SupportRepository supportRepository;

  final Connectivity? connectivity;
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Connectivity connectivity = Connectivity();
  @override
  Widget build(BuildContext context) {
    debugPrint('heelo app start call hive!');
    return RepositoryProvider.value(
      value: widget.authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (context) =>
                AppCubit(userRepository: widget.userRepository),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => ThemeCubit()..readThemeState(),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => AuthCubit(
              authenticationRepository: widget.authenticationRepository,
            ),
          ),
          BlocProvider(
              create: (context) => DashboardCubit(
                    widget.userRepository,
                    widget.adminRepository,
                  )),
          BlocProvider(
            lazy: false,
            create: (context) => LoginCubit(
              //  widget.localStorageRepository,
              widget.authenticationRepository,
              widget.userRepository,
              // widget.adminRepository,
            )..initPref(),
          ),
          BlocProvider(
            create: (context) => HomeCubit(
              widget.userRepository,
              widget.adminRepository,
              widget.localStorageRepository,
            ),
          ),
          BlocProvider(
            create: (context) =>
                SchoolCubit(widget.adminRepository, widget.userRepository),
          ),
          BlocProvider(
            create: (context) =>
                AdminCubit(widget.adminRepository, widget.userRepository),
          ),
          BlocProvider(
            create: (context) => CommunicationCubit(
                widget.adminRepository, widget.userRepository),
          ),
          BlocProvider(
            create: (context) => ClassroomCubit(widget.adminRepository),
          ),
          BlocProvider(
            create: (context) =>
                StudentCubit(widget.adminRepository, widget.userRepository),
          ),
          BlocProvider(
            create: (context) =>
                HomeworkCubit(widget.adminRepository, widget.userRepository),
          ),
          BlocProvider(
            create: (context) => FeesCubit(widget.adminRepository),
          ),
          BlocProvider(
            create: (context) => EmployeeCubit(widget.adminRepository),
          ),
          BlocProvider(
            create: (context) => TeacherCubit(widget.adminRepository),
          ),
          BlocProvider(
            create: (context) => TimetableCubit(widget.adminRepository),
          ),
          BlocProvider(
            create: (context) => AttendanceCubit(widget.userRepository),
          ),
          BlocProvider(
            create: (context) => FeeCubit(),
          ),
          BlocProvider(
            create: (context) => PaymentCubit(widget.userRepository),
          ),
          BlocProvider(
            create: (context) =>
                SupportCubit(widget.supportRepository, widget.userRepository),
          ),
          BlocProvider(
            create: (context) => AssessmentCubit(widget.adminRepository),
          ),
          BlocProvider(
            create: (context) => LeaveCubit(widget.userRepository),
          ),
          BlocProvider(
            create: (context) => TeacherAppCubit(
              widget.userRepository,
              widget.adminRepository,
            ),
          ),
          BlocProvider(
            create: (context) => TeacherattendanceCubit(widget.userRepository),
          ),
          // BlocProvider(
          //   create: (context) => TeacherHomeworkCubit(widget.userRepository, widget.adminRepository),
          // ),
          BlocProvider(
            create: (context) => TeacherTimetableCubit(
                widget.userRepository, widget.adminRepository),
          ),
          BlocProvider(
            create: (context) => TSchoolCalendarCubit(
              widget.adminRepository,
            ),
          ),
          BlocProvider(
            create: (context) =>
                TeacherAnnouncementCubit(widget.userRepository),
          ),
          BlocProvider(
            create: (context) => TeacherEventCubit(widget.userRepository),
          ),
          BlocProvider(
            create: (context) => ApplyLeaveCubit(widget.userRepository),
          ),
          BlocProvider(
              create: (context) => TeacherDashboardCubit(
                    widget.userRepository,
                  )),
          BlocProvider(
            create: (context) => AppbarCubit(widget.userRepository),
          ),
          BlocProvider(
            create: (context) => DriverCubit(widget.userRepository),
          ),
          BlocProvider(
            create: (context) => StudentProfileCubit(
                widget.adminRepository, widget.userRepository),
          ),
          BlocProvider(
            create: (context) => TrackezyCubit(widget.userRepository),
          ),
          BlocProvider(
            create: (context) => LunchCubit(widget.userRepository),
          ),
          BlocProvider(
            create: (context) => UpcominghomeworkCubit(widget.userRepository),
          ),
          BlocProvider(
            create: (context) => NotificationPageCubit(widget.userRepository),
          ),
          BlocProvider(
            create: (context) => TeacherProfileCubit(widget.userRepository),
          ),
          BlocProvider(
            create: (context) => NotificationPageCubit(widget.userRepository),
          ),
          BlocProvider(
            create: (context) => TeacherProfileCubit(widget.userRepository),
          ),
          BlocProvider(
            create: (context) => TeacherAssessmentCubit(
                widget.userRepository, widget.adminRepository),
          ),
          BlocProvider(
            create: (context) => VersionCubit(
              widget.userRepository,
            ),
          ),
          BlocProvider(
            create: (context) => PayfeeCubit(
              widget.userRepository,
            ),
          ),
          BlocProvider(
            create: (context) => InternetConnectivityCubit(
              widget.userRepository,
              connectivity: connectivity,
            ),
          ),
          BlocProvider(
            create: (context) => EventsBloc(
              widget.adminRepository,
              widget.userRepository,
            ),
          ),
          BlocProvider(
            create: (context) => AnnouncementsBloc(
              widget.adminRepository,
              widget.userRepository,
            ),
          ),
          BlocProvider(
            create: (context) => HomeworksBloc(
              widget.adminRepository,
              widget.userRepository,
            ),
          ),
          BlocProvider(
            create: (context) => UpcominghomeworkBloc(
              widget.adminRepository,
              widget.userRepository,
            ),
          ),
          BlocProvider(
            create: (context) => TeachereventsBloc(
              widget.adminRepository,
              widget.userRepository,
            ),
          ),
          BlocProvider(
              create: (context) => TeacherannouncementBloc(
                    widget.adminRepository,
                    widget.userRepository,
                  )),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  AppView({
    super.key,
  });

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  void initState() {
    context.read<AppCubit>().initLocalDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthCubit>();
    final router = routes(
      bloc,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, state) {
        return MaterialApp.router(
          theme: state,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        );
      },
    );
  }
}

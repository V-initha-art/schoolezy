import 'package:admin/adminrepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:schoolezy/pages/communication/communication.dart';
import 'package:schoolezy/utility/apppadding.dart';
import 'package:schoolezy/utility/sizeconfig.dart';

class WebAdminAttendance extends StatefulWidget {
  const WebAdminAttendance({super.key});

  @override
  State<WebAdminAttendance> createState() => _WebAdminAttendanceState();
}

class _WebAdminAttendanceState extends State<WebAdminAttendance> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: KeepAlive(),
    );
  }
}

class KeepAlive extends StatefulWidget {
  const KeepAlive({
    Key? key,
  }) : super(key: key);

  // final DateTime data;

  @override
  State<KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<KeepAlive> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  DateTime now = DateTime.now();
  String currentmonth = DateFormat.yMMMM().format(DateTime.now());
  DateTime targetmonth = DateTime.now();

  int startcurrentMonth = DateTime.january;
  int endcurrentMonth = DateTime.december;
  int currentMonth = DateTime.now().month;
  int currentDate = DateTime.now().day;
  int currentYear = DateTime.now().year;

  int lastday = 0;

  // List<int> currentMonthDates = [];

  // Map<String, Map<String, int>> getCurrentMonthDates(
  //     int startDate, int endDate) {
  //       final map =<String, Map<String, int>> {};
  // final DateTime dateTime = DateTime(currentYear);

  //   for (var i = startDate; i <= endDate; i++) {
  //    dateTime.

  //   }

  //   return {};
  // }

  @override
  void initState() {
    //TODO: implement initState
    // lastday = DateTime(currentYear, currentMonth + 1, 0).day;

    // print(currentDate.toString() + ' ' + lastday.toString());

    super.initState();
  }

  @override
  void didChangeDependencies() {
    context.read<CommunicationCubit>().getEventList();
    super.didChangeDependencies();
  }

  Events? eventList;
  bool isEventLoading = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizeConfig().init(context);

    // List<DateTime> allDatesOfCalendarMonth =
    //     getDatesForACalendarMonthAsUTC(dateTime: DateTime(currentYear,targetmonth.month));
    List<DateTime> allDatesOfCalendarMonth = getDatesForACalendarMonthAsUTC(dateTime: targetmonth);

    return BlocBuilder<CommunicationCubit, CommunicationState>(
      builder: (context, state) {
        if (state is EventSuccess) {
          eventList = state.events;
          isEventLoading = false;
        }
        if (state is EventLoading) {
          isEventLoading = true;
        }
        if (state is Failure) {
          isEventLoading = false;
        }
        return Scaffold(
          body: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentmonth,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            //  color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            // const SizedBox(
                            //   height: 14,
                            // ),
                            Card(
                              shape: RoundedRectangleBorder(
                                //   side: const BorderSide(color: Colors.white70, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  //   if(currentYear > DateTime(currentYear - 1).year){
                                  setState(() {
                                    //  int currentYear = DateTime.now().year;

                                    targetmonth = DateTime(
                                      targetmonth.year,
                                      targetmonth.month - 1,
                                    );
                                    // currentmonth = DateFormat.yMMMM().format(DateTime(currentYear,targetmonth.month));
                                    currentmonth = DateFormat.yMMMM().format(targetmonth);
                                  });
                                  //   }
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  // color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),

                            const SizedBox(
                              width: 10,
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                //    side: const BorderSide(color: Colors.white70, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  //  currentYear < DateTime(currentYear+1).year
                                  //   if(targetmonth.month <DateTime(targetmonth.month+1).year){

                                  setState(() {
                                    //int currentYear = DateTime.now().year;
                                    targetmonth = DateTime(
                                      targetmonth.year,
                                      targetmonth.month + 1,
                                    );
                                    // currentmonth = DateFormat.yMMMM().format(DateTime(currentYear,targetmonth.month));
                                    currentmonth = DateFormat.yMMMM().format(targetmonth);
                                  });
                                  //}
                                },
                                icon: const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  //   color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Text(
                        //   DateTime.now().year.toString(),
                        //   style: const TextStyle(
                        //       color: Colors.black,
                        //       fontSize: 22,
                        //       fontWeight: FontWeight.bold),
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Table(
                      border: TableBorder.all(width: 1.7),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'SUN',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  'MON',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  'TUE',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  'WED',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  'THU',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  'FRI',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  'SAT',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          //  crossAxisSpacing: 8,
                          mainAxisSpacing: 10,
                          crossAxisCount: 7,
                          //  mainAxisExtent: 40,
                        ),
                        itemCount: allDatesOfCalendarMonth.length,
                        itemBuilder: (context, index) {
                          return Table(
                            border: TableBorder.all(),
                            children: [
                              TableRow(
                                children: [
                                  DataWidget(
                                    isLoading: isEventLoading,
                                    events: eventList,
                                    startPriandCurrentdate: allDatesOfCalendarMonth[index],
                                    todayDateTime: targetmonth,
                                  )
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                flex: 2,
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: SizeConfig.blockSizeHorizontal! * 4,
                          ),
                          const Text(
                            '     Upcoming events',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isEventLoading)
                            Padding(
                              padding: smallPadding,
                              child: SizedBox.square(
                                dimension: SizeConfig.blockSizeHorizontal! * 1,
                                child: const CircularProgressIndicator(),
                              ),
                            )
                          else
                            const SizedBox(),
                        ],
                      ),
                      Text(
                        '     Donot miss scheduled events',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Padding(
                          padding: largePadding,
                          child: ListView.builder(
                            itemCount: 6,
                            itemBuilder: (BuildContext context, index) {
                              return Card(
                                //  color: Colors.amber,
                                margin: const EdgeInsets.only(top: 20),
                                shape: RoundedRectangleBorder(
                                  //side: const BorderSide(color: Colors.white70, width: 1),
                                  borderRadius: BorderRadius.circular(20),
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              size: 12,
                                            ),
                                            Text(
                                              '10 : 00 - 11 : 00',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.keyboard_control_outlined,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      ' Meeting with a client',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    Text(
                                      ' Tell How to boost website traffic',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: mediumPadding,
                        child: Card(
                          //  color: Colors.amber,
                          margin: const EdgeInsets.only(top: 20),
                          shape: RoundedRectangleBorder(
                            //side: const BorderSide(color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(
                                    Icons.ac_unit,
                                    size: 14,
                                  ),
                                  Text(
                                    '  conversion history',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Text(
                                'Week to week performance',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(color: Colors.white70, width: 1),
                                    borderRadius: BorderRadius.circular(4.0), //<-- SEE HERE
                                  ),
                                  child: Padding(
                                    padding: mediumPadding,
                                    child: Text(
                                      'see more ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class DataWidget extends StatelessWidget {
  const DataWidget({
    super.key,
    required this.startPriandCurrentdate,
    required this.todayDateTime,
    this.events,
    required this.isLoading,
  });

  final DateTime startPriandCurrentdate;
  final DateTime todayDateTime;
  final Events? events;
  final bool isLoading;
  String getDateString(DateTime dataDateTime) {
    final dateFormat = DateFormat.EEEE().format(dataDateTime);
    // print(dataDateTime);

    return dateFormat;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Row(
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: BorderSide.none,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
          ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
          onPressed: startPriandCurrentdate.month == todayDateTime.month ? () {} : null,
          child: Container(
            width: SizeConfig.blockSizeHorizontal! * 7,
            height: SizeConfig.blockSizeHorizontal! * 8,
            // color: const Color.fromARGB(255, 255, 7, 172),
            decoration: const BoxDecoration(
              border: Border(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, right: 4),
                      child: Column(
                        children: [
                          Text(
                            startPriandCurrentdate.day.toString(),
                            style: TextStyle(
                              color: getDateString(startPriandCurrentdate).contains('Sunday')
                                  ? Colors.red
                                  : todayDateTime.month == startPriandCurrentdate.month
                                      ? Colors.amber
                                      : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isLoading)
                  SizedBox()
                else
                  (events != null && events!.data!.isNotEmpty)
                      ? Flexible(
                          child: ListView(
                            children: events!.data!.map(
                              (e) {
                                final present = DateFormat('yyyy-MM-dd').format(startPriandCurrentdate);
                                final presentDate = DateTime.parse(present);
                                final eventDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(e.start_date!));
                                if (presentDate.isAtSameMomentAs(DateTime.parse(eventDate))) {
                                  return Text(e.title ?? '');
                                }
                                return SizedBox();
                              },
                            ).toList(),
                          ),
                        )
                      : SizedBox()

                //      if (events != null && events!.data!.isNotEmpty)
                //     d2.isAtSameMomentAs(d3) ?
                //      Text('${events!.data!.elementAt(0).title}')

                //  //   Text('${events!.data!.first.title}')
                //         : const SizedBox()

                //     else const SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

List<DateTime> getDatesForACalendarMonthAsUTC({required DateTime dateTime}) {
  List<DateTime> calendarMonthDaysAsUTC = [];

  final DateTime currentDateofMonth = DateTime.utc(dateTime.year, dateTime.month, 1);

  final DateTime firstdateOfMonth = DateTime.utc(currentDateofMonth.year, currentDateofMonth.month, 1);

  final DateTime lastDateOfMonth = DateTime.utc(currentDateofMonth.year, currentDateofMonth.month + 1, 0);

  List<DateTime> datesFirstToLastDayOfMonthAsUTC = getDaysInBetweenIncludingStartEndDate(
    startDateTime: firstdateOfMonth,
    endDateTime: lastDateOfMonth,
  );

  calendarMonthDaysAsUTC = List.from(datesFirstToLastDayOfMonthAsUTC);

  final int firstDayOfMonthWeekDay = firstdateOfMonth.weekday;

  for (int i = 1; i <= firstDayOfMonthWeekDay && firstDayOfMonthWeekDay != 7; i++) {
    calendarMonthDaysAsUTC.insert(
      0,
      firstdateOfMonth.subtract(Duration(days: i)),
    );
  }

  //int daysLeftAfterMonthEndDate = 42 - calendarMonthDaysAsUTC.length;
  //print('daysLeftAfterMonthEndDate............33333333........${daysLeftAfterMonthEndDate}');

  // for (int i = 1; i <= daysLeftAfterMonthEndDate; i++) {
  //   calendarMonthDaysAsUTC.add(lastDayOfMonthAsUTC.add(Duration(days: i)));
  //  // print('calendarMonthDaysAsUtc.........222222222.........${calendarMonthDaysAsUTC}');
  // }
  return calendarMonthDaysAsUTC;
}

List<DateTime> getDaysInBetweenIncludingStartEndDate({
  required DateTime startDateTime,
  required DateTime endDateTime,
}) {
  final DateTime startDate = DateTime.utc(startDateTime.year, startDateTime.month, startDateTime.day);

  final DateTime endDate = DateTime.utc(endDateTime.year, endDateTime.month, endDateTime.day);

  List<DateTime> daysInFormat = [];

  for (DateTime i = startDate; i.isBefore(endDate) || i.isAtSameMomentAs(endDate); i = i.add(const Duration(days: 1))) {
    if (startDateTime.isUtc) {
      daysInFormat.add(i);
    } else {
      daysInFormat.add(DateTime(i.year, i.month, i.day));
    }
  }
  return daysInFormat;
}

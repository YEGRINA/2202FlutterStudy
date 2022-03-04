import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils.dart';
import '../screens/listPage.dart';

class TableEventsExample extends StatefulWidget {
  @override

  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<dynamic>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month; // 달력 형태,
  DateTime _focusedDay = DateTime.now(); // 오늘
  DateTime? _selectedDay;
  // late final EdgeInsets cellPadding;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override

  /// DateTime 인자를 받아 List를 출력해주는 함수 -> 데이터 모델 list로 반환
  List<dynamic> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // if (!isSameDay(_selectedDay, selectedDay)) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    _selectedEvents.value = _getEventsForDay(selectedDay);
    print(selectedDay);
    print(focusedDay);
    Navigator.push(context, CupertinoPageRoute(builder: (context) => ListPage(selectedDay: selectedDay.toString().split(' ')[0])));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
              child: TableCalendar<dynamic>(
                // locale: 'ko-KR',  // 언어 설정, 기본은 영어임
                shouldFillViewport: true,
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                headerStyle: const HeaderStyle(
                  titleTextStyle: TextStyle(color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold),
                  headerMargin: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 15),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.black, fontSize: 17),
                  weekendStyle: TextStyle(color: Colors.red, fontSize: 17),
                ),
                calendarStyle: CalendarStyle(
                    defaultTextStyle:
                    TextStyle(color: Colors.black45, fontSize: 18),
                    weekendTextStyle:
                    TextStyle(color: Colors.red, fontSize: 18),
                    outsideDaysVisible: false, // 이전, 혹은 다음 달의 날짜 표시여부
                    todayDecoration: BoxDecoration(
                      // 오늘의 날짜 꾸미기
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blueAccent, width: 1.5)),
                    todayTextStyle: const TextStyle(
                      // 오늘의 날짜 글씨 꾸미기
                      // color: Colors.black45,
                        fontSize: 18)
                ),
                onDaySelected: _onDaySelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
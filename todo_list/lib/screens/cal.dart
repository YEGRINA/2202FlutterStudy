import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../screens/listPage.dart';
import 'package:todo_list/db/dbHelper.dart';
import '../db/todo.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, 1, 1);
final kLastDay = DateTime(2024, 12, 31);

class TableEventsExample extends StatefulWidget {
  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<dynamic>> _selectedEvents;
  late Map<DateTime, List> _events; // 이벤트 있는 날짜 저장됨
  CalendarFormat _calendarFormat = CalendarFormat.month; // 달력 형태 -> 버튼으로
  DateTime _focusedDay = DateTime.now(); // 오늘
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _events = {};
    getDates();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  /// DateTime 인자를 받아 List를 출력해주는 함수 -> 데이터 모델 list로 반환
  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  Future<void> _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    _selectedEvents.value = _getEventsForDay(selectedDay);
    await Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                ListPage(selectedDay: selectedDay.toString())));
    setState(() {
      getDates();
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: TableCalendar<dynamic>(
                // 동그라미 색 다르게 하는거
                calendarBuilders:
                    CalendarBuilders(singleMarkerBuilder: (context, date, _) {
                  // print('color');
                  // print(_events);
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: listEquals(_events[date], ['true'])
                          ? Colors.lightGreen
                          : Colors.black,
                    ),
                    width: 10,
                    height: 10,
                  );
                }),
                // locale: 'ko-KR',  // 언어 설정, 기본은 영어임
                shouldFillViewport: true,
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                eventLoader: _getEventsForDay,
                headerStyle: const HeaderStyle(
                  titleTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                  headerMargin: EdgeInsets.only(top: 25, bottom: 15),
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
                        border:
                            Border.all(color: Color(0xFF5C6BC0), width: 1.5)),
                    todayTextStyle: const TextStyle(
                        // 오늘의 날짜 글씨 꾸미기
                        // color: Colors.black45,
                        fontSize: 18)),
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

  Future<void> getDates() async {
    DBHelper sd = DBHelper();
    List<Todo> allList = await sd.todoes();
    _events = {};

    String year, mon, day;
    Set set = Set();
    for (int i = 0; i < allList.length; i++) {
      year = allList[i].date.split(' ')[0].split('-')[0];
      mon = allList[i].date.split(' ')[0].split('-')[1];
      day = allList[i].date.split(' ')[0].split('-')[2];
      // print('$year $mon $day');
      // _events[DateTime.utc(int.parse(year), int.parse(mon), int.parse(day))] = ['Event'];
      if (!set.contains('$year $mon $day')) {
        set.add('$year $mon $day');
        _events[DateTime.utc(int.parse(year), int.parse(mon), int.parse(day))] =
            ['true'];
      }
      if (set.contains('$year $mon $day') && allList[i].checked == 0) {
        _events[DateTime.utc(int.parse(year), int.parse(mon), int.parse(day))] =
            ['false'];
      }
    }

    // print('getDate');
    // print(_events);
    // print('=======================');

    // todo가 true -> false 일 때(반대도) 바로 반영이 안됨,, (getDates 끝나기 전에 build 실행되기 때문)
    // 그래서 getDates에서 build 샐행함 (근데 이렇게 하는거 맞나?)
    setState(() {
      build(context);
    });
  }
}

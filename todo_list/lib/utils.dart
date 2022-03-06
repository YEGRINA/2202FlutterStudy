import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';
import 'events.dart';

// class Event {
//   String todos;
//   bool haveTodos;
//   Event(this.todos, this.haveTodos);
//
//   @override
//   String toString() => todos;
// }

final kEvents = LinkedHashMap(
  equals: isSameDay,  // isSameDay 함수 실행으로 equal 여부를 판단하도록 사용자 정의
  hashCode: getHashCode,  // 같은 객체 있는 지 확인하고
)..addAll(_events);  // 객체 생성과 동시에 addAll 메소드 실행

// 여기를 바꾸면 됨! 여기가 데이터야
final Map<DateTime, dynamic> _events = {
  loadTodo().runtimeType, true
} as Map<DateTime, dynamic>;

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}


final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, 1,1);
final kLastDay = DateTime(kToday.year, 12, 31);


// final Map<DateTime, dynamic> testMap = {};
//
// Future<Map<DateTime, dynamic>> getEventsList() async {
//   var data = await FirebaseFirestore.instance.collection('events').get();
//
//   for (int i = 0; i < data.docs.length; i++) {
//     var time = (data.docs[i]['date'] as Timestamp).toDate();
//     var title = Event(data.docs[i]['title']);
//     testMap[time] = title;
//   }
//   return testMap;
// }
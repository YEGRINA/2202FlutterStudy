import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';
import 'events.dart';

final kEvents = LinkedHashMap(
  equals: isSameDay,  // isSameDay 함수 실행으로 equal 여부를 판단하도록 사용자 정의
  hashCode: getHashCode,  // 같은 객체 있는 지 확인하고
)..addAll(_events);  // 객체 생성과 동시에 addAll 메소드 실행

// 여기를 바꾸면 됨! 여기가 데이터야
final Map<int, List> _events = {
  loadTodo().hashCode : ['Event']
} as Map<int, List>;

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, 1,1);
final kLastDay = DateTime(kToday.year, 12, 31);

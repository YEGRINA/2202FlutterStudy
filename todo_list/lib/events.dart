import '../db/todo.dart';
import 'db/dbHelper.dart';

Future<List<Todo>> loadTodo() async {
  DBHelper sd = DBHelper();
  List<Todo> allEvents = await sd.todoes();

  List<Todo> datList = [];
  for (int i = 0; i < allEvents.length; i++) {
    if (allEvents[i].date.split(' ')[0] != null) {
      datList.add(allEvents[i]);
    }
  }
  return datList;
}
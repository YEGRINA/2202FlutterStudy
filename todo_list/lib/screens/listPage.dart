import 'package:flutter/material.dart';
import 'package:todo_list/db/dbHelper.dart';
import '../db/todo.dart';

class ListPage extends StatefulWidget {
  ListPage({Key? key, required this.selectedDay}) : super(key: key);
  final String selectedDay;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final _controller = TextEditingController();
  final _categories = ['전체', '장보기', '학업', '단어장'];
  String selectedCategory = '전체';
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20), // 원하는 방향에 padding 주기
            child: DropdownButton(
              value: selectedCategory,
              items: _categories
                  .map((value) =>
                      DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              underline: Container(
                color: Colors.transparent,
              ),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          checkboxBuilder(context),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(width: 1, color: Colors.grey))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: TextField(
                  controller: _controller,
                  onChanged: (String text) {
                    this.text = text;
                  },
                  textInputAction: TextInputAction.go, // enter 이벤트 처리
                  onSubmitted: (value) {
                    // enter 이벤트 처리
                    if (text != '') {
                      setState(() {
                        saveTodo();
                        _controller.clear(); // text clear
                      });
                    }
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(left: 15, top: 20, bottom: 20)),
                )),
                IconButton(
                  onPressed: () {
                    if (text != '') {
                      setState(() {
                        saveTodo();
                        _controller.clear(); // text clear
                      });
                    }
                  },
                  icon: Icon(Icons.add_box),
                  color: Colors.blue,
                  iconSize: 30,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget checkboxBuilder(BuildContext parentContext) {
    return FutureBuilder(
        future: loadTodo(),
        builder: (context, snapshot) {
          List<Todo> todoes;
          if (snapshot.connectionState == ConnectionState.done) {
            todoes = snapshot.data as List<Todo>;
            return Expanded(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: todoes.length,
                  itemBuilder: (context, index) {
                    Todo todo = todoes[index];
                    bool isChecked = false;
                    if (todo.checked == 1) {
                      isChecked = true;
                    }
                    return InkWell(
                      onLongPress: () {
                        showAlertDialog(context, todo);
                      },
                      child: Dismissible(
                        key: UniqueKey(),
                        onDismissed: (DismissDirection direction) {
                          setState(() {
                            // items.removeAt(index);
                            deleteTodo(todo.date);
                          });
                        },
                        background: Card(
                            child: Center(
                              child: Text('D E L E T E',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30)),
                            ),
                            color: Colors.red),
                        child: Card(
                          // memo 있을 때와 없을 때 위젯을 각각 생성
                          child: todo.memo != ''
                              ? CheckboxListTile(
                                  title: Text(todo.text),
                                  subtitle: Text(todo.memo),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isChecked = value!;

                                      int checked = 0;
                                      if (isChecked) {
                                        checked = 1;
                                      }
                                      updateTodo(todo, todo.memo, checked);
                                    });
                                  },
                                )
                              : CheckboxListTile(
                                  title: Text(todo.text),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isChecked = value!;

                                      int checked = 0;
                                      if (isChecked) {
                                        checked = 1;
                                      }
                                      updateTodo(todo, todo.memo, checked);
                                    });
                                  },
                                ),
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return Expanded(
                child: Container(
              child: null,
            ));
          }
        });
  }

  void showAlertDialog(BuildContext context, Todo todo) async {
    String memo = '';
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('메모를 입력하세요!'),
            content: TextField(onChanged: (String text) {
              memo = text;
            }),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      updateTodo(todo, memo, todo.checked);
                    });
                    Navigator.pop(context);
                  },
                  child: Text('확인')),
            ],
          );
        });
  }

  Future<List<Todo>> loadTodo() async {
    DBHelper sd = DBHelper();
    List<Todo> allList = await sd.todoes();

    // 모든 데이터 출력 (그냥 확인용)
    for (int i = 0; i < allList.length; i++) {
      print(allList[i].text +
          ' ' +
          allList[i].date +
          ' ' +
          allList[i].category +
          ' ' +
          allList[i].memo +
          ' ' +
          allList[i].checked.toString());
    }
    print('=======================');

    // 선택된 날짜에 맞는 데이터 선별
    List<Todo> datList = [];
    for (int i = 0; i < allList.length; i++) {
      if (allList[i].date.split(' ')[0] == widget.selectedDay) {
        datList.add(allList[i]);
      }
    }

    // '전체' 카테고리이면 모든 데이터 반환
    if (selectedCategory == '전체') {
      return datList;
    }

    // 선택된 카테고리에 맞는 데이터 선별
    List<Todo> list = [];
    for (int i = 0; i < datList.length; i++) {
      if (datList[i].category == selectedCategory) {
        list.add(datList[i]);
      }
    }
    return list;
  }

  Future<void> saveTodo() async {
    DBHelper sd = DBHelper();

    var fido = Todo(
        date: DateTime.now().toString(),
        category: selectedCategory,
        text: text,
        memo: '',
        checked: 0 // 처음 todo를 추가할 때는 무조건 false
    );

    await sd.insertTodo(fido);
  }

  Future<void> deleteTodo(String date) async {
    DBHelper sd = DBHelper();
    await sd.deleteTodo(date);
  }

  Future<void> updateTodo(Todo todo, String memo, int checked) async {
    DBHelper sd = DBHelper();

    var fido = Todo(
        date: todo.date,
        category: todo.category,
        text: todo.text,
        memo: memo,
        checked: checked);

    await sd.updateTodo(fido);
  }
}

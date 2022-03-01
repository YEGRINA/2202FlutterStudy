import 'package:flutter/material.dart';
import 'package:todo_list/db/dbHelper.dart';
import '../db/todo.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  // var items = <String>[];
  final _categories = ['전체', '장보기', '학업'];
  String selectedCategory = '전체';
  // bool _isChecked = false;
  String text = '';
  String memo = '';

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
                  onChanged: (String text) {
                    this.text = text;
                  },
                  textInputAction: TextInputAction.go, // enter 이벤트 처리
                  onSubmitted: (value) {
                    // enter 이벤트 처리
                    if (text != '') {
                      setState(() {
                        // items.add('$text');
                        saveDB();
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
                        // items.add('$text');
                        saveDB();
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {  // hasData가 왜 안 먹혀ㅠㅠ
          todoes = snapshot.data as List<Todo>;
          // if (todoes.isEmpty) {
          //   print('empty');
          //   return Expanded(
          //       child: Container(
          //     child: null,
          //   ));
          // }
          print('not empty');
          return Expanded(
            child: ListView.builder(
                // scrollDirection: Axis.vertical,
                // shrinkWrap: true,
                itemCount: todoes.length,
                itemBuilder: (context, index) {
                  Todo todo = todoes[index];
                  bool _isChecked;
                  if (todo.checked == 0) {
                    _isChecked = false;
                  } else {
                    _isChecked = true;
                  }
                  return InkWell(
                    onLongPress: () {
                      showAlertDialog(context);
                    },
                    child: Dismissible(
                      key: UniqueKey(), // 중간 삭제해도 오류 안남!
                      onDismissed: (DismissDirection direction) {
                        setState(() {
                          // items.removeAt(index);
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
                        child: CheckboxListTile(
                          title: Text(todo.text),
                          subtitle: Text(todo.memo),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _isChecked,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  );
                }),
          );} else {
            return Expanded(
                child: Container(
                  child: Text('no data'),
                ));
          }
        });
  }

  void showAlertDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('메모를 입력하세요!'),
            content: TextField(),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('확인')),
            ],
          );
        });
  }

  Future<void> saveDB() async {
    DBHelper sd = DBHelper();

    var fido = Todo(
        date: DateTime.now().toString(),
        category: this.selectedCategory,
        text: this.text,
        memo: this.memo,
        checked: 0 // 처음 todo를 추가할 때는 무조건 false
        );

    await sd.insertTodo(fido);
    print(await sd.todoes());
  }

  Future<List<Todo>> loadTodo() async {
    DBHelper sd = DBHelper();
    return await sd.todoes();
  }
}

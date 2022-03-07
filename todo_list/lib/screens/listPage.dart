import 'package:flutter/material.dart';
import 'package:todo_list/db/dbHelper.dart';
import '../db/category.dart';
import '../db/dbHelper2.dart';
import '../db/todo.dart';

class ListPage extends StatefulWidget {
  ListPage({Key? key, required this.selectedDay}) : super(key: key);
  final String selectedDay;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final _controller = TextEditingController();
  // final _categories = ['전체', '장보기', '학업', '단어장'];
  String selectedCategory = '전체';
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$selectedCategory'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, // Handle your on tap here.
          icon: Icon(Icons.arrow_back),
        ),
        // actions: [
        // Padding(
        //   padding: const EdgeInsets.only(right: 20), // 원하는 방향에 padding 주기
        //   child: DropdownButton(
        //     value: selectedCategory,
        //     items: _categories
        //         .map((value) =>
        //             DropdownMenuItem(value: value, child: Text(value)))
        //         .toList(),
        //     onChanged: (String? value) {
        //       setState(() {
        //         selectedCategory = value!;
        //       });
        //     },
        //     underline: Container(
        //       color: Colors.transparent,
        //     ),
        //   ),
        // )
        // ],
      ),
      endDrawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    child: const DrawerHeader(
                      decoration: BoxDecoration(color: Colors.blue),
                      child: Text(
                        '카테고리',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            categoryBuilder(context),
            Row(
              children: [
                Expanded(
                    child: IconButton(
                  onPressed: () {
                    categoryInsertDialog(context);
                  },
                  icon: Icon(Icons.add),
                )),
              ],
            )
          ],
        ),
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
                        memoDialog(context, todo);
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

  Widget categoryBuilder(BuildContext parentContext) {
    return FutureBuilder(
        future: loadCategory(),
        builder: (context, snapshot) {
          List<Category> categories;
          if (snapshot.connectionState == ConnectionState.done) {
            categories = snapshot.data as List<Category>;
            return Expanded(
              child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    Category c = categories[index];
                    return ListTile(
                      title: Text(c.name),
                      onTap: () {
                        setState(() {
                          selectedCategory = c.name;
                          Navigator.pop(context);
                        });
                      },
                      onLongPress: () {
                        if (c.name == '전체') {
                          categoryDeleteErrorDialog(context);
                        } else {
                          categoryDeleteDialog(context, c.name);
                        }
                      },
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

  void memoDialog(BuildContext context, Todo todo) async {
    String memo = '';
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('메모 추가'),
            content: TextField(
                decoration: InputDecoration(labelText: '내용'),
                onChanged: (String text) {
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

  void categoryInsertDialog(BuildContext context) async {
    String name = '';
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('카테고리 추가'),
            content: TextField(
                decoration: InputDecoration(labelText: '이름'),
                onChanged: (String text) {
                  name = text;
                }),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      saveCategory(name);
                    });
                    Navigator.pop(context);
                  },
                  child: Text('확인')),
            ],
          );
        });
  }

  void categoryDeleteDialog(BuildContext context, String name) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '정말 삭제하시겠습니까?',
              style: TextStyle(color: Colors.red),
            ),
            content: Text('해당 카테고리의 모든 내용이 삭제됩니다'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('취소')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      deleteCategory(name);
                      deleteTodoAsCategory(name);
                      selectedCategory = '전체';
                    });
                    Navigator.pop(context);
                  },
                  child: Text('삭제', style: TextStyle(color: Colors.red))),
            ],
          );
        });
  }

  void categoryDeleteErrorDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '알림',
            ),
            content: Text('"전체" 카테고리는 삭제할 수 없습니다'),
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

  Future<List<Category>> loadCategory() async {
    DBHelper2 sd = DBHelper2();
    List<Category> list = await sd.categories();
    return list;
  }

  Future<void> saveCategory(String name) async {
    DBHelper2 sd = DBHelper2();

    var fido = Category(name: name);

    await sd.insert(fido);
  }

  Future<void> deleteCategory(String name) async {
    DBHelper2 sd = DBHelper2();
    await sd.delete(name);
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
      if (allList[i].date.split(' ')[0] == widget.selectedDay.split(' ')[0]) {
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
        date: widget.selectedDay.split(' ')[0] +
            ' ' +
            DateTime.now().toString().split(' ')[1],
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

  Future<void> deleteTodoAsCategory(String name) async {
    DBHelper sd = DBHelper();
    await sd.deleteTodoAsCategory(name);
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

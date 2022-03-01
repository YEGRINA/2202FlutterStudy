import 'package:flutter/material.dart';

class Todo extends StatefulWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  var items = <String>[];
  final _categories = ['전체', '장보기', '학업'];
  var _selectedCategory = '전체';
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20), // 원하는 방향에 padding 주기
            child: DropdownButton(
              value: _selectedCategory,
              items: _categories
                  .map((value) =>
                  DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedCategory = value!;
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
                      textInputAction: TextInputAction.go, // enter 이벤트 처리
                      onSubmitted: (value) {
                        // enter 이벤트 처리
                        setState(() {
                          items.add('a');
                        });
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                          EdgeInsets.only(left: 15, top: 20, bottom: 20)),
                    )),
                IconButton(
                  onPressed: () {
                    setState(() {
                      items.add('a');
                    });
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

  Widget checkboxBuilder(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        // scrollDirection: Axis.vertical,
        // shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return InkWell(
              onLongPress: () {
                showAlertDialog(context);
              },
              child: Dismissible(
                key: UniqueKey(), // 중간 삭제해도 오류 안남!
                onDismissed: (DismissDirection direction) {
                  setState(() {
                    items.removeAt(index);
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
                    title: Text('$item'),
                    subtitle: Text('dd'),
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
    );
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
}
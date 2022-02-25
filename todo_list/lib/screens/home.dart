import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, CupertinoPageRoute(builder: (context) => List()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

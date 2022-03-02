import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_list/screens/cal.dart';


void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized(); // 가로모드
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return ScreenUtilInit(
    designSize: Size(360,690),
        minTextAdapt: true,
        splitScreenMode: true,
      builder: () =>
          MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DIY Calendar',

        builder: (context, child) {
          ScreenUtil.setContext(context);
          return MediaQuery(  // 폰트 사이즈 builder로 고정
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!);
         },
            theme: ThemeData(primarySwatch: Colors.blue,),
            home: StartPage(),
      ));
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DIY CALENDAR',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Center(
        child:
        TextButton(
          child: Text('Start your CALENDAR',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TableEventsExample()),
          ),
        ),
      ),
    );
  }
}
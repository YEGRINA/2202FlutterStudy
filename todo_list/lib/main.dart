import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/cal.dart';
// import 'pages/basics_example.dart';
void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DIY Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartPage(),
    );
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
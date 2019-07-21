import 'package:flutter/material.dart';
import 'package:expandable_dialogs/expandable_dialogs.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Expandable Dialog demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.navigate_next),
        onPressed: () {
          ExpandableDialog.show(
            context: context,
            child: Builder(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: ExpandableStatus.of(context).isExpanded
                      ? Text("You can closeMe")
                      : Text("DragUpToExpand"),
                  actions: <Widget>[
                    IconButton(icon: Icon(Icons.open_in_new), onPressed: () {})
                  ],
                ),
                body: Center(
                  child: ExpandableStatus.of(context).isExpanded
                      ? Text("Expanded", style: TextStyle(fontSize: 50.0),)
                      : Text("Floating", style: TextStyle(fontSize: 50.0),),
                ),
              ),
            ),
            verticalOnly: true,
//            topPadding: 80.0,
//            bottomPadding: 16.0,
//            leftPadding: 16.0,
//            rightPadding: 16.0,
          );
        },
      ),
      body: Container(
          child: Container(
        color: Colors.blueGrey,
      )),
    );
  }
}

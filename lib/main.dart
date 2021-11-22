import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

const listLength = 100;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'RefreshIndicator'),
      scrollBehavior: MyCustomScrollBehavior(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<String> _list;

  @override
  void initState() {
    _list = List.generate(listLength, (index) => index.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: RefreshIndicator(
          // functional changes
          onRefresh: _refresh,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          // Visual changes
          backgroundColor: Colors.red,
          color: Colors.yellow,
          displacement: 200,
          edgeOffset: 0,
          strokeWidth: 5,
          // actual list
          child: ListView.builder(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: listLength,
            itemBuilder: (context, index) {
              return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(_list[index]),
                  ));
            },
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() {
    return _getNewList().then((value) => setState(() {
      _list = value;
    }));
  }

  Future<List<String>> _getNewList() async {
    Random r = Random();
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(listLength, (index) => r.nextInt(200).toString());
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
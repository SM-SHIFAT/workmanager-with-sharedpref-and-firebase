import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'functions/workmanager_callback.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // workmanager initialize
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Workmanager example"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Workmanager().registerOneOffTask(
                  "task1",
                  "OneOffTask",
                  tag: "1",
                  existingWorkPolicy: ExistingWorkPolicy.replace,
                  initialDelay: Duration(seconds: 3),
                  constraints: Constraints(networkType: NetworkType.connected),
                  backoffPolicy: BackoffPolicy.linear,
                  backoffPolicyDelay: Duration(seconds: 10),
                  inputData: {"data": 1},
                );
              },
              child: Text("start a oneoff task"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("start a preodic task"),
            ),
          ],
        ),
      ),
    );
  }
}

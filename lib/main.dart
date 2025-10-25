import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:process_run/process_run.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String Uri = '';

  @override
  void initState() {
    if (!kIsWeb) {
      Platform.isWindows ? initConnections() : null;
    }
    super.initState();
  }

  Future<void> initConnections() async {
    await _initChromeServer();
  }

  Future<void> generateCloudflareSession() async {
    var shell = Shell();
    // await shell.run('cloudflared tunnel --url http://localhost:$port/');
  }

  Future<void> _initChromeServer() async {
    var process = await Process.start('flutter', ["run", "-d", "chrome"],
        runInShell: true);
    // process.stdin.write('flutter run -d chrome');
    // process.stdout.listen((event) {
    //   print(">>>> $event");
    // });
    process.stdout.forEach(print);
    process.stdout.transform(utf8.decoder).forEach((element) async {
      print(element);
      if (element.contains("A Dart VM Service on Chrome is available at:")) {
        String port = element.split("//").last.split("/").first.split(":").last;
        if (port != '') {
          // await generateCloudflareSession();
          process.stdin.writeln("Uri.base");
        }
      }
      // if (element.contains())
    });
    // var result = await shell.run('flutter run -d chrome');
    // print(">>>> $result");
    // dynamic result = await Process.run('cloudflared', ['tunnel', '--url', 'http://localhost:53426/']);
    // print(">>>> $result");y
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: !kIsWeb
          ? Platform.isWindows
              ? Colors.black
              : Colors.white
          : Colors.white,
      appBar: !kIsWeb
          ? Platform.isWindows
              ? null
              : AppBar(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  title: Text(widget.title),
                )
          : AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
            ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }
}

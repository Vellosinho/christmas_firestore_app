import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloudflare_test/controller/windows_process_controller.dart';
import 'package:cloudflare_test/firebase_options.dart';
import 'package:cloudflare_test/games/beer_game/beer_game_desktop.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:process_run/process_run.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => WindowsProcessController()),
    ],
    child: const MyApp()));
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
  String uri = '';

  @override
  void initState() {
    if (!kIsWeb) {
      Platform.isWindows ? initConnections() : null;
    }
    super.initState();
  }

  Future<void> initConnections() async {
    await _initChromeClient();
  }

  Future<void> generateCloudflareSession() async {
    StreamSink<List<int>>? stdoutInstance;
    var shell = Shell(stdout: stdoutInstance);
    var result = shell.run('cloudflared tunnel --url http://localhost:8080/');
    // // print(">>>>>>>>> ${result}");
    // result.listen((element) {
    //   print(">>>element");
    // });
    // var process = await Process.run('cloudflared', ["--version"]);
    // process.stdout.listen((element) async {
    //   String decoded = utf8.decode(element);
    //   print("stream2: $decoded");
    //   if (decoded.contains("A Dart VM Service on Chrome is available at:")) {
    //     await generateCloudflareSession();
    //   }
      
    // });
    // stdout.addStream(cloudflaredProcess.stdout);

  }

  Future<void> _initChromeClient() async {
    var process = await Process.start('flutter', ["run", "-d", "chrome", "--web-port", "8080"],
      runInShell: true);

    process.stdout.listen((element) async {
      String decoded = utf8.decode(element);
      print("stream1: $decoded");
      if (decoded.contains("A Dart VM Service on Chrome is available at:")) {
        await generateCloudflareSession();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return kIsWeb ? BeerGameDesktop() : Scaffold(
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

import 'package:bouncing_loading_button/bouncing_loading_button.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loading Button Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading1 = false;
  bool _isDone1 = false;
  bool _isLoading2 = false;
  bool _isDone2 = false;
  bool _isLoading3 = false;
  bool _isDone3 = false;

  Future<void> _handlePress1() async {
    setState(() {
      _isLoading1 = true;
      _isDone1 = false;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      _isLoading1 = false;
      _isDone1 = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isDone1 = false;
    });
  }

  Future<void> _handlePress2() async {
    setState(() {
      _isLoading2 = true;
      _isDone2 = false;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      _isLoading2 = false;
      _isDone2 = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isDone2 = false;
    });
  }

  Future<void> _handlePress3() async {
    setState(() {
      _isLoading3 = true;
      _isDone3 = false;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      _isLoading3 = false;
      _isDone3 = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isDone3 = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingButton(
                label: 'Filled Button',
                isLoading: _isLoading1,
                isDone: _isDone1,
                onPressed: _handlePress1,
                style: LoadingButtonStyle(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  borderRadius: 50.0,
                  width: 150.0,
                  height: 50.0,
                  fontSize: 18.0,
                  elevation: 4.0,
                  fontWeight: FontWeight.bold,
                  loadingIconSize: 28.0,
                  doneIconSize: 28.0,
                  loadingStrokeWidth: 3.0,
                  doneStrokeWidth: 2.5,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              const SizedBox(height: 50),
              LoadingButton(
                label: 'Outlined Button',
                isLoading: _isLoading2,
                isDone: _isDone2,
                onPressed: _handlePress2,
                style: LoadingButtonStyle(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.deepPurpleAccent,
                  borderRadius: 50.0,
                  width: 150.0,
                  height: 50.0,
                  fontSize: 18.0,
                  elevation: 0.0,
                  isOutlined: true,
                  outlineWidth: 2.0,
                  fontWeight: FontWeight.bold,
                  loadingIconSize: 28.0,
                  doneIconSize: 28.0,
                  loadingStrokeWidth: 3.0,
                  doneStrokeWidth: 2.5,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              const SizedBox(height: 50),
              LoadingButton(
                label: 'Text Button',
                isLoading: _isLoading3,
                isDone: _isDone3,
                onPressed: _handlePress3,
                style: LoadingButtonStyle(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.deepPurpleAccent,
                  borderRadius: 50.0,
                  width: 150.0,
                  height: 50.0,
                  fontSize: 18.0,
                  elevation: 0.0,
                  fontWeight: FontWeight.bold,
                  loadingIconSize: 28.0,
                  doneIconSize: 28.0,
                  loadingStrokeWidth: 3.0,
                  doneStrokeWidth: 2.5,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
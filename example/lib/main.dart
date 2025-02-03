import 'package:flutter/material.dart';
import 'package:loading_button/loading_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loading Button Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  bool _isLoading = false;
  bool _isDone = false;

  Future<void> _handlePress() async {
    setState(() {
      _isLoading = true;
      _isDone = false;
    });
    // Simulate some work
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _isDone = true;
    });
    // Reset after showing done state
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isDone = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading Button Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: LoadingButton(
          label: 'Press Me',
          isLoading: _isLoading,
          isDone: _isDone,
          onPressed: _handlePress,
          style: LoadingButtonStyle(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            borderRadius: 16.0,
            width: 150.0,
            height: 50.0,
            fontSize: 18.0,
            elevation: 8.0,
          ),
        ),
      ),
    );
  }
}
# Loading Button

A customizable Flutter widget that transforms a regular button into an interactive loading and completion button with smooth animations. This widget is ideal for use cases where actions require asynchronous operations, like API calls or form submissions.

## Features

- Animated loading indicator
- Bounce effect on completion
- Customizable button style (colors, size, border radius, etc.)
- Simple integration with minimal code

## Demo

![Loading Button Demo](demo.gif) *(Add a GIF demonstrating the button in action)*

## Getting Started

### Installation

Clone this repository or copy the `loading_button.dart` file into your Flutter project.

### Usage

```dart
import 'package:flutter/material.dart';
import 'loading_button.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _isDone = true;
    });
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
```

## Customization

You can customize the `LoadingButton` using the `LoadingButtonStyle` class:

- **borderRadius**: Adjusts the roundness of the button corners.
- **backgroundColor**: Changes the button's background color.
- **foregroundColor**: Sets the text and icon color.
- **width & height**: Defines button size.
- **fontSize**: Adjusts the label text size.
- **elevation**: Adds shadow for a floating effect.

### Example

```dart
LoadingButtonStyle(
  backgroundColor: Colors.green,
  foregroundColor: Colors.white,
  borderRadius: 20.0,
  width: 180.0,
  height: 60.0,
  fontSize: 20.0,
  elevation: 10.0,
);
```

## How It Works

- **Loading State:** Displays an animated circular progress indicator.
- **Done State:** Shows a checkmark with a bounce animation.
- **Idle State:** Displays the button label.

## Contributing

Feel free to fork the repository, submit issues, or make pull requests.

## License

This project is licensed under the MIT License.


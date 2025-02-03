import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/loading_button.dart';

void main() {
  testWidgets('LoadingButton displays label text when not loading', (WidgetTester tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoadingButton(
            label: 'Test Button',
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    expect(find.text('Test Button'), findsOneWidget);
    expect(find.byType(CustomPaint), findsNothing);
  });

  testWidgets('LoadingButton shows loading indicator when isLoading is true', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoadingButton(
            label: 'Test Button',
            isLoading: true,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('Test Button'), findsNothing);
    expect(find.byType(CustomPaint), findsOneWidget);
  });

  testWidgets('LoadingButton shows checkmark when isDone is true', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoadingButton(
            label: 'Test Button',
            isDone: true,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('Test Button'), findsNothing);
    expect(find.byType(CustomPaint), findsOneWidget);
  });

  testWidgets('LoadingButton onPressed callback is triggered', (WidgetTester tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoadingButton(
            label: 'Test Button',
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(LoadingButton));
    expect(pressed, true);
  });

  testWidgets('LoadingButton onPressed is not triggered when loading', (WidgetTester tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoadingButton(
            label: 'Test Button',
            isLoading: true,
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(LoadingButton));
    expect(pressed, false);
  });

  testWidgets('LoadingButton applies custom style correctly', (WidgetTester tester) async {
    const customStyle = LoadingButtonStyle(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      width: 200.0,
      height: 60.0,
      fontSize: 20.0,
      borderRadius: 10.0,
      elevation: 8.0,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoadingButton(
            label: 'Test Button',
            style: customStyle,
            onPressed: () {},
          ),
        ),
      ),
    );

    final button = tester.widget<LoadingButton>(find.byType(LoadingButton));
    expect(button.style.backgroundColor, Colors.red);
    expect(button.style.foregroundColor, Colors.white);
    expect(button.style.width, 200.0);
    expect(button.style.height, 60.0);
    expect(button.style.fontSize, 20.0);
    expect(button.style.borderRadius, 10.0);
    expect(button.style.elevation, 8.0);
  });

  testWidgets('LoadingButton changes size when loading', (WidgetTester tester) async {
    const style = LoadingButtonStyle(
      width: 150.0,
      height: 50.0,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoadingButton(
            label: 'Test Button',
            style: style,
            onPressed: () {},
          ),
        ),
      ),
    );

    // Get initial size
    final initialSize = tester.getSize(find.byType(AnimatedContainer));
    expect(initialSize.width, 150.0);

    // Update to loading state
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoadingButton(
            label: 'Test Button',
            style: style,
            isLoading: true,
            onPressed: () {},
          ),
        ),
      ),
    );

    // Wait for animation to complete
    await tester.pumpAndSettle();

    // Get size after loading
    final loadingSize = tester.getSize(find.byType(AnimatedContainer));
    expect(loadingSize.width, 50.0); // Should be equal to height when loading
    expect(loadingSize.height, 50.0);
  });

  testWidgets('LoadingButton outlined style is applied correctly', (WidgetTester tester) async {
    const outlinedStyle = LoadingButtonStyle(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.blue,
      isOutlined: true,
      outlineWidth: 2.0,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoadingButton(
            label: 'Test Button',
            style: outlinedStyle,
            onPressed: () {},
          ),
        ),
      ),
    );

    final button = tester.widget<LoadingButton>(find.byType(LoadingButton));
    expect(button.style.isOutlined, true);
    expect(button.style.outlineWidth, 2.0);
  });
}

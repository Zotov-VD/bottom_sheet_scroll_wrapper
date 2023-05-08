import 'package:example/example_bottom_modal_sheet.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Hello World!'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () =>
                      const ExampleBottomModalSheet().show(context),
                  child: const Text('Open bottom sheet'),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

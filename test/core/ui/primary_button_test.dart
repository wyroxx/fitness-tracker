import 'package:fitness_tracker/core/ui/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildButton({required bool isEnabled, required VoidCallback onTap}) {
    return MaterialApp(
      home: Scaffold(
        body: PrimaryButton(
          text: 'Save',
          width: 120,
          height: 48,
          isEnabled: isEnabled,
          onPressed: onTap,
        ),
      ),
    );
  }

  testWidgets('calls onPressed when enabled', (tester) async {
    var taps = 0;

    await tester.pumpWidget(buildButton(isEnabled: true, onTap: () => taps++));
    await tester.tap(find.text('Save'));

    expect(taps, 1);
  });

  testWidgets('does not call onPressed when disabled', (tester) async {
    var taps = 0;

    await tester.pumpWidget(buildButton(isEnabled: false, onTap: () => taps++));
    await tester.tap(find.text('Save'));

    expect(taps, 0);
  });
}
